import 'package:flutter/material.dart';

class AboutConstitutionScreen extends StatefulWidget {
  const AboutConstitutionScreen({super.key});

  @override
  State<AboutConstitutionScreen> createState() =>
      _AboutConstitutionScreenState();
}

class _AboutConstitutionScreenState extends State<AboutConstitutionScreen> {
  bool _isHindi = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('English', style: TextStyle(fontSize: 12)),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('हिंदी', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    selected: {_isHindi},
                    onSelectionChanged: (Set<bool> selection) {
                      setState(() {
                        _isHindi = selection.first;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return Colors.white.withOpacity(0.3);
                      }),
                      foregroundColor: MaterialStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.orange.shade700;
                        }
                        return Colors.white;
                      }),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _isHindi ? 'भारत का संविधान' : 'Constitution of India',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange.shade700, Colors.green.shade600],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IntroCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _FramingProcessCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _KeyLeadersCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _DraftingCommitteeCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _OtherContributorsCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _NationalDaysCard(isHindi: _isHindi),
                  const SizedBox(height: 16),
                  _PrideAndValuesCard(isHindi: _isHindi),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  final bool isHindi;

  const _IntroCard({required this.isHindi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description,
                    color: Colors.orange.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi ? 'संविधान क्या है?' : 'What is the Constitution?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isHindi
                  ? 'भारत का संविधान देश का सर्वोच्च कानून है, जो यह परिभाषित करता है कि हमारे देश को कैसे शासित किया जाता है, राज्य के प्रत्येक अंग की शक्तियां, और प्रत्येक नागरिक के मौलिक अधिकार और कर्तव्य।'
                  : 'The Constitution of India is the supreme law of the land, defining how our country is governed, the powers of each organ of the state, and the fundamental rights and duties of every citizen.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.event, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isHindi
                          ? 'अपनाया गया: 26 नवंबर 1949\nलागू किया गया: 26 जनवरी 1950'
                          : 'Adopted: 26 November 1949\nEnforced: 26 January 1950',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FramingProcessCard extends StatelessWidget {
  final bool isHindi;

  const _FramingProcessCard({required this.isHindi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history_edu,
                    color: Colors.green.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'संविधान का निर्माण'
                        : 'The Making of Constitution',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isHindi
                  ? 'संविधान का निर्माण भारत की संविधान सभा द्वारा किया गया था, जिसकी पहली बैठक दिसंबर 1946 में हुई थी। 2 वर्ष, 11 महीने और 18 दिन के समर्पित कार्य के बाद, सभा ने 26 नवंबर 1949 को अंतिम संविधान को अपनाया।'
                  : 'The Constitution was framed by the Constituent Assembly of India, which first met in December 1946. After 2 years, 11 months and 18 days of dedicated work, the Assembly adopted the final Constitution on 26 November 1949.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isHindi
                  ? 'उस ऐतिहासिक दिन पर, 284 सदस्यों ने दस्तावेज़ पर हस्ताक्षर किए, इससे पहले कि यह 26 जनवरी 1950 को लागू हो, जिसने भारत के एक संप्रभु लोकतांत्रिक गणराज्य में परिवर्तन को चिह्नित किया।'
                  : 'On that historic day, 284 members signed the document before it came into force on 26 January 1950, marking India\'s transformation into a sovereign democratic republic.',
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyLeadersCard extends StatelessWidget {
  final bool isHindi;

  const _KeyLeadersCard({required this.isHindi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.people,
                    color: Colors.purple.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'स्वतंत्रता के शिल्पकार'
                        : 'Architects of Freedom',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _LeaderTile(
              name: isHindi ? 'डॉ. बी.आर. अंबेडकर' : 'Dr. B.R. Ambedkar',
              role: isHindi
                  ? 'प्रारूप समिति के अध्यक्ष'
                  : 'Chairman of Drafting Committee',
              description: isHindi
                  ? 'संविधान के मुख्य वास्तुकार, जिन्हें अक्सर भारतीय संविधान के पिता कहा जाता है।'
                  : 'Chief architect of the Constitution, often called the Father of the Indian Constitution.',
              color: Colors.blue,
            ),
            _LeaderTile(
              name: isHindi ? 'डॉ. राजेंद्र प्रसाद' : 'Dr. Rajendra Prasad',
              role: isHindi
                  ? 'संविधान सभा के अध्यक्ष'
                  : 'President of Constituent Assembly',
              description: isHindi
                  ? 'ऐतिहासिक विचार-विमर्श के माध्यम से सभा का मार्गदर्शन किया और भारत के पहले राष्ट्रपति बने।'
                  : 'Guided the Assembly through its historic deliberations and became India\'s first President.',
              color: Colors.orange,
            ),
            _LeaderTile(
              name: isHindi ? 'जवाहरलाल नेहरू' : 'Jawaharlal Nehru',
              role: isHindi
                  ? 'दृष्टि के प्रमुख वास्तुकार'
                  : 'Prime Architect of Vision',
              description: isHindi
                  ? 'उद्देश्य संकल्प को प्रस्तावित किया जिसने प्रस्तावना को प्रेरित किया और भारत के लोकतांत्रिक आदर्शों को आकार दिया।'
                  : 'Moved the Objectives Resolution that inspired the Preamble and shaped India\'s democratic ideals.',
              color: Colors.red,
            ),
            _LeaderTile(
              name: isHindi
                  ? 'सरदार वल्लभभाई पटेल'
                  : 'Sardar Vallabhbhai Patel',
              role: isHindi ? 'एकता के शिल्पकार' : 'Architect of Unity',
              description: isHindi
                  ? 'संघीय ढांचे को आकार दिया और 565 रियासतों को एक भारत में एकीकृत करने का आयोजन किया।'
                  : 'Shaped the federal structure and orchestrated the integration of 565 princely states into one India.',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderTile extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final MaterialColor color;

  const _LeaderTile({
    required this.name,
    required this.role,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _DraftingCommitteeCard extends StatelessWidget {
  final bool isHindi;

  const _DraftingCommitteeCard({required this.isHindi});

  List<Map<String, String>> _getMembers(bool isHindi) {
    if (isHindi) {
      return [
        {'name': 'डॉ. बी.आर. अंबेडकर', 'role': 'अध्यक्ष'},
        {'name': 'के.एम. मुंशी', 'role': 'सदस्य'},
        {'name': 'अल्लादी कृष्णस्वामी अय्यर', 'role': 'सदस्य'},
        {'name': 'एन. गोपालस्वामी अयंगार', 'role': 'सदस्य'},
        {'name': 'मुहम्मद सादुल्ला', 'role': 'सदस्य'},
        {'name': 'एन. माधव राव', 'role': 'सदस्य (बी.एल. मित्तर की जगह)'},
        {'name': 'टी.टी. कृष्णमाचारी', 'role': 'सदस्य (डी.पी. खैतान की जगह)'},
      ];
    } else {
      return [
        {'name': 'Dr. B.R. Ambedkar', 'role': 'Chairman'},
        {'name': 'K.M. Munshi', 'role': 'Member'},
        {'name': 'Alladi Krishnaswami Ayyar', 'role': 'Member'},
        {'name': 'N. Gopalaswami Ayyangar', 'role': 'Member'},
        {'name': 'Muhammed Saadulla', 'role': 'Member'},
        {'name': 'N. Madhava Rao', 'role': 'Member (replaced B.L. Mitter)'},
        {
          'name': 'T.T. Krishnamachari',
          'role': 'Member (replaced D.P. Khaitan)',
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = _getMembers(isHindi);

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit_document,
                    color: Colors.indigo.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi ? 'प्रारूप समिति' : 'Drafting Committee',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isHindi
                  ? 'सात प्रतिष्ठित सदस्य जिन्होंने संविधान के हर शब्द का मसौदा तैयार किया:'
                  : 'Seven distinguished members who drafted every word of the Constitution:',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            ...members.map(
              (member) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['name']!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            member['role']!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherContributorsCard extends StatelessWidget {
  final bool isHindi;

  const _OtherContributorsCard({required this.isHindi});

  List<String> _getContributors(bool isHindi) {
    if (isHindi) {
      return [
        'बी.एन. राव - संवैधानिक सलाहकार',
        'एच.सी. मुखर्जी - सभा के उपाध्यक्ष',
        'सभी क्षेत्रों, समुदायों और राजनीतिक धाराओं के प्रतिनिधि',
      ];
    } else {
      return [
        'B.N. Rau - Constitutional Adviser',
        'H.C. Mookerjee - Vice President of Assembly',
        'Representatives from all regions, communities and political streams',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final contributors = _getContributors(isHindi);

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.groups,
                    color: Colors.teal.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'अन्य प्रमुख योगदानकर्ता'
                        : 'Other Key Contributors',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...contributors.map(
              (contributor) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.star, color: Colors.teal.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        contributor,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NationalDaysCard extends StatelessWidget {
  final bool isHindi;

  const _NationalDaysCard({required this.isHindi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.flag, color: Colors.red.shade700, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isHindi
                        ? 'महत्वपूर्ण राष्ट्रीय दिवस'
                        : 'Important National Days',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _NationalDayTile(
              date: isHindi ? '26 नवंबर' : '26 November',
              title: isHindi ? 'संविधान दिवस' : 'Constitution Day',
              subtitle: isHindi ? 'संविधान दिवस' : 'Samvidhan Diwas',
              description: isHindi
                  ? '1949 में संविधान को अपनाने की याद दिलाता है और उन सभी निर्माताओं का सम्मान करता है जिन्होंने भारत को यह सर्वोच्च दस्तावेज़ दिया।'
                  : 'Commemorates the adoption of the Constitution in 1949 and honours all the framers who gave India this supreme document.',
              icon: Icons.menu_book,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _NationalDayTile(
              date: isHindi ? '26 जनवरी' : '26 January',
              title: isHindi ? 'गणतंत्र दिवस' : 'Republic Day',
              subtitle: isHindi ? 'गणतंत्र दिवस' : 'Gantantra Diwas',
              description: isHindi
                  ? '1950 में उस दिन को चिह्नित करता है जब संविधान लागू हुआ और भारत एक संप्रभु लोकतांत्रिक गणराज्य बन गया।'
                  : 'Marks the day in 1950 when the Constitution came into force and India became a sovereign democratic republic.',
              icon: Icons.celebration,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class _NationalDayTile extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final MaterialColor color;

  const _NationalDayTile({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(icon, color: color.shade700, size: 24),
                const SizedBox(height: 4),
                Text(
                  date.split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.shade900,
                  ),
                ),
                Text(
                  date.split(' ')[1],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color.shade900,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrideAndValuesCard extends StatelessWidget {
  final bool isHindi;

  const _PrideAndValuesCard({required this.isHindi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade50, Colors.green.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red.shade700,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isHindi
                          ? 'हमारा गर्व, हमारी स्वतंत्रता'
                          : 'Our Pride, Our Freedom',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isHindi
                    ? 'संविधान जाति, धर्म, लिंग या क्षेत्र की परवाह किए बिना सभी नागरिकों के लिए न्याय, स्वतंत्रता, समानता और बंधुत्व की भारत की गारंटी है।'
                    : 'The Constitution is India\'s guarantee of justice, liberty, equality and fraternity for all citizens, regardless of caste, religion, gender or region.',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isHindi
                    ? 'हमारे स्वतंत्रता सेनानियों के बलिदान और संविधान के निर्माताओं के अथक काम ने आज हमारे लिए मौलिक अधिकारों और लोकतांत्रिक सुरक्षा के साथ जीना संभव बनाया।'
                    : 'The sacrifices of our freedom fighters and the tireless work of the Constitution\'s framers made it possible for us to live with fundamental rights and democratic protections today.',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isHindi
                    ? 'यह हमारा इतिहास, हमारा गर्व और स्वतंत्र भारत की नींव है जिसे हम संजोते हैं।'
                    : 'This is our history, our pride, and the foundation of the free India we cherish.',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
