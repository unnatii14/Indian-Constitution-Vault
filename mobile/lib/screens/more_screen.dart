import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/app_providers.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${info.version} (${info.buildNumber})';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 14),

              // Appearance Section
              _buildSectionHeader('Appearance', isDark),
              const SizedBox(height: 8),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.brightness_6_rounded,
                  iconColor: colorScheme.primary,
                  title: 'Theme Mode',
                  subtitle: _getThemeName(themeMode),
                  onTap: () => _showThemeDialog(context, themeMode),
                  isDark: isDark,
                ),
              ], isDark),

              const SizedBox(height: 14),

              // Feedback & Support Section
              _buildSectionHeader('Feedback & Support', isDark),
              const SizedBox(height: 8),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.alternate_email_rounded,
                  iconColor: Colors.blue,
                  title: 'Contact Developer',
                  subtitle: 'unnatitank14@gmail.com',
                  onTap: () => _sendEmail('Feedback'),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.star_rounded,
                  iconColor: Colors.amber,
                  title: 'Rate App',
                  subtitle: 'Show your support on Play Store',
                  onTap: () => _rateApp(),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.share_rounded,
                  iconColor: Colors.green,
                  title: 'Share App',
                  subtitle: 'Invite friends to use the app',
                  onTap: () => _shareApp(),
                  isDark: isDark,
                ),
              ], isDark),

              const SizedBox(height: 14),

              // Legal & About Section
              _buildSectionHeader('Legal & About', isDark),
              const SizedBox(height: 8),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.privacy_tip_rounded,
                  iconColor: Colors.indigo,
                  title: 'Privacy Policy',
                  subtitle: 'Your data is safe and offline',
                  onTap: () => _showPrivacyInfo(),
                  isDark: isDark,
                ),
              ], isDark),

              const Spacer(),
              Center(
                child: Text(
                  _appVersion,
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System default';
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
    }
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
    required Color iconColor,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13, 
                      color: isDark ? Colors.white38 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, 
              color: isDark ? Colors.white10 : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1, 
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      indent: 60,
    );
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('System default', ThemeMode.system, currentMode),
            _buildThemeOption('Light', ThemeMode.light, currentMode),
            _buildThemeOption('Dark', ThemeMode.dark, currentMode),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, ThemeMode mode, ThemeMode currentMode) {
    final isSelected = mode == currentMode;
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Colors.blue) : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setTheme(mode);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _sendEmail(String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'unnatitank14@gmail.com',
      query: 'subject=Indian Law Guide - $subject',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for some devices
        await launchUrl(emailUri);
      }
    } catch (e) {
      _showSnackBar('Could not open email app. Please email unnatitank14@gmail.com');
    }
  }

  Future<void> _rateApp() async {
    final Uri storeUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.indianlaw.indian_constitution_vault',
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
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('• This app works 100% offline'),
            Text('• No personal data is collected'),
            Text('• No analytics or tracking'),
            Text('• All data stays on your device'),
          ],
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
