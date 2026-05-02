import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single legal section result from search
class LegalResult {
  final String actId;
  final String actName;
  final String sectionNumber;
  final String heading;
  final String text;
  final double score;

  LegalResult({
    required this.actId,
    required this.actName,
    required this.sectionNumber,
    required this.heading,
    required this.text,
    required this.score,
  });
}

/// A single curated knowledge-base entry result
class KbResult {
  final String id;
  final String category;
  final String title;
  final String answer;
  final double score;

  KbResult({
    required this.id,
    required this.category,
    required this.title,
    required this.answer,
    required this.score,
  });
}

/// Loaded act data
class _ActData {
  final String actId;
  final String actName;
  final List<Map<String, dynamic>> sections;

  _ActData({required this.actId, required this.actName, required this.sections});
}

/// Loaded curated KB entry
class _KbEntry {
  final String id;
  final String category;
  final String title;
  final List<String> keywords;
  final String answer;
  final Set<String> titleWords;
  final Set<String> answerWords;

  _KbEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.keywords,
    required this.answer,
    required this.titleWords,
    required this.answerWords,
  });
}

/// The core offline legal search engine.
///
/// Improvements over the naive keyword scorer:
/// 1. IDF (inverse document frequency) weighting — generic words like
///    "punishment", "procedure", "section" carry far less weight than
///    specific topical words like "theft", "rape", "dowry".
/// 2. A robust stop-word list filters out filler words (what, the, is, ...).
/// 3. Synonym expansion (steal -> theft, kidnap -> abduction, etc.).
/// 4. Explicit Act detection — "BNS section 103" boosts ONLY BNS section 103
///    instead of returning section 103 from all three Acts at equal score.
/// 5. Constitutional Article queries ("Article 21") deliberately bypass the
///    section search (the bundled JSON has no Constitution data) and fall
///    through to curated, hand-written answers.
/// 6. Confidence threshold — when the best score is below the threshold the
///    engine returns NO results, so the user gets a clean "couldn't find"
///    response instead of a random low-quality match.
class OfflineLegalEngine {
  final List<_ActData> _acts = [];
  final List<_KbEntry> _kb = [];
  bool _isLoaded = false;

  /// In-flight load future. The first call to [load] kicks off the work and
  /// stores the future here; every subsequent caller awaits the SAME future
  /// instead of starting a parallel load. This is what fixes the
  /// "first message after opening sometimes fails" race condition.
  Future<void>? _loadingFuture;

  /// Inverse-document-frequency weight per word, computed from headings.
  final Map<String, double> _idf = {};

  static const String _kbAssetPath = 'assets/data/knowledge_base.json';

  static const Map<String, String> _actNames = {
    'BNS-2023': 'Bharatiya Nyaya Sanhita (BNS) 2023',
    'BNSS-2023': 'Bharatiya Nagarik Suraksha Sanhita (BNSS) 2023',
    'BSA-2023': 'Bharatiya Sakshya Adhiniyam (BSA) 2023',
  };

  static const Map<String, String> _assetPaths = {
    'BNS-2023': 'assets/data/bns_en.json',
    'BNSS-2023': 'assets/data/bnss_en.json',
    'BSA-2023': 'assets/data/bsa_en.json',
  };

  /// Words that add no topical signal — filtered out before scoring.
  static const Set<String> _stopWords = {
    'a','an','the','is','are','was','were','be','been','being','am',
    'of','in','on','at','to','for','from','by','with','about','as',
    'it','its','this','that','these','those','there','here',
    'what','which','who','whom','whose','how','why','when','where',
    'can','could','should','would','shall','will','may','might','must',
    'do','does','did','done','doing','have','has','had','having',
    'i','me','my','we','our','you','your','he','she','they','them','their',
    'him','her','his','hers',
    'some','any','all','each','every','no','not','nor','or','and','but',
    'if','then','than','so','such','only','also','even','just','very',
    'more','most','less','least','please','tell','explain','describe',
    'define','meaning','means','definition','information','info','give',
    'show','provide','need','want','know','understand',
    'law','laws','legal','section','sections','article','articles','act',
    'under','between','case','cases','file','filed','filing',
    'india','indian','make','made','best','place','places','eat',
  };

  /// Topic synonym groups — query word -> all variants are scored.
  static const Map<String, List<String>> _aliasGroups = {
    'theft': ['theft', 'stealing', 'steal', 'stolen'],
    'murder': ['murder', 'homicide', 'kill', 'killing', 'killed'],
    'rape': ['rape', 'raped', 'rapes'],
    'arrest': ['arrest', 'arrested', 'detention', 'custody'],
    'bail': ['bail', 'bond'],
    'evidence': ['evidence', 'proof', 'witness', 'testimony'],
    'cheating': ['cheating', 'cheat', 'fraud', 'fraudulent', 'deceit'],
    'forgery': ['forgery', 'forge', 'counterfeit', 'forged'],
    'kidnap': ['kidnap', 'kidnapping', 'kidnaps', 'abduction', 'abduct', 'abducting'],
    'assault': ['assault', 'attack'],
    'dowry': ['dowry'],
    'defamation': ['defamation', 'defame', 'libel', 'slander'],
    'fir': ['fir'],
    'sexual': ['sexual', 'sexually'],
    'child': ['child', 'children', 'minor', 'minors'],
  };

  /// Phrases that select a specific Act when present in the query.
  static const List<List<String>> _actFilters = [
    // Order matters: more specific phrases first.
    ['bnss', 'BNSS-2023'],
    ['bharatiya nagarik', 'BNSS-2023'],
    ['nagarik suraksha', 'BNSS-2023'],
    ['crpc', 'BNSS-2023'],
    ['bsa', 'BSA-2023'],
    ['bharatiya sakshya', 'BSA-2023'],
    ['sakshya adhiniyam', 'BSA-2023'],
    ['evidence act', 'BSA-2023'],
    ['bns', 'BNS-2023'],
    ['bharatiya nyaya', 'BNS-2023'],
    ['nyaya sanhita', 'BNS-2023'],
    ['ipc', 'BNS-2023'],
  ];

  /// Load all assets (BNS/BNSS/BSA + KB). Safe to call concurrently — every
  /// caller awaits the same in-flight future, so the work runs exactly once.
  Future<void> load() {
    if (_isLoaded) return Future.value();
    return _loadingFuture ??= _doLoad();
  }

  Future<void> _doLoad() async {
    for (final entry in _assetPaths.entries) {
      try {
        final raw = await rootBundle.loadString(entry.value);
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final sections = (data['sections'] as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .toList();
        _acts.add(_ActData(
          actId: entry.key,
          actName: _actNames[entry.key] ?? entry.key,
          sections: sections,
        ));
      } catch (e, st) {
        developer.log(
          'Failed to load ${entry.value}',
          name: 'OfflineLegalEngine',
          error: e,
          stackTrace: st,
        );
      }
    }
    await _loadKnowledgeBase();
    _buildIdf();
    _isLoaded = true;
  }

  /// Load the curated knowledge-base JSON.
  ///
  /// If the asset can't be loaded for any reason (forgot to register in
  /// pubspec.yaml, didn't rebuild, asset corrupted), we fall back to a
  /// minimal hard-coded KB so the assistant still works for the most-asked
  /// questions. The error is logged via dart:developer so it shows in
  /// `flutter logs` for debugging.
  Future<void> _loadKnowledgeBase() async {
    try {
      final raw = await rootBundle.loadString(_kbAssetPath);
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final entries = (data['entries'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>();
      _ingestKbEntries(entries);
      developer.log('Loaded ${_kb.length} KB entries from asset',
          name: 'OfflineLegalEngine');
    } catch (e, st) {
      developer.log(
        'Failed to load knowledge_base.json — falling back to inline KB. '
        'Did you forget to run `flutter pub get` after editing pubspec.yaml?',
        name: 'OfflineLegalEngine',
        error: e,
        stackTrace: st,
      );
      _ingestKbEntries(_inlineFallbackEntries());
    }
  }

  /// Ingest KB entries from the provided iterable into `_kb`.
  void _ingestKbEntries(Iterable<Map<String, dynamic>> entries) {
    final wordRe = RegExp(r'[a-z]+');
    for (final e in entries) {
      final title = (e['title'] ?? '').toString();
      final answer = (e['answer'] ?? '').toString();
      final keywords = (e['keywords'] as List<dynamic>? ?? [])
          .map((k) => k.toString().toLowerCase())
          .toList();
      final titleWords = wordRe
          .allMatches(title.toLowerCase())
          .map((m) => m.group(0)!)
          .toSet();
      final answerWords = wordRe
          .allMatches(answer.toLowerCase())
          .map((m) => m.group(0)!)
          .toSet();
      _kb.add(_KbEntry(
        id: (e['id'] ?? '').toString(),
        category: (e['category'] ?? '').toString(),
        title: title,
        keywords: keywords,
        answer: answer,
        titleWords: titleWords,
        answerWords: answerWords,
      ));
    }
  }

  /// Hard-coded minimal KB used as a safety net when the JSON asset can't be
  /// loaded. Covers the highest-traffic questions so the assistant remains
  /// useful even if the asset bundling is broken.
  List<Map<String, dynamic>> _inlineFallbackEntries() {
    return [
      {
        'id': 'art-14',
        'category': 'constitution-article',
        'title': 'Article 14 – Right to Equality',
        'keywords': ['article 14', 'equality before', 'equal protection'],
        'answer':
            '"The State shall not deny to any person equality before the law or the equal protection of the laws within the territory of India."\n\nKey ideas:\n• Equality before the law — no one is above the law\n• Equal protection of the laws — same law applied equally to all in similar situations\n• Prohibits arbitrary State action\n• Permits reasonable classification (treating different groups differently if there is a rational basis)',
      },
      {
        'id': 'art-19',
        'category': 'constitution-article',
        'title': 'Article 19 – Right to Freedom',
        'keywords': ['article 19', 'freedom of speech', 'free speech'],
        'answer':
            'Article 19 guarantees six freedoms to citizens:\n1. Freedom of speech and expression\n2. Freedom to assemble peaceably and without arms\n3. Freedom to form associations or unions\n4. Freedom to move freely throughout India\n5. Freedom to reside and settle in any part of India\n6. Freedom to practise any profession or carry on any occupation, trade or business\n\nAll freedoms are subject to reasonable restrictions imposed by the State.',
      },
      {
        'id': 'art-21',
        'category': 'constitution-article',
        'title': 'Article 21 – Right to Life and Personal Liberty',
        'keywords': ['article 21', 'right to life', 'personal liberty'],
        'answer':
            '"No person shall be deprived of his life or personal liberty except according to procedure established by law."\n\nThis is the most expansively interpreted Fundamental Right. The Supreme Court has read into it: right to privacy (Puttaswamy, 2017), dignity, education, clean environment, livelihood, health, shelter, and legal aid.',
      },
      {
        'id': 'art-22',
        'category': 'constitution-article',
        'title': 'Article 22 – Protection Against Arbitrary Arrest',
        'keywords': ['article 22', 'preventive detention'],
        'answer':
            'Every person who is arrested has the right to:\n• Be informed of the grounds of arrest as soon as possible\n• Consult and be defended by a legal practitioner of choice\n• Be produced before the nearest Magistrate within 24 hours of arrest\n• Not be detained beyond 24 hours without the Magistrate\'s authorisation',
      },
      {
        'id': 'art-32',
        'category': 'constitution-article',
        'title': 'Article 32 – Right to Constitutional Remedies',
        'keywords': ['article 32', 'writ', 'writs', 'constitutional remedies'],
        'answer':
            'Article 32 lets every citizen move the Supreme Court directly to enforce Fundamental Rights. The SC can issue five writs:\n• Habeas Corpus — produce the body\n• Mandamus — we command\n• Prohibition — stop a lower court exceeding jurisdiction\n• Certiorari — quash an order without jurisdiction\n• Quo Warranto — by what authority\n\nDr. Ambedkar called this article "the heart and soul of the Constitution."',
      },
      {
        'id': 'fundamental-rights',
        'category': 'topic',
        'title': 'Fundamental Rights – Overview',
        'keywords': ['fundamental rights', 'basic rights', 'part iii'],
        'answer':
            'Fundamental Rights (Part III, Articles 12–35) are guaranteed to every citizen.\n\nSix categories:\n1. Right to Equality (14–18)\n2. Right to Freedom (19–22)\n3. Right Against Exploitation (23–24)\n4. Right to Freedom of Religion (25–28)\n5. Cultural and Educational Rights (29–30)\n6. Right to Constitutional Remedies (32)',
      },
      {
        'id': 'act-rti',
        'category': 'act',
        'title': 'Right to Information Act, 2005 (RTI Act)',
        'keywords': ['rti', 'rti act', 'right to information'],
        'answer':
            'The RTI Act, 2005 gives every Indian citizen the right to request information from any public authority.\n\nKey points:\n• Apply in writing or electronically to the Public Information Officer (PIO) with a fee of ₹10\n• Information must be provided within 30 days (48 hours if it concerns life or liberty)\n• Some information is exempt (national security, cabinet papers, personal info without public interest)\n• Appeals can be made to the First Appellate Authority and then to the Information Commission\n• BPL applicants are exempt from fees',
      },
      {
        'id': 'act-pwd-rpwd',
        'category': 'act',
        'title': 'Rights of Persons with Disabilities Act, 2016 (RPwD / PWD Act)',
        'keywords': ['pwd act', 'rpwd', 'persons with disabilities', 'disability act'],
        'answer':
            'The RPwD Act, 2016 (commonly called the "PWD Act") replaced the older 1995 Act.\n\nKey points:\n• Recognises 21 types of disabilities (autism, cerebral palsy, dwarfism, acid attack victims, learning disabilities, mental illness, etc.)\n• 4% reservation in government jobs (1% each for blindness, deaf, locomotor; 1% for autism/intellectual)\n• 5% reservation in higher education in government-aided institutions\n• Free education for children with benchmark disabilities aged 6–18\n• Penalty for discrimination: up to 6 months / ₹10,000 (or both); enhanced for repeat offenders',
      },
      {
        'id': 'act-mv',
        'category': 'act',
        'title': 'Motor Vehicles Act, 1988 (as amended 2019)',
        'keywords': ['motor vehicles act', 'mv act', 'traffic rules'],
        'answer':
            '2019 amendment increased penalties significantly:\n• Driving without licence: ₹5,000\n• Drunk driving: ₹10,000 + 6 months (first offence)\n• Over-speeding: ₹1,000–2,000\n• No insurance: ₹2,000\n• No seat belt / no helmet: ₹1,000\n• Mobile while driving: ₹1,000–5,000\n• Juvenile offences: guardians held responsible',
      },
      {
        'id': 'act-it',
        'category': 'act',
        'title': 'Information Technology Act, 2000 (IT Act)',
        'keywords': ['it act', 'information technology act', 'cybercrime'],
        'answer':
            'Primary law for electronic transactions and cybercrime in India.\n• Sec 43 — civil liability for unauthorised access, data theft\n• Sec 66 — hacking (3 years / ₹5 lakh)\n• Sec 66C — identity theft\n• Sec 66D — cheating by personation using a computer\n• Sec 66E — capturing/publishing private images\n• Sec 67/67A/67B — obscene / sexually explicit / child pornography\n• Sec 79 — intermediary safe harbour',
      },
      {
        'id': 'topic-fir',
        'category': 'topic',
        'title': 'How to File an FIR',
        'keywords': ['fir', 'first information report', 'file fir', 'police complaint'],
        'answer':
            'An FIR is the first written record of a cognisable offence.\n\n1. Visit the police station with jurisdiction. Any station can register a Zero FIR.\n2. Narrate the incident; the SHO must reduce it to writing.\n3. Read it back, sign after verifying.\n4. You are entitled to a free copy.\n\nIf police refuse to register: send a written complaint to the SP, approach the Magistrate under BNSS Sec 175(3), or file a writ in the High Court.',
      },
      {
        'id': 'topic-bail',
        'category': 'topic',
        'title': 'Bail – Bailable vs Non-Bailable',
        'keywords': ['bail', 'bailable', 'non bailable', 'anticipatory bail'],
        'answer':
            'Bailable: bail is a matter of right; police/court must release on bond.\nNon-bailable: bail is discretionary; court considers gravity, evidence, flight risk.\nAnticipatory bail (BNSS Sec 482): apply BEFORE arrest if you fear arrest in a non-bailable case.\nDefault bail: if charge-sheet not filed within 60/90/180 days, accused entitled to bail.',
      },
      {
        'id': 'topic-arrest-rights',
        'category': 'topic',
        'title': 'Your Rights When Arrested',
        'keywords': ['rights when arrested', 'arrest rights', 'arrested by police'],
        'answer':
            'Under Article 22 + BNSS:\n• Right to know the grounds of arrest\n• Right to consult a lawyer of your choice\n• Right to be produced before a Magistrate within 24 hours\n• Right to inform a friend/relative of the arrest and place of detention\n• Right to medical examination at the time of arrest\n• Right against self-incrimination\n• Right to free legal aid if you cannot afford a lawyer',
      },
    ];
  }

  /// Build IDF weights from heading words.
  /// idf(w) = ln((N + 1) / (df(w) + 1)), floored at 0.1
  void _buildIdf() {
    final docFreq = <String, int>{};
    int totalSecs = 0;
    final wordRe = RegExp(r'[a-z]+');
    for (final act in _acts) {
      for (final s in act.sections) {
        totalSecs++;
        final heading = (s['heading'] ?? '').toString().toLowerCase();
        final seen = <String>{};
        for (final m in wordRe.allMatches(heading)) {
          seen.add(m.group(0)!);
        }
        for (final w in seen) {
          docFreq[w] = (docFreq[w] ?? 0) + 1;
        }
      }
    }
    for (final entry in docFreq.entries) {
      final v = math.log((totalSecs + 1) / (entry.value + 1));
      _idf[entry.key] = v < 0.1 ? 0.1 : v;
    }
  }

  double _idfOf(String w) => _idf[w] ?? 1.0;

  /// Detect Act filter from the query (returns Act ID like "BNS-2023" or null).
  String? _detectActFilter(String query) {
    final q = query.toLowerCase();
    for (final pair in _actFilters) {
      if (q.contains(pair[0])) return pair[1];
    }
    return null;
  }

  /// Detect explicit "section N" reference. Recognises:
  ///   "section 103", "sec 103", "sec. 103", "s. 103", "s.103"
  /// and (when an Act keyword like BNS/BNSS/BSA is present) bare numbers:
  ///   "BNS 103", "explain me bns 21", "bnss section 35"
  /// Returns the section number string (lowercased, may end with a letter
  /// like "103a") or null.
  String? _detectSection(String query) {
    final m = RegExp(r'(?:section|sec\.?|s\.)\s*(\d+[a-z]?)',
            caseSensitive: false)
        .firstMatch(query);
    if (m != null) return m.group(1)?.toLowerCase();

    // Article queries are explicitly NOT sections — never grab the number.
    if (RegExp(r'\barticle\s*\d+', caseSensitive: false).hasMatch(query)) {
      return null;
    }

    // Bare number after an Act keyword: "BNS 21", "bnss 103"
    final bareAct = RegExp(
            r'\b(?:bns|bnss|bsa|ipc|crpc)\s+(\d+[a-z]?)\b',
            caseSensitive: false)
        .firstMatch(query);
    if (bareAct != null) return bareAct.group(1)?.toLowerCase();

    return null;
  }

  /// True if the query is asking about a constitutional Article.
  bool _isArticleQuery(String query) {
    return RegExp(r'\barticle\s*\d+', caseSensitive: false).hasMatch(query);
  }

  /// Tokenize the query into scored keywords (after stop-word removal and
  /// alias expansion).
  List<String> _tokenize(String query) {
    final words = RegExp(r'[a-z]+')
        .allMatches(query.toLowerCase())
        .map((m) => m.group(0)!)
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toList();

    final expanded = <String>[];
    void addUnique(String w) {
      if (!expanded.contains(w)) expanded.add(w);
    }

    for (final w in words) {
      var aliased = false;
      for (final group in _aliasGroups.values) {
        if (group.contains(w)) {
          for (final s in group) {
            addUnique(s);
          }
          aliased = true;
          break;
        }
      }
      if (!aliased) addUnique(w);
    }
    return expanded;
  }

  /// Smart keyword search across all acts.
  List<LegalResult> search(String query, {int limit = 5}) {
    if (!_isLoaded || query.trim().isEmpty) return [];

    // Constitutional articles aren't bundled — let the curated handler answer.
    if (_isArticleQuery(query)) return [];

    final actFilter = _detectActFilter(query);
    final sectionFilter = _detectSection(query);
    final keywords = _tokenize(query);

    // If no usable keywords AND no section filter, give up early.
    if (keywords.isEmpty && sectionFilter == null) return [];

    final wordRe = RegExp(r'[a-z]+');
    final results = <LegalResult>[];

    // When no explicit section filter, require this many heading hits to
    // accept a match. With 1 keyword, 1 hit is fine; with multiple keywords,
    // demand at least 2 hits to avoid false positives like
    // "how to make pizza" matching "Power of High Court to MAKE rules".
    final minHeadingHits = keywords.length <= 1 ? 1 : 2;

    for (final act in _acts) {
      final actMatch = (actFilter == null) || (act.actId == actFilter);
      for (final section in act.sections) {
        final heading = (section['heading'] ?? '').toString().toLowerCase();
        final text = (section['text'] ?? '').toString().toLowerCase();
        final secNum = (section['section_number'] ?? '').toString().toLowerCase();

        final headingWords = wordRe.allMatches(heading).map((m) => m.group(0)!).toSet();
        final textWords = wordRe.allMatches(text).map((m) => m.group(0)!).toSet();

        double score = 0;
        int headingHits = 0;
        for (final w in keywords) {
          final wt = _idfOf(w);
          if (headingWords.contains(w)) {
            score += 5 * wt;
            headingHits++;
          }
          if (textWords.contains(w)) score += 1 * wt;
        }

        // Anti-noise: drop sections that don't have enough heading hits
        // unless the user explicitly asked for a section number.
        if (sectionFilter == null && headingHits < minHeadingHits) {
          score = 0;
        }

        // Section-number boost only when the user explicitly asked for one.
        if (sectionFilter != null && sectionFilter == secNum) {
          score += 30;
          if (actFilter != null && actMatch) {
            score += 50; // near-perfect "BNS Section 103" match
          }
        }

        // Wrong Act → heavy penalty (don't drop entirely, in case the user
        // was vague, but make a same-Act match dominate).
        if (actFilter != null && !actMatch) {
          score *= 0.2;
        }

        if (score > 0) {
          results.add(LegalResult(
            actId: act.actId,
            actName: act.actName,
            sectionNumber: (section['section_number'] ?? '').toString(),
            heading: (section['heading'] ?? '').toString(),
            text: (section['text'] ?? '').toString(),
            score: score,
          ));
        }
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    // Confidence threshold — refuse low-quality matches.
    if (results.isEmpty || results.first.score < 5) return [];

    return results.take(limit).toList();
  }

  /// Smart search across the curated knowledge base.
  ///
  /// Scoring:
  /// • Direct keyword phrase match (case-insensitive substring on query) → +50
  /// • IDF-weighted word overlap with the entry title → +5×IDF per word
  /// • IDF-weighted word overlap with the entry answer → +1×IDF per word
  /// • Article-number match (e.g. "article 21" → entry id "art-21") → +60
  ///
  /// Returns at most `limit` results above the confidence threshold.
  List<KbResult> searchKb(String query, {int limit = 3}) {
    if (!_isLoaded || _kb.isEmpty || query.trim().isEmpty) return [];

    final q = query.toLowerCase().trim();

    // Article-number direct routing.
    final artMatch =
        RegExp(r'article\s*(\d+[a-z]?)', caseSensitive: false).firstMatch(q);
    final articleNum = artMatch?.group(1)?.toLowerCase();

    final keywords = _tokenize(query);
    final results = <KbResult>[];

    for (final entry in _kb) {
      double score = 0;

      // Direct phrase match in keywords list — longer phrases score higher
      // (more specific phrases like "domestic violence" beat single words).
      for (final kw in entry.keywords) {
        if (q.contains(kw)) {
          score += 50 + kw.length;
          break;
        }
      }

      // Article-number direct routing — exact id match
      if (articleNum != null && entry.id == 'art-$articleNum') {
        score += 60;
      }

      // IDF-weighted word overlap
      for (final w in keywords) {
        final wt = _idfOf(w);
        if (entry.titleWords.contains(w)) score += 5 * wt;
        if (entry.answerWords.contains(w)) score += 1 * wt;
      }

      if (score > 0) {
        results.add(KbResult(
          id: entry.id,
          category: entry.category,
          title: entry.title,
          answer: entry.answer,
          score: score,
        ));
      }
    }

    // For "Article N" queries, only the exact art-N entry should win.
    // If we don't have one, return empty so the "I don't know about
    // Article N" fallback fires — never a wrong sibling article.
    List<KbResult> filtered = results;
    if (articleNum != null) {
      filtered = results.where((r) => r.id == 'art-$articleNum').toList();
    }

    filtered.sort((a, b) => b.score.compareTo(a.score));

    // Confidence threshold — anything below 15 means we're guessing
    // from a single weak word match. Don't show it.
    if (filtered.isEmpty || filtered.first.score < 15) return [];

    return filtered.take(limit).toList();
  }

  /// Generate a natural-language response.
  ///
  /// Strategy: run BOTH the section search and the KB search, then return
  /// whichever has the higher confidence score. KB wins ties because curated
  /// answers are usually more user-friendly than raw legal text. If neither
  /// scored above the threshold, return an honest "I don't know".
  String generateResponse(String query, List<LegalResult> results) {
    final kbResults = searchKb(query);
    final sectionTop = results.isNotEmpty ? results.first.score : 0;
    final kbTop = kbResults.isNotEmpty ? kbResults.first.score : 0;

    final useKb = kbTop > 0 && kbTop >= sectionTop;
    final useSection = !useKb && sectionTop > 0;

    if (useSection) {
      final top = results.first;
      final buf = StringBuffer();

      buf.writeln('📚 **${top.actName}**');
      buf.writeln('**Section ${top.sectionNumber}**: ${_cleanHeading(top.heading)}');
      buf.writeln();
      buf.writeln(_cleanText(top.text, 600));

      if (results.length > 1) {
        buf.writeln();
        buf.writeln('📌 **Also related:**');
        for (final r in results.skip(1).take(3)) {
          buf.writeln(
              '• ${r.actName} › Sec ${r.sectionNumber}: ${_cleanHeading(r.heading)}');
        }
      }

      buf.writeln();
      buf.writeln('─────────────────');
      buf.writeln('ℹ️ This is educational information only, not legal advice.');
      return buf.toString();
    }

    if (useKb) {
      final top = kbResults.first;
      final buf = StringBuffer();

      final emoji = switch (top.category) {
        'constitution-article' => '📜',
        'act' => '⚖️',
        'topic' => '💡',
        _ => '📖',
      };

      buf.writeln('$emoji **${top.title}**');
      buf.writeln();
      buf.writeln(top.answer);

      if (kbResults.length > 1) {
        buf.writeln();
        buf.writeln('📌 **Also related:**');
        for (final r in kbResults.skip(1).take(2)) {
          buf.writeln('• ${r.title}');
        }
      }

      buf.writeln();
      buf.writeln('─────────────────');
      buf.writeln('ℹ️ Educational information only, not legal advice.');
      return buf.toString();
    }

    // Honest "I don't know"
    return _handleNoResults(query);
  }

  String _handleNoResults(String query) {
    // Article-number specific fallback — the user asked about an Article we
    // don't have curated yet. Be honest about what we DO cover.
    final artMatch =
        RegExp(r'article\s*(\d+[a-z]?)', caseSensitive: false).firstMatch(query);
    if (artMatch != null) {
      final n = artMatch.group(1);
      return '''🤷 **I don't have offline information on Article $n.**

I'd rather tell you the truth than make something up.

My offline knowledge currently covers:
• Articles 12–17, 19–25, 32, 44, 51A, 368
• Fundamental Rights, Directive Principles, Preamble
• Common Acts (RTI, RPwD/PWD, MV, IT, Consumer Protection, POCSO, NDPS, UAPA, JJ, PMLA, SC/ST, Domestic Violence, Dowry Prohibition)
• BNS 2023, BNSS 2023, BSA 2023 — every section

If Article $n is important for your case, please consult a lawyer or the official Constitution text.

─────────────────
ℹ️ Educational information only.''';
    }

    // Generic fallback — honest "I don't know"
    return '''🤷 **I couldn't find a confident answer for "$query".**

I'd rather say "I don't know" than give you a wrong answer on a legal matter.

**What I CAN help with (offline):**
• Indian Constitution — Articles 12–17, 19–25, 32, 44, 51A, 368, Fundamental Rights, DPSP, Preamble
• BNS 2023 — every section by name or number (e.g. "BNS Section 103", "punishment for theft")
• BNSS 2023 — every section (e.g. "arrest procedure", "BNSS Section 35")
• BSA 2023 — every section
• Acts — RTI, RPwD (PWD), Motor Vehicles, IT Act, Consumer Protection, POCSO, NDPS, UAPA, Domestic Violence, Dowry Prohibition, JJ Act, SC/ST Atrocities Act, PMLA
• Topics — how to file FIR, bail, your rights when arrested, divorce, maintenance, women's property rights, court hierarchy, PIL, writs, cyber complaints, traffic fines

**Try rephrasing**, or ask about a specific section, Article, or Act from the list above.

─────────────────
ℹ️ Educational information only. For your specific situation, please consult a qualified lawyer.''';
  }

  String _cleanHeading(String heading) {
    // Remove trailing long sentences often found in JSON
    final parts = heading.split('—');
    if (parts.isNotEmpty) {
      final cleaned = parts.first.trim();
      if (cleaned.length > 80) return '${cleaned.substring(0, 80)}...';
      return cleaned;
    }
    if (heading.length > 100) return '${heading.substring(0, 100)}...';
    return heading;
  }

  String _cleanText(String text, int maxLength) {
    final cleaned = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('\n', ' ')
        .trim();
    if (cleaned.length <= maxLength) return cleaned;
    // Cut at last full stop before maxLength
    final cut = cleaned.substring(0, maxLength);
    final lastDot = cut.lastIndexOf('.');
    if (lastDot > maxLength / 2) return cut.substring(0, lastDot + 1);
    return '$cut...';
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Chat State & Provider
// ──────────────────────────────────────────────────────────────────────────────

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  AiChatState({required this.messages, this.isLoading = false});

  AiChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  final OfflineLegalEngine _engine = OfflineLegalEngine();

  AiChatNotifier() : super(AiChatState(messages: [])) {
    // Kick off the load eagerly so the engine is usually ready by the time
    // the user types a message. We don't track the result — sendMessage
    // awaits engine.load() unconditionally, which de-duplicates with this
    // initial call thanks to OfflineLegalEngine's _loadingFuture cache.
    _engine.load();
  }

  Future<void> sendMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    final userMsg = ChatMessage(text: query, isUser: true, timestamp: DateTime.now());
    state = state.copyWith(messages: [...state.messages, userMsg], isLoading: true);

    try {
      // Always await load — if it's already done this returns immediately;
      // if it's in flight we share the same future. Either way, by the time
      // we call search() the engine is fully ready.
      await _engine.load();

      // Small delay for UX (feels natural, not instant)
      await Future.delayed(const Duration(milliseconds: 300));

      final results = _engine.search(query);
      final response = _engine.generateResponse(query, results);

      final botMsg = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isLoading: false,
      );
    } catch (e, st) {
      developer.log(
        'AI assistant failed to answer',
        name: 'AiChatNotifier',
        error: e,
        stackTrace: st,
      );
      final errorMsg = ChatMessage(
        text: '⚠️ Something went wrong while answering. Please try again — '
            'or rephrase your question.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isLoading: false,
      );
    }
  }

  void clearChat() {
    state = AiChatState(messages: []);
  }
}

final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((ref) {
  return AiChatNotifier();
});
