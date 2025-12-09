import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LawCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<LawTopic> topics;

  const LawCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.topics,
  });
}

class LawTopic {
  final String id;
  final String title;
  final String titleHindi;
  final String description;
  final String actId;
  final List<String> relevantSections;
  final String summary;

  const LawTopic({
    required this.id,
    required this.title,
    this.titleHindi = '',
    required this.description,
    required this.actId,
    required this.relevantSections,
    required this.summary,
  });
}

// Law categories data
final List<LawCategory> lawCategories = [
  LawCategory(
    id: 'criminal',
    title: 'Criminal Law',
    description: 'Offences, punishments & criminal procedures',
    icon: Icons.gavel,
    color: Colors.red.shade600,
    topics: [
      LawTopic(
        id: 'theft',
        title: 'Theft & Robbery',
        titleHindi: 'चोरी और लूट',
        description: 'Laws related to theft, robbery, dacoity',
        actId: 'BNS-2023',
        relevantSections: [
          '303',
          '304',
          '305',
          '306',
          '307',
          '308',
          '309',
          '310',
        ],
        summary:
            'Theft is dishonestly taking movable property. Robbery is theft with force. Dacoity is robbery by 5+ persons.',
      ),
      LawTopic(
        id: 'assault',
        title: 'Assault & Hurt',
        titleHindi: 'हमला और चोट',
        description: 'Physical violence and bodily harm',
        actId: 'BNS-2023',
        relevantSections: [
          '115',
          '116',
          '117',
          '118',
          '119',
          '120',
          '121',
          '122',
        ],
        summary:
            'Assault means making a gesture or preparation to use force. Hurt means causing bodily pain, disease or infirmity.',
      ),
      LawTopic(
        id: 'murder',
        title: 'Murder & Culpable Homicide',
        titleHindi: 'हत्या और मानव वध',
        description: 'Laws related to killing and homicide',
        actId: 'BNS-2023',
        relevantSections: [
          '101',
          '102',
          '103',
          '104',
          '105',
          '106',
          '107',
          '108',
        ],
        summary:
            'Murder is intentional killing with premeditation. Culpable homicide is causing death without premeditation.',
      ),
      LawTopic(
        id: 'kidnapping',
        title: 'Kidnapping & Abduction',
        titleHindi: 'अपहरण',
        description: 'Unlawful taking of persons',
        actId: 'BNS-2023',
        relevantSections: ['137', '138', '139', '140', '141'],
        summary:
            'Kidnapping is taking a minor from lawful guardian. Abduction is compelling/inducing any person to go from a place.',
      ),
      LawTopic(
        id: 'cheating',
        title: 'Cheating & Fraud',
        titleHindi: 'धोखाधड़ी',
        description: 'Deception and dishonest inducement',
        actId: 'BNS-2023',
        relevantSections: ['318', '319', '320', '321'],
        summary:
            'Cheating is deceiving someone and dishonestly inducing them to deliver property or do/omit something.',
      ),
      LawTopic(
        id: 'defamation',
        title: 'Defamation',
        titleHindi: 'मानहानि',
        description: 'Damage to reputation',
        actId: 'BNS-2023',
        relevantSections: ['356', '357', '358'],
        summary:
            'Defamation is making or publishing statements that harm a person\'s reputation, by words, signs, or representations.',
      ),
    ],
  ),
  LawCategory(
    id: 'property',
    title: 'Property Rights',
    description: 'Land, property and ownership laws',
    icon: Icons.home,
    color: Colors.blue.shade600,
    topics: [
      LawTopic(
        id: 'property_disputes',
        title: 'Property Disputes',
        titleHindi: 'संपत्ति विवाद',
        description: 'Disputes over land and property ownership',
        actId: 'BNS-2023',
        relevantSections: ['329', '330', '331'],
        summary:
            'Property disputes involve claims over ownership, possession, and boundaries of land and buildings.',
      ),
      LawTopic(
        id: 'trespass',
        title: 'Trespass & Encroachment',
        titleHindi: 'अतिक्रमण',
        description: 'Unlawful entry on property',
        actId: 'BNS-2023',
        relevantSections: ['329', '330', '331', '332'],
        summary:
            'Criminal trespass is entering property without permission with intent to commit an offence or intimidate.',
      ),
      LawTopic(
        id: 'mischief',
        title: 'Mischief & Property Damage',
        titleHindi: 'संपत्ति क्षति',
        description: 'Intentional destruction of property',
        actId: 'BNS-2023',
        relevantSections: ['324', '325', '326', '327', '328'],
        summary:
            'Mischief is intentionally destroying or damaging property to cause wrongful loss or damage.',
      ),
    ],
  ),
  LawCategory(
    id: 'women',
    title: 'Women\'s Rights',
    description: 'Laws protecting women',
    icon: Icons.female,
    color: Colors.pink.shade600,
    topics: [
      LawTopic(
        id: 'dowry',
        title: 'Dowry & Cruelty',
        titleHindi: 'दहेज और क्रूरता',
        description: 'Dowry death and cruelty to women',
        actId: 'BNS-2023',
        relevantSections: ['80', '84', '85', '86'],
        summary:
            'Dowry death is when a woman dies within 7 years of marriage under abnormal circumstances related to dowry demands.',
      ),
      LawTopic(
        id: 'sexual_harassment',
        title: 'Sexual Harassment',
        titleHindi: 'यौन उत्पीड़न',
        description: 'Workplace and public harassment',
        actId: 'BNS-2023',
        relevantSections: ['75', '76', '77', '78', '79'],
        summary:
            'Sexual harassment includes unwelcome physical contact, demands for sexual favours, showing pornography, making sexual remarks.',
      ),
      LawTopic(
        id: 'rape',
        title: 'Sexual Offences',
        titleHindi: 'यौन अपराध',
        description: 'Laws against sexual assault',
        actId: 'BNS-2023',
        relevantSections: [
          '63',
          '64',
          '65',
          '66',
          '67',
          '68',
          '69',
          '70',
          '71',
        ],
        summary:
            'Rape is sexual intercourse without consent. Punishment ranges from 10 years to life imprisonment.',
      ),
      LawTopic(
        id: 'domestic_violence',
        title: 'Domestic Violence',
        titleHindi: 'घरेलू हिंसा',
        description: 'Violence within household',
        actId: 'BNS-2023',
        relevantSections: ['85', '86'],
        summary:
            'Domestic violence includes physical, emotional, verbal, economic abuse by family members.',
      ),
    ],
  ),
  LawCategory(
    id: 'cyber',
    title: 'Cyber Crime',
    description: 'Online and digital offences',
    icon: Icons.computer,
    color: Colors.purple.shade600,
    topics: [
      LawTopic(
        id: 'online_fraud',
        title: 'Online Fraud',
        titleHindi: 'ऑनलाइन धोखाधड़ी',
        description: 'Internet scams and digital fraud',
        actId: 'BNS-2023',
        relevantSections: ['318', '319', '336', '337', '338', '339', '340'],
        summary:
            'Online fraud includes phishing, identity theft, fake websites, UPI fraud, and other digital deception.',
      ),
      LawTopic(
        id: 'cyber_stalking',
        title: 'Cyber Stalking',
        titleHindi: 'साइबर स्टॉकिंग',
        description: 'Online harassment and stalking',
        actId: 'BNS-2023',
        relevantSections: ['78', '79', '351', '352'],
        summary:
            'Cyber stalking is using electronic means to follow, monitor, or harass someone online.',
      ),
      LawTopic(
        id: 'data_theft',
        title: 'Data & Identity Theft',
        titleHindi: 'डेटा चोरी',
        description: 'Stealing personal information',
        actId: 'BNS-2023',
        relevantSections: ['336', '337', '338', '339', '340'],
        summary:
            'Data theft involves stealing personal data, passwords, financial information for fraudulent use.',
      ),
    ],
  ),
  LawCategory(
    id: 'consumer',
    title: 'Consumer Rights',
    description: 'Protection against unfair trade',
    icon: Icons.shopping_cart,
    color: Colors.green.shade600,
    topics: [
      LawTopic(
        id: 'product_defects',
        title: 'Defective Products',
        titleHindi: 'दोषपूर्ण उत्पाद',
        description: 'Faulty goods and services',
        actId: 'BNS-2023',
        relevantSections: ['274', '275', '276', '277'],
        summary:
            'Consumers can seek compensation for defective products, false advertisements, and unfair trade practices.',
      ),
      LawTopic(
        id: 'food_adulteration',
        title: 'Food Adulteration',
        titleHindi: 'खाद्य मिलावट',
        description: 'Harmful substances in food',
        actId: 'BNS-2023',
        relevantSections: ['274', '275', '276', '277'],
        summary:
            'Selling adulterated or harmful food is punishable with imprisonment and fine.',
      ),
    ],
  ),
  LawCategory(
    id: 'procedure',
    title: 'Legal Procedures',
    description: 'How to file complaints & cases',
    icon: Icons.description,
    color: Colors.teal.shade600,
    topics: [
      LawTopic(
        id: 'fir',
        title: 'Filing FIR',
        titleHindi: 'एफआईआर दर्ज करना',
        description: 'How to register a police complaint',
        actId: 'BNSS-2023',
        relevantSections: ['173', '174', '175'],
        summary:
            'FIR can be filed at any police station. Zero FIR allows filing at any station regardless of jurisdiction.',
      ),
      LawTopic(
        id: 'bail',
        title: 'Bail Provisions',
        titleHindi: 'जमानत',
        description: 'Getting released on bail',
        actId: 'BNSS-2023',
        relevantSections: ['478', '479', '480', '481', '482', '483'],
        summary:
            'Bail is a right in bailable offences. In non-bailable, court decides based on nature of offence.',
      ),
      LawTopic(
        id: 'arrest',
        title: 'Arrest Rights',
        titleHindi: 'गिरफ्तारी के अधिकार',
        description: 'Rights when arrested',
        actId: 'BNSS-2023',
        relevantSections: ['35', '36', '37', '38', '39', '40'],
        summary:
            'Right to know grounds of arrest, right to legal aid, right to inform family, produce before magistrate within 24 hours.',
      ),
      LawTopic(
        id: 'evidence',
        title: 'Evidence & Proof',
        titleHindi: 'साक्ष्य और प्रमाण',
        description: 'What constitutes valid evidence',
        actId: 'BSA-2023',
        relevantSections: ['1', '2', '3', '4', '5', '6', '7'],
        summary:
            'Evidence includes oral, documentary, and electronic evidence. Burden of proof lies on the prosecution.',
      ),
    ],
  ),

  // NEW PRACTICAL CATEGORIES
  LawCategory(
    id: 'traffic',
    title: 'Traffic & Motor Vehicle Laws',
    description: 'Driving rules, fines, accidents',
    icon: Icons.directions_car,
    color: Colors.indigo.shade600,
    topics: [
      LawTopic(
        id: 'driving_license',
        title: 'Driving License Rules',
        titleHindi: 'ड्राइविंग लाइसेंस नियम',
        description: 'License requirements and validity',
        actId: 'BNS-2023',
        relevantSections: ['281', '282', '283'],
        summary:
            'Driving without valid license is punishable. Learner\'s license valid for 6 months. Permanent license valid for 20 years (till age 50).',
      ),
      LawTopic(
        id: 'traffic_fines',
        title: 'Traffic Fines & Challans',
        titleHindi: 'यातायात जुर्माना',
        description: 'Penalties for traffic violations',
        actId: 'BNS-2023',
        relevantSections: ['281', '282', '283', '284'],
        summary:
            'Over-speeding: ₹1000-2000. No helmet: ₹1000. Drunk driving: ₹10000. Wrong parking: ₹500. Red light jump: ₹1000.',
      ),
      LawTopic(
        id: 'accident_reporting',
        title: 'Accident Reporting',
        titleHindi: 'दुर्घटना रिपोर्टिंग',
        description: 'What to do after road accident',
        actId: 'BNS-2023',
        relevantSections: ['281', '282', '283', '284'],
        summary:
            'Must report accident to police within 24 hours. Provide medical aid to injured. Failing to report or help victims is punishable under Motor Vehicles Act and BNS.',
      ),
      LawTopic(
        id: 'hit_and_run',
        title: 'Hit & Run Laws',
        titleHindi: 'हिट एंड रन कानून',
        description: 'Leaving accident scene without helping',
        actId: 'BNS-2023',
        relevantSections: ['106', '281', '284'],
        summary:
            'Leaving accident scene without helping injured victim is hit-and-run. If death occurs, punishment under BNS 106 (causing death by negligence): Up to 5 years imprisonment and fine. Motor Vehicles Act adds additional penalties.',
      ),
    ],
  ),
  LawCategory(
    id: 'employment',
    title: 'Employment & Labour Rights',
    description: 'Worker rights, salary, workplace issues',
    icon: Icons.work,
    color: Colors.brown.shade600,
    topics: [
      LawTopic(
        id: 'employee_rights',
        title: 'Employee Rights',
        titleHindi: 'कर्मचारी अधिकार',
        description: 'Basic rights of employees',
        actId: 'BNS-2023',
        relevantSections: ['23', '24', '25'],
        summary:
            'Right to minimum wages, paid leave, safe working conditions, joining unions, and protection against forced labour. Any form of begar (forced labour) is punishable under BNS Sections 23-25.',
      ),
      LawTopic(
        id: 'salary_disputes',
        title: 'Salary & Payment Issues',
        titleHindi: 'वेतन विवाद',
        description: 'Non-payment or delayed salary',
        actId: 'BNS-2023',
        relevantSections: ['316', '318', '319'],
        summary:
            'Non-payment of salary is cheating/criminal breach of trust. Can file criminal complaint under BNS. Also approach Labour Commissioner for recovery under Payment of Wages Act.',
      ),
      LawTopic(
        id: 'workplace_harassment',
        title: 'Workplace Harassment',
        titleHindi: 'कार्यस्थल उत्पीड़न',
        description: 'Sexual harassment at workplace',
        actId: 'BNS-2023',
        relevantSections: ['75', '76', '77', '78', '79'],
        summary:
            'Every workplace must have Internal Complaints Committee. Harassment includes unwelcome advances, demands, showing pornography, sexual remarks.',
      ),
      LawTopic(
        id: 'working_hours',
        title: 'Working Hours & Leave',
        titleHindi: 'कार्य समय और अवकाश',
        description: 'Maximum work hours and leave rules',
        actId: 'BNS-2023',
        relevantSections: ['23', '24', '25'],
        summary:
            'Factories Act mandates maximum 8 hours/day, 48 hours/week. Forcing excessive work hours amounts to forced labour (BNS 23-25). Overtime must be paid at double rate. Entitled to leaves as per labour laws.',
      ),
    ],
  ),
  LawCategory(
    id: 'family',
    title: 'Family & Marriage Laws',
    description: 'Marriage, divorce, custody, maintenance',
    icon: Icons.people,
    color: Colors.deepPurple.shade600,
    topics: [
      LawTopic(
        id: 'marriage_laws',
        title: 'Marriage Laws',
        titleHindi: 'विवाह कानून',
        description: 'Legal age and registration',
        actId: 'BNS-2023',
        relevantSections: ['73', '74'],
        summary:
            'Legal marriage age: 21 for both men and women (updated law). Marriage registration is mandatory. Child marriage is illegal with imprisonment up to 2 years.',
      ),
      LawTopic(
        id: 'divorce',
        title: 'Divorce & Maintenance',
        titleHindi: 'तलाक और भरण-पोषण',
        description: 'Divorce grounds and alimony',
        actId: 'BNS-2023',
        relevantSections: ['85', '86'],
        summary:
            'Cruelty (physical/mental abuse) is ground for divorce and punishable under BNS 85-86. Divorce governed by personal laws. Wife entitled to maintenance. Amount decided by court based on income and needs.',
      ),
      LawTopic(
        id: 'child_custody',
        title: 'Child Custody',
        titleHindi: 'बच्चे की हिरासत',
        description: 'Custody rights after divorce',
        actId: 'BNS-2023',
        relevantSections: ['87'],
        summary:
            'Child custody governed by Guardians and Wards Act and personal laws. Child\'s welfare is paramount. Courts consider age, parents\' ability to care. Both parents retain visitation and support obligations.',
      ),
    ],
  ),
  LawCategory(
    id: 'senior',
    title: 'Senior Citizen Rights',
    description: 'Rights and protection for elderly',
    icon: Icons.elderly,
    color: Colors.deepOrange.shade600,
    topics: [
      LawTopic(
        id: 'maintenance_parents',
        title: 'Maintenance of Parents',
        titleHindi: 'माता-पिता का भरण-पोषण',
        description: 'Children\'s duty to support parents',
        actId: 'BNS-2023',
        relevantSections: ['194', '195'],
        summary:
            'Children must maintain parents unable to support themselves. Can claim up to ₹10,000/month. Tribunal orders within 90 days. Abandonment is punishable.',
      ),
      LawTopic(
        id: 'property_safety',
        title: 'Property Rights Protection',
        titleHindi: 'संपत्ति अधिकार संरक्षण',
        description: 'Protecting senior citizens property',
        actId: 'BNS-2023',
        relevantSections: ['329', '330'],
        summary:
            'Cannot force seniors to transfer property. Forced property transfer is illegal. Senior can revoke property gift if not maintained properly.',
      ),
      LawTopic(
        id: 'elder_abuse',
        title: 'Elder Abuse Protection',
        titleHindi: 'बुजुर्गों का दुरुपयोग संरक्षण',
        description: 'Protection from abuse and neglect',
        actId: 'BNS-2023',
        relevantSections: ['115', '125', '194'],
        summary:
            'Abuse includes physical violence, verbal abuse, neglect, abandonment. Can file police complaint. Helpline: 14567 (Elder Line).',
      ),
    ],
  ),
  LawCategory(
    id: 'police',
    title: 'Police & FIR Guide',
    description: 'How to deal with police procedures',
    icon: Icons.local_police,
    color: Colors.blueGrey.shade700,
    topics: [
      LawTopic(
        id: 'how_to_fir',
        title: 'How to File FIR',
        titleHindi: 'एफआईआर कैसे दर्ज करें',
        description: 'Step by step FIR filing process',
        actId: 'BNSS-2023',
        relevantSections: ['173', '174', '175'],
        summary:
            'Go to any police station. Give written/oral complaint. Police MUST register FIR for cognizable offences. Zero FIR: file at any station, transferred later.',
      ),
      LawTopic(
        id: 'police_refuse',
        title: 'If Police Refuse FIR',
        titleHindi: 'यदि पुलिस FIR से इनकार करे',
        description: 'What to do if police don\'t register FIR',
        actId: 'BNSS-2023',
        relevantSections: ['173', '176'],
        summary:
            'Send written complaint by post to SP. Approach magistrate directly. File complaint online. Police refusal is punishable misconduct.',
      ),
      LawTopic(
        id: 'police_rights',
        title: 'Your Rights with Police',
        titleHindi: 'पुलिस के साथ आपके अधिकार',
        description: 'Rights during police interaction',
        actId: 'BNSS-2023',
        relevantSections: ['35', '36', '37', '38', '39', '40'],
        summary:
            'Right to know reason for arrest. Right to legal aid. Right to inform family. Right to medical checkup. Cannot be beaten. Must be produced before magistrate within 24 hours.',
      ),
    ],
  ),
];

class LawFinderScreen extends StatefulWidget {
  const LawFinderScreen({super.key});

  @override
  State<LawFinderScreen> createState() => _LawFinderScreenState();
}

class _LawFinderScreenState extends State<LawFinderScreen> {
  int _currentStep = 0; // 0: categories, 1: topics, 2: details
  LawCategory? _selectedCategory;
  LawTopic? _selectedTopic;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCategory(LawCategory category) {
    setState(() {
      _selectedCategory = category;
      _currentStep = 1;
    });
  }

  void _selectTopic(LawTopic topic) {
    setState(() {
      _selectedTopic = topic;
      _currentStep = 2;
    });
  }

  void _goBack() {
    setState(() {
      if (_currentStep == 2) {
        _selectedTopic = null;
        _currentStep = 1;
      } else if (_currentStep == 1) {
        _selectedCategory = null;
        _currentStep = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_currentStep > 0) {
            _goBack();
          } else {
            context.go('/');
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _selectedCategory?.color.withOpacity(0.1) ??
                    Colors.green.shade50,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentStep == 0
                        ? _buildCategoriesView()
                        : _currentStep == 1
                        ? _buildTopicsView()
                        : _buildDetailsView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = _selectedCategory?.color ?? Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => context.go('/'),
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentStep == 0
                      ? '⚖️ Law Finder'
                      : _currentStep == 1
                      ? _selectedCategory!.title
                      : _selectedTopic!.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  _currentStep == 0
                      ? 'Select a category to find relevant laws'
                      : _currentStep == 1
                      ? 'Select a topic'
                      : 'Relevant sections',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesView() {
    // Filter categories and topics based on search
    List<LawCategory> filteredCategories = lawCategories;
    List<LawTopic> searchResults = [];

    if (_searchQuery.isNotEmpty) {
      for (var category in lawCategories) {
        for (var topic in category.topics) {
          if (topic.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              topic.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              topic.summary.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              )) {
            searchResults.add(topic);
          }
        }
      }
    }

    return ListView(
      key: const ValueKey('categories'),
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome card
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.gavel,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Law Finder',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Browse categories or search for specific topics. Find relevant sections of Indian laws quickly.',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),

        // Search bar
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search: FIR, Divorce, Traffic Fine, etc.',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: Colors.green.shade600),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        // Search results
        if (_searchQuery.isNotEmpty && searchResults.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              '${searchResults.length} results found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          ...searchResults.map((topic) {
            final category = lawCategories.firstWhere(
              (cat) => cat.topics.contains(topic),
            );
            return _TopicCard(
              topic: topic,
              color: category.color,
              onTap: () {
                _selectedCategory = category;
                _selectTopic(topic);
              },
            );
          }).toList(),
        ] else if (_searchQuery.isNotEmpty && searchResults.isEmpty) ...[
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'No results found for "$_searchQuery"',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try different keywords',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ] else ...[
          // Categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return _CategoryCard(
                category: category,
                onTap: () => _selectCategory(category),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildTopicsView() {
    return ListView(
      key: const ValueKey('topics'),
      padding: const EdgeInsets.all(16),
      children: [
        // Category header
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: _selectedCategory!.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedCategory!.color.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _selectedCategory!.icon,
                color: _selectedCategory!.color,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCategory!.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory!.color,
                      ),
                    ),
                    Text(
                      '${_selectedCategory!.topics.length} topics available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Topics list
        ...List.generate(_selectedCategory!.topics.length, (index) {
          final topic = _selectedCategory!.topics[index];
          return _TopicCard(
            topic: topic,
            color: _selectedCategory!.color,
            onTap: () => _selectTopic(topic),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsView() {
    final topic = _selectedTopic!;
    final color = _selectedCategory!.color;

    return ListView(
      key: const ValueKey('details'),
      padding: const EdgeInsets.all(16),
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.lightbulb, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                topic.summary,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Relevant sections
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      topic.actId,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Relevant Sections',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Tap on any section to view its full details:',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topic.relevantSections.map((section) {
                  return InkWell(
                    onTap: () {
                      context.push('/acts/${topic.actId}/sections/$section');
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.article, size: 16, color: color),
                          const SizedBox(width: 6),
                          Text(
                            'Section $section',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 12, color: color),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // View all sections button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push('/acts/${topic.actId}/sections');
            },
            icon: const Icon(Icons.library_books),
            label: Text('Browse All ${topic.actId} Sections'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Disclaimer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This is for educational purposes only. Consult a lawyer for legal advice.',
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final LawCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, size: 28, color: category.color),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                category.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                category.description,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final LawTopic topic;
  final Color color;
  final VoidCallback onTap;

  const _TopicCard({
    required this.topic,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.article, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topic.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            topic.actId,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                        Text(
                          '${topic.relevantSections.length} sections',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
