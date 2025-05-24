import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roomly/core/router/app_router.dart' as router;
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
                onPressed: () => _navigateTo(context,'Profile'),
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
                onPressed: () => _navigateTo(context, '/loyalty'),
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
            _buildSection(context, 'Account Setting', _accountSettings),
            _buildSection(context, 'Setting & Privacy', _settingsPrivacy),
            _buildSection(context, 'Help & Support', _helpSupport),
            _buildSection(context, '', _Logout),
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

  Widget _buildSection(BuildContext context, String title, List<MenuButton> items) {
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
        ...items.map((item) => _buildListTile(item, context)),
        const Divider(height: 1),
      ],
    );
  }


  Widget _buildListTile(MenuButton item , BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(item.title),
      trailing: item.trailing is String
          ? Text(item.trailing!, style: const TextStyle(color: Colors.grey))
          : Icon(item.trailing, color: Colors.grey),
      onTap: () => item.onTap( context),
    );
  }

  final List<MenuButton> _accountSettings = [
    MenuButton(
      title: 'Rewards',
      icon: Icons.card_giftcard,
      trailing: '180 points',
       onTap: (context) => _navigateTo(context, '/loyalty'),
    ),
    MenuButton(
      title: 'Booking History',
      icon: Icons.history,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Booking History'),
    ),
    MenuButton(
      title: 'Favourites',
      icon: Icons.favorite_border,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Favourites'),
    ),
    MenuButton(
      title: 'Requests',
      icon: Icons.question_answer_outlined,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Requests'),
    ),
    MenuButton(
      title: 'Cards',
      icon: Icons.credit_card,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Cards'),
    ),
    MenuButton(
      title: 'Edit Profile',
      icon: Icons.edit,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Edit Profile'),
    ),
  ];

  final List<MenuButton> _settingsPrivacy = [
    MenuButton(
      title: 'Settings',
      icon: Icons.settings,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Settings'),
    ),
  ];
  final List<MenuButton> _Logout = [
    MenuButton(
      title: 'Logout',
      icon: Icons.logout,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/Logout'),
    ),
  ];

  final List<MenuButton> _helpSupport = [
    MenuButton(
      title: 'About App',
      icon: Icons.info_outline,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/AboutApp'),
    ),
    MenuButton(
      title: 'Help Center',
      icon: Icons.help_outline,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/HelpCenter'),
    ),
    MenuButton(
      title: 'Terms & Policies',
      icon: Icons.description_outlined,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/TermsPolicies'),
    ),
    MenuButton(
      title: 'Report a Problem',
      icon: Icons.report_problem_outlined,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context,'/ReportaProblem'),
    ),
  ];

  static void _navigateTo(context, String path) {
    // Implement navigation logic 
    context.push(path);
    // print('Navigating to $pageName');
  }
}

class MenuButton {
  final String title;
  final IconData icon;
  final dynamic trailing;
  // final VoidCallback onTap;
  final Function(BuildContext) onTap;

  MenuButton({
    required this.title,
    required this.icon,
    required this.trailing,
    required this.onTap,
  });
}
