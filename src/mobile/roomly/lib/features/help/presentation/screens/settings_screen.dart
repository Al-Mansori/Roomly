import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool lockAppInBackground = true;
  bool useFingerprint = true;
  bool enableNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // COMMON Section
          _buildSectionHeader('COMMON'),
          _buildSettingsTile(
            icon: Icons.language,
            iconColor: const Color(0xFF1976D2),
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.public,
            iconColor: const Color(0xFF1976D2),
            title: 'Environment',
            subtitle: 'Production',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.computer,
            iconColor: const Color(0xFF1976D2),
            title: 'Platform',
            subtitle: '',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.add,
            iconColor: const Color(0xFF1976D2),
            title: 'Enable Custom Theme',
            subtitle: 'Customize app appearance',
            onTap: () {},
          ),
          
          // ACCOUNT Section
          _buildSectionHeader('ACCOUNT'),
          _buildSettingsTile(
            icon: Icons.phone,
            iconColor: const Color(0xFF1976D2),
            title: 'Phone Number',
            subtitle: '+1 (555) 123-4567',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.email,
            iconColor: const Color(0xFF1976D2),
            title: 'Email',
            subtitle: 'user@example.com',
            onTap: () {},
          ),
          
          // SECURITY Section
          _buildSectionHeader('SECURITY'),
          _buildSwitchTile(
            icon: Icons.lock,
            iconColor: const Color(0xFF1976D2),
            title: 'Lock App in Background',
            subtitle: 'Secure app when minimized',
            value: lockAppInBackground,
            onChanged: (value) {
              setState(() {
                lockAppInBackground = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.fingerprint,
            iconColor: const Color(0xFF1976D2),
            title: 'Use Fingerprint',
            subtitle: 'Biometric authentication',
            value: useFingerprint,
            onChanged: (value) {
              setState(() {
                useFingerprint = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.notifications,
            iconColor: const Color(0xFF1976D2),
            title: 'Enable Notifications',
            subtitle: 'Push notifications and alerts',
            value: enableNotifications,
            onChanged: (value) {
              setState(() {
                enableNotifications = value;
              });
            },
          ),
          _buildSettingsTile(
            icon: Icons.help_center,
            iconColor: const Color(0xFF1976D2),
            title: 'Help Center',
            subtitle: 'Get support and find answers',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.info,
            iconColor: const Color(0xFF1976D2),
            title: 'About App',
            subtitle: 'Version 1.2.3 • Learn more about us',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 20,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1976D2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

