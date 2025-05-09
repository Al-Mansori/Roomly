import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: TextButton(
                onPressed: () => _navigateTo('Profile'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color.fromARGB(50, 0, 0, 0),
                        child: Icon(Icons.person,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      // const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 16),
                            Text(
                              'Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1),
            // Promotional Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () => _navigateTo('Book Now'),
                // borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(20, 10, 64, 179),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Book now and earn',
                              style: TextStyle(
                                color: Color(0xFF0A3FB3),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0A3FB3),
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          'loyalty points\nfor exclusive discounts!',
                                      style: TextStyle(
                                        color: Color(0xFF0A3FB3),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 16),
                      SvgPicture.asset(
                        'assets/images/Gift.svg',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildSection('Account Setting', _accountSettings),
            _buildSection('Setting & Privacy', _settingsPrivacy),
            _buildSection('Help & Support', _helpSupport),
            _buildSection('', _Logout),
            Center(
              child: SvgPicture.asset(
                'assets/images/roomly_small.svg',
                width: 100,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<MenuButton> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...items.map((item) => _buildListTile(item)),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildListTile(MenuButton item) {
    return ListTile(
      leading: Icon(item.icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(item.title),
      trailing: item.trailing is String
          ? Text(item.trailing!, style: const TextStyle(color: Colors.grey))
          : Icon(item.trailing, color: Colors.grey),
      onTap: () => item.onTap(),
    );
  }

  final List<MenuButton> _accountSettings = [
    MenuButton(
      title: 'Rewards',
      icon: Icons.card_giftcard,
      trailing: '180 points',
      onTap: () => _navigateTo('Rewards'),
    ),
    MenuButton(
      title: 'Booking History',
      icon: Icons.history,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Booking History'),
    ),
    MenuButton(
      title: 'Favourites',
      icon: Icons.favorite_border,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Favourites'),
    ),
    MenuButton(
      title: 'Requests',
      icon: Icons.question_answer_outlined,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Requests'),
    ),
    MenuButton(
      title: 'Cards',
      icon: Icons.credit_card,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Cards'),
    ),
    MenuButton(
      title: 'Edit Profile',
      icon: Icons.edit,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Edit Profile'),
    ),
  ];

  final List<MenuButton> _settingsPrivacy = [
    MenuButton(
      title: 'Settings',
      icon: Icons.settings,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Settings'),
    ),
  ];
  final List<MenuButton> _Logout = [
    MenuButton(
      title: 'Logout',
      icon: Icons.logout,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Logout'),
    ),
  ];

  final List<MenuButton> _helpSupport = [
    MenuButton(
      title: 'About App',
      icon: Icons.info_outline,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('About App'),
    ),
    MenuButton(
      title: 'Help Center',
      icon: Icons.help_outline,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Help Center'),
    ),
    MenuButton(
      title: 'Terms & Policies',
      icon: Icons.description_outlined,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Terms & Policies'),
    ),
    MenuButton(
      title: 'Report a Problem',
      icon: Icons.report_problem_outlined,
      trailing: Icons.chevron_right,
      onTap: () => _navigateTo('Report a Problem'),
    ),
  ];

  static void _navigateTo(String pageName) {
    // Implement navigation logic here
    print('Navigating to $pageName');
  }
}

class MenuButton {
  final String title;
  final IconData icon;
  final dynamic trailing;
  final VoidCallback onTap;

  MenuButton({
    required this.title,
    required this.icon,
    required this.trailing,
    required this.onTap,
  });
}
