import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/account/data/loyalty_api_service.dart';
import 'package:roomly/features/auth/data/models/user_model.dart';

class AccountPage extends StatefulWidget {
  AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel? _currentUser;
  bool _isLoading = true;
  bool _isLoadingPoints = true;
  int _loyaltyPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLoyaltyPoints();
  }

  Future<void> _loadUserData() async {
    try {

      final userData = AppSession().currentUser;
      final userModel = UserModel.fromEntity(userData!);

      setState(() {
        _currentUser = userModel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error - maybe show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  Future<void> _loadLoyaltyPoints() async {
    try {
      // Check if user is authenticated before making API call
      final isAuthenticated = await LoyaltyApiService.isUserAuthenticated();
      if (!isAuthenticated) {
        setState(() {
          _loyaltyPoints = 0;
          _isLoadingPoints = false;
        });
        return;
      }

      // Fetch loyalty points from API
      final points = await LoyaltyApiService.getLoyaltyPointsWithRetry();
      setState(() {
        _loyaltyPoints = points;
        _isLoadingPoints = false;
      });
    } catch (e) {
      setState(() {
        _loyaltyPoints = 0;
        _isLoadingPoints = false;
      });
      print('Error loading loyalty points: $e');
      // Optionally show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load loyalty points'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadLoyaltyPoints,
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoadingPoints = true;
    });
    await _loadLoyaltyPoints();
  }

  String _getUserDisplayName() {
    if (_currentUser == null) return 'Guest User';
    
    final firstName = _currentUser!.firstName ?? '';
    final lastName = _currentUser!.lastName ?? '';
    
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    } else {
      return _currentUser!.email;
    }
  }

  String _getLoyaltyPointsDisplay() {
    if (_isLoadingPoints) {
      return 'Loading...';
    }
    return '$_loyaltyPoints points';
  }

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
          // Add refresh button for loyalty points
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextButton(
                        onPressed: () => _navigateTo(context, '/profile'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundColor: Color.fromARGB(50, 0, 0, 0),
                                child: Icon(Icons.person,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  _getUserDisplayName(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
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
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(20, 10, 64, 179),
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
                    _buildSection(context, 'Account Setting', _getAccountSettings()),
                    _buildSection(context, 'Setting & Privacy', _settingsPrivacy),
                    _buildSection(context, 'Help & Support', _helpSupport),
                    _buildSection(context, '', _logout),
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
            ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<MenuButton> items) {
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

  Widget _buildListTile(MenuButton item, BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(item.title),
      trailing: item.trailing is String
          ? Text(item.trailing!, style: const TextStyle(color: Colors.grey))
          : Icon(item.trailing, color: Colors.grey),
      onTap: () => item.onTap(context),
    );
  }

  List<MenuButton> _getAccountSettings() {
    return [
      MenuButton(
        title: 'Rewards',
        icon: Icons.card_giftcard,
        trailing: _getLoyaltyPointsDisplay(), // Now shows actual points from API
        onTap: (context) => _navigateTo(context, '/loyalty'),
      ),
      MenuButton(
        title: 'Booking History',
        icon: Icons.history,
        trailing: Icons.chevron_right,
        onTap: (context) => _navigateTo(context, '/booking'),
      ),
      MenuButton(
        title: 'Favourites',
        icon: Icons.favorite_border,
        trailing: Icons.chevron_right,
        onTap: (context) => _navigateTo(context, '/favorite'),
      ),
      MenuButton(
        title: 'Requests',
        icon: Icons.question_answer_outlined,
        trailing: Icons.chevron_right,
        onTap: (context) => _navigateTo(context, '/requests'),
      ),
      MenuButton(
        title: 'Cards',
        icon: Icons.credit_card,
        trailing: Icons.chevron_right,
        onTap: (context) => _navigateTo(context, '/cards'),
      ),
      MenuButton(
        title: 'Edit Profile',
        icon: Icons.edit,
        trailing: Icons.chevron_right,
        onTap: (context) => _navigateTo(context, '/profile'),
      ),
    ];
  }

  final List<MenuButton> _settingsPrivacy = [
    MenuButton(
      title: 'Settings',
      icon: Icons.settings,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context, '/settings'),
    ),
  ];

  List<MenuButton> get _logout => [
    MenuButton(
      title: 'Log out',
      icon: Icons.logout,
      trailing: Icons.chevron_right,
      onTap: (context) => _handleLogout(context),
    ),
  ];

  final List<MenuButton> _helpSupport = [
    MenuButton(
      title: 'About App',
      icon: Icons.info_outline,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context, '/about-app'),
    ),
    MenuButton(
      title: 'Help Center',
      icon: Icons.help_outline,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context, '/help-center'),
    ),
    MenuButton(
      title: 'Terms & Policies',
      icon: Icons.description_outlined,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context, '/terms-policies'),
    ),
    MenuButton(
      title: 'Report a Problem',
      icon: Icons.report_problem_outlined,
      trailing: Icons.chevron_right,
      onTap: (context) => _navigateTo(context, '/report-problem'),
    ),
  ];

  static void _navigateTo(BuildContext context, String path) {
    // Implement navigation logic
    context.push(path);
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        // Clear user data from secure storage
        AppSession().clearUser();
        // Navigate to login screen
        if (context.mounted) {
          context.go('/login');
        }
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout: $e')),
        );
      }
    }
  }
}

class MenuButton {
  final String title;
  final IconData icon;
  final dynamic trailing;
  final Function(BuildContext) onTap;

  MenuButton({
    required this.title,
    required this.icon,
    required this.trailing,
    required this.onTap,
  });
}

