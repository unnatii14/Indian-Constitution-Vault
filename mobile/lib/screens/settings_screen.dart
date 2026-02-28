import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Settings
          _buildSectionHeader('Language'),
          const SizedBox(height: 8),
          _buildSettingCard(
            context,
            icon: Icons.language,
            title: 'App Language',
            subtitle: 'English',
            onTap: () => _showLanguageDialog(context),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            context,
            icon: Icons.translate,
            title: 'Content Language',
            subtitle: 'English & Hindi',
            onTap: () => _showContentLanguageDialog(context),
          ),

          const SizedBox(height: 24),

          // Display Settings
          _buildSectionHeader('Display'),
          const SizedBox(height: 8),
          _buildSettingCard(
            context,
            icon: Icons.text_fields,
            title: 'Text Size',
            subtitle: 'Medium',
            onTap: () => _showTextSizeDialog(context),
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            context,
            icon: Icons.brightness_6,
            title: 'Theme',
            subtitle: 'System default',
            onTap: () => _showThemeDialog(context),
          ),

          const SizedBox(height: 24),

          // Voice Settings
          _buildSectionHeader('Voice'),
          const SizedBox(height: 8),
          _buildSettingCard(
            context,
            icon: Icons.record_voice_over,
            title: 'Voice Input',
            subtitle: 'Enabled',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Voice settings')));
            },
          ),
          const SizedBox(height: 16),
          _buildSettingCard(
            context,
            icon: Icons.volume_up,
            title: 'Text-to-Speech',
            subtitle: 'Enabled',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('TTS settings')));
            },
          ),

          const SizedBox(height: 24),

          // Data & Storage
          _buildSectionHeader('Data & Storage'),
          const SizedBox(height: 8),
          _buildSettingCard(
            context,
            icon: Icons.cached,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () => _showClearCacheDialog(context),
          ),
        ],
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

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'English'),
            _buildDialogOption(context, 'हिंदी (Hindi)'),
          ],
        ),
      ),
    );
  }

  void _showContentLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'English Only'),
            _buildDialogOption(context, 'Hindi Only'),
            _buildDialogOption(context, 'Both (Bilingual)'),
          ],
        ),
      ),
    );
  }

  void _showTextSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'Small'),
            _buildDialogOption(context, 'Medium'),
            _buildDialogOption(context, 'Large'),
            _buildDialogOption(context, 'Extra Large'),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption(context, 'System default'),
            _buildDialogOption(context, 'Light'),
            _buildDialogOption(context, 'Dark'),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data. The app works offline, so your legal content will still be available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cache cleared')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title selected')));
      },
    );
  }
}
