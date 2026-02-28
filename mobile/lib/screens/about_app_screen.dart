import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/app_providers.dart';

class AboutAppScreen extends ConsumerStatefulWidget {
  const AboutAppScreen({super.key});

  @override
  ConsumerState<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends ConsumerState<AboutAppScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${info.version} (${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeModeProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go('/');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                context.go('/');
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            // App Header
            _buildAppHeader(),
            const SizedBox(height: 28),

            // Settings Section
            _buildSectionCard(
              title: 'Settings',
              items: [
                _buildActionTile(
                  icon: Icons.brightness_6,
                  iconColor: Colors.orange,
                  title: 'App Theme',
                  subtitle: _getThemeText(currentTheme),
                  onTap: () => _showThemeDialog(currentTheme),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Share & Support Section
            _buildSectionCard(
              title: 'Share & Support',
              items: [
                _buildActionTile(
                  icon: Icons.share,
                  iconColor: Colors.green,
                  title: 'Share App',
                  subtitle: 'Recommend to friends',
                  onTap: _shareApp,
                ),

                _buildActionTile(
                  icon: Icons.feedback,
                  iconColor: Colors.purple,
                  title: 'Send Feedback',
                  subtitle: 'Report bugs or request features',
                  onTap: _sendFeedback,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Legal & Info Section
            _buildSectionCard(
              title: 'Legal & Info',
              items: [
                _buildActionTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: Colors.grey,
                  title: 'Privacy Policy',
                  subtitle: 'How we handle your data',
                  onTap: _showPrivacyInfo,
                ),
                _buildActionTile(
                  icon: Icons.info_outline,
                  iconColor: Colors.indigo,
                  title: 'About App',
                  subtitle: 'Version $_appVersion',
                  onTap: _showAppInfo,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This app is for educational purposes only and does not constitute legal advice. Please consult a qualified legal professional for specific legal matters.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.balance, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Indian Law Guide',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _appVersion,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }

  // Get theme text based on current mode
  String _getThemeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System default';
    }
  }

  // Show theme selection dialog
  void _showThemeDialog(ThemeMode currentTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('System default', ThemeMode.system, currentTheme),
            _buildThemeOption('Light', ThemeMode.light, currentTheme),
            _buildThemeOption('Dark', ThemeMode.dark, currentTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    String title,
    ThemeMode mode,
    ThemeMode currentTheme,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: mode,
      groupValue: currentTheme,
      activeColor: Colors.orange,
      onChanged: (ThemeMode? value) {
        if (value != null) {
          // Update theme using Riverpod provider
          ref.read(themeModeProvider.notifier).setTheme(value);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme changed to $title'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  // Share app
  Future<void> _shareApp() async {
    await Share.share(
      'Check out Indian Law Guide - Your pocket legal companion! '
      'Browse BNS, BNSS, BSA laws offline. Fast, private, and easy to use.\n\n'
      '📲 Download: https://play.google.com/store/apps/details?id=com.indianlaw.indian_constitution_vault',
      subject: 'Indian Law Guide App',
    );
  }

  // Send feedback
  Future<void> _sendFeedback() async {
    const email = 'unnatitank14@gmail.com';
    const subject = 'Indian Law Guide Feedback';
    final uri = Uri(scheme: 'mailto', path: email, query: 'subject=$subject');

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please send feedback to: unnatitank14@gmail.com'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please send feedback to: unnatitank14@gmail.com'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // Show app info dialog
  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About App'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Version: $_appVersion',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Indian Law Guide is a comprehensive offline legal companion for understanding Indian criminal laws.',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Laws Included:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Bharatiya Nyaya Sanhita (BNS) - 365 sections'),
              const Text(
                '• Bharatiya Nagarik Suraksha Sanhita (BNSS) - 534 sections',
              ),
              const Text('• Bharatiya Sakshya Adhiniyam (BSA) - 171 sections'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show privacy policy
  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Data Collection',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                '• This app works 100% offline\n'
                '• No personal data is collected\n'
                '• No analytics or tracking\n'
                '• All data stays on your device',
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Privacy Matters',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'We respect your privacy. This app is designed to work completely offline without collecting any personal information.',
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

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
