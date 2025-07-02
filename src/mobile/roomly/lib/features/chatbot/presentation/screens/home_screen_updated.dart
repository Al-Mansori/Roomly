// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_import, camel_case_types

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:roomly/features/GlobalWidgets/navBar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  int _selectedIndex = 0;

  final List<String> _routes = [
    '/',
    '/',
    '/',
    '/',
    '/',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.push(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _selectedIndex = 0;
          });
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchSection(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Recommended for you!'),
                    _buildRecommendedWorkspaces(),
                    const SizedBox(height: 20),
                    _buildSectionTitle('Find the perfect workspace for you'),
                    _buildCategories(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            // Chatbot floating button
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? -100
                  : (_isNavVisible ? 100 : 20),
              right: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _isNavVisible &&
                        MediaQuery.of(context).viewInsets.bottom == 0
                    ? 1.0
                    : 0.0,
                child: FloatingActionButton(
                  onPressed: () {
                    context.push('/chatbot');
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? -100
                  : (_isNavVisible ? 20 : -80),
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _isNavVisible &&
                        MediaQuery.of(context).viewInsets.bottom == 0
                    ? 1.0
                    : 0.0,
                child: BottomNavBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(190, 0, 0, 0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.search, 'Search', 1),
            _buildNavItem(Icons.bookmark, 'Booking', 2),
            _buildNavItem(Icons.favorite, 'Favorite', 3),
            _buildNavItem(Icons.person, 'Account', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.white : Colors.grey,
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _selectedIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(127, 0, 0, 0),
                  shape: BoxShape.circle),
              width: 45,
              height: 45,
              child: IconButton(
                onPressed: () {
                  print("location got pressed");
                },
                icon: SvgPicture.asset(
                  'assets/icons/location-arrow-solid.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Dokki',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(127, 0, 0, 0), shape: BoxShape.circle),
          width: 45,
          height: 45,
          child: IconButton(
            onPressed: () {
              print("Profile got pressed");
            },
            icon: SvgPicture.asset(
              'assets/icons/user-regular (1).svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                  Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSalutationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello (Name)!",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              "Tell us where you want to go ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchSection() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/360-workspace-kita-e2-open-office (1).jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              const Color.fromARGB(127, 0, 0, 0), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAppBar(),
            const SizedBox(height: 20),
            _buildSalutationSection(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(127, 0, 0, 0),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search Workspaces',
                hintStyle:
                    TextStyle(color: const Color.fromRGBO(255, 255, 255, 127)),
                border: InputBorder.none,
                icon: SvgPicture.asset(
                  'assets/icons/magnifying-glass-solid.svg',
                  width: 15,
                  height: 15,
                  colorFilter: ColorFilter.mode(
                    const Color.fromRGBO(255, 255, 255, 127),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRecommendedWorkspaces() {
    final List<Map<String, dynamic>> workspaces = [
      {
        "imagePath": "assets/images/Wo Space 3.png",
        "title": "Meeting Room",
        "location": "5.3 KM away",
        "details":
            "2 rooms - business, gaming, studying workspace\ncan be customized",
        "rating": 4.92,
        "reviews": 116,
        "price": "75 EGP/h",
        "id": "ws001"
      },
      {
        "imagePath": "assets/images/images (1).jpeg",
        "title": "Private Office",
        "location": "3.1 KM away",
        "details": "Modern workspace with high-speed WiFi & custom seating",
        "rating": 4.8,
        "reviews": 98,
        "price": "120 EGP/h",
        "id": "ws002"
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: workspaces.length,
          itemBuilder: (context, index) {
            return WorkspaceCard(
              imagePath: workspaces[index]["imagePath"],
              title: workspaces[index]["title"],
              location: workspaces[index]["location"],
              details: workspaces[index]["details"],
              rating: workspaces[index]["rating"],
              reviews: workspaces[index]["reviews"],
              price: workspaces[index]["price"],
              onTap: () {
                context.go('/workspace/${workspaces[index]["id"]}');
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryItem('Desk', 'assets/images/image.png'),
        _buildCategoryItem('Meeting Room', 'assets/images/image-1.png'),
        _buildCategoryItem('Gaming Room', 'assets/images/image-2.png'),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class WorkspaceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String details;
  final double rating;
  final int reviews;
  final String price;
  final VoidCallback? onTap;

  const WorkspaceCard({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.details,
    required this.rating,
    required this.reviews,
    required this.price,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.75;
    double cardHeight = screenWidth * 0.6;
    double imageHeight = cardHeight * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(
                              " $rating (${reviews.toString()} reviews)",
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                          ],
                        ),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: onTap,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          "Book Now",
                          style: TextStyle(fontSize: screenWidth * 0.035),
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

