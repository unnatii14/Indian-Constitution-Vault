import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Title
                const Text(
                  'More',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                // Premium Banner (placeholder)
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.deepOrange.shade500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const SizedBox(height: 32),

                // Appearance Section
                _buildSectionHeader('Appearance'),
                const SizedBox(height: 8),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.brightness_6_outlined,
                    title: 'Theme',
                    subtitle: 'System default',
                    onTap: () => _showThemeDialog(context),
                  ),
                ]),

                const SizedBox(height: 24),

                // Feedback & Support Section
                _buildSectionHeader('Feedback & Support'),
                const SizedBox(height: 8),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.feedback_outlined,
                    iconColor: Colors.cyan,
                    title: 'Send feedback',
                    subtitle: 'Help us improve Indian Law Guide',
                    onTap: () => _sendFeedback(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.lightbulb_outline,
                    iconColor: Colors.amber,
                    title: 'Suggest a feature',
                    subtitle: 'Have an idea? We\'d love to hear it',
                    onTap: () => _suggestFeature(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.bug_report_outlined,
                    iconColor: Colors.red,
                    title: 'Report a bug',
                    subtitle: 'Something not working right?',
                    onTap: () => _reportBug(),
                  ),
                ]),

                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader('About'),
                const SizedBox(height: 8),
                _buildMenuCard([
                  _buildMenuItem(
                    icon: Icons.star_outline,
                    iconColor: Colors.amber,
                    title: 'Rate Indian Law Guide',
                    subtitle: 'Love the app? Leave a review!',
                    onTap: () => _rateApp(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.share_outlined,
                    iconColor: Colors.blue,
                    title: 'Share app',
                    subtitle: 'Tell your friends about Indian Law Guide',
                    onTap: () => _shareApp(),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: Colors.grey,
                    title: 'Privacy & data',
                    subtitle: 'Learn how we handle your data',
                    onTap: () => _showPrivacyInfo(),
                  ),
                ]),

                const SizedBox(height: 32),

                // Version
                Center(
                  child: Text(
                    _appVersion,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.grey).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor ?? Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }

  // Theme Dialog
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('System default', ThemeMode.system),
            _buildThemeOption('Light', ThemeMode.light),
            _buildThemeOption('Dark', ThemeMode.dark),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, ThemeMode mode) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.check, color: Colors.transparent),
      onTap: () {
        // TODO: Implement theme switching with Riverpod
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title theme selected')));
      },
    );
  }

  // Feedback Actions
  Future<void> _sendFeedback() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'unnatitank14@gmail.com',
      query:
          'subject=Indian Law Guide - Feedback&body=Please share your feedback:',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackBar('Could not open email app');
    }
  }

  Future<void> _suggestFeature() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'unnatitank14@gmail.com',
      query: 'subject=Indian Law Guide - Feature Suggestion&body=Feature idea:',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackBar('Could not open email app');
    }
  }

  Future<void> _reportBug() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'unnatitank14@gmail.com',
      query: 'subject=Indian Law Guide - Bug Report&body=Bug description:',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackBar('Could not open email app');
    }
  }

  // App Actions
  Future<void> _rateApp() async {
    // TODO: Replace with actual Play Store URL once published
    final Uri storeUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.yourpackage.indian_constitution_vault',
    );
    if (await canLaunchUrl(storeUri)) {
      await launchUrl(storeUri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Could not open Play Store');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out Indian Law Guide - Your pocket legal companion! '
      'Learn about Indian laws easily. Download: https://play.google.com/store/apps/details?id=com.indianlaw.indian_constitution_vault',
      subject: 'Indian Law Guide App',
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data Collection',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• This app works 100% offline\n'
                '• No personal data is collected\n'
                '• No analytics or tracking\n'
                '• All data stays on your device',
              ),
              SizedBox(height: 16),
              Text(
                'Permissions',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• Voice input (optional): For voice search\n'
                '• Storage: For caching legal content',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
