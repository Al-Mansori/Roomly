// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_import, camel_case_types

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../GlobalWidgets/navBar.dart';

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
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  int _selectedIndex = 0;

  final List<String> _routes = ['/', '/rooms', '/room/1', '/signup', '/login'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]); // Navigate to the selected route
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0, // Only allow back if on Home
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // If not on Home, go back to Home instead of closing the app
          setState(() {
            _selectedIndex = 0;
          });
          context.go('/'); // Navigate back to Home
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Main content with scrolling
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

            // Custom Bottom Navigation Bar
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? -100 : (_isNavVisible ? 20 : -80),
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _isNavVisible && MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
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
                width: 20, // Adjust size as needed
                height: 20,
                colorFilter: const ColorFilter.mode(
                    Colors.white, BlendMode.srcIn), // Apply color if needed
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
            width: 20, // Adjust size as needed
            height: 20,
            colorFilter: const ColorFilter.mode(
                Colors.white, BlendMode.srcIn), // Apply color if needed
          ),
        ),
      ),
    ],
  );
}

Widget _buildSalutationSection() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    // mainAxisAlignment: MainAxisAlignment.spaceAround,
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

      // Ensures the image covers the entire container
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

// Widget _buildSearchBar() {
//   return Container(
//     decoration: BoxDecoration(
//       color: const Color.fromARGB(127, 0, 0, 0),
//       borderRadius: BorderRadius.circular(25),
//     ),
//     child: Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: TextField(
//         style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
//         decoration: InputDecoration(
//           hintText: 'Search Workspaces',
//           hintStyle: TextStyle(color: Color.fromARGB(127, 255, 255, 255)),
//           border: InputBorder.none,
//           icon: SvgPicture.asset(
//             'assets/icons/magnifying-glass-solid.svg',
//             width: 15,
//             height: 15,
//             colorFilter: const ColorFilter.mode(
//                 Color.fromARGB(127, 255, 255, 255),
//                 BlendMode.srcIn), // Apply color if needed
//           ),
//           // suffixIcon: Padding(
//           //   padding: EdgeInsets.all(15),
//           //   child: SvgPicture.asset(
//           //     'assets/icons/xmark-solid (1).svg',
//           //     width: 10,
//           //     height: 10,
//           //     colorFilter: const ColorFilter.mode(
//           //         Color.fromARGB(127, 255, 255, 255),
//           //         BlendMode.srcIn), // Apply color if needed
//           //   ),
//           // ),
//         ),
//       ),
//     ),
//   );
// }

Widget _buildSearchBar() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25), // Ensures the blur is clipped
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
      child: Container(
        decoration: BoxDecoration(
          color:
              const Color.fromARGB(127, 0, 0, 0), // Semi-transparent background
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
      "price": "75 EGP/h"
    },
    {
      "imagePath": "assets/images/images (1).jpeg",
      "title": "Private Office",
      "location": "3.1 KM away",
      "details": "Modern workspace with high-speed WiFi & custom seating",
      "rating": 4.8,
      "reviews": 98,
      "price": "120 EGP/h"
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
          // return _buildWorkspaceCard();
          return WorkspaceCard(
            imagePath: workspaces[index]["imagePath"],
            title: workspaces[index]["title"],
            location: workspaces[index]["location"],
            details: workspaces[index]["details"],
            rating: workspaces[index]["rating"],
            reviews: workspaces[index]["reviews"],
            price: workspaces[index]["price"],
          );
        },
      ),
    ),
  );
}

/*
  Widget _buildRecommendedWorkspaces(BuildContext context) {
    final List<Map<String, dynamic>> workspaces = [
      {
        "imagePath": "assets/images/Wo Space 3.png",
        "title": "Meeting Room",
        "location": "5.3 KM away",
        "details":
            "2 rooms - business, gaming, studying workspace\ncan be customized",
        "rating": 4.92,
        "reviews": 116,
        "price": "\$15,000 for day"
      },
      {
        "imagePath": "assets/images/images (1).jpeg",
        "title": "Private Office",
        "location": "3.1 KM away",
        "details": "Modern workspace with high-speed WiFi & custom seating",
        "rating": 4.8,
        "reviews": 98,
        "price": "\$12,000 for day"
      },
    ];

    double screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight * 0.28; // 28% of screen height

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: cardHeight,
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
            );
          },
        ),
      ),
    );
  }


*/

Widget _buildWorkspaceCard() {
  return Container(
    width: 250,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color.fromARGB(100, 0, 0, 0)),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(0, 0, 0, 0),
          blurRadius: 1,
          spreadRadius: 0.1,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/Wo Space 3.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meeting Room',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('5.3 km away'),
            ],
          ),
        ),
      ],
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
        width: 70, // Square size
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background color
          borderRadius: BorderRadius.circular(15), // Rounded corners
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Ensures it fills the box properly
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontSize: 14)),
    ],
  );
}

/*
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Booking'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
*/

/*
  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16), // Spacing from edges
      decoration: BoxDecoration(
        color: Colors.black87, // Dark background for the navbar
        borderRadius: BorderRadius.circular(30), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Smooth corners
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // 🛑 Make it fully transparent!
          selectedItemColor: Colors.white, // Active icon color
          unselectedItemColor: Colors.grey, // Inactive icon color
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0, // Remove shadow effect
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: 'Booking'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}

*/

/*



class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // Semi-transparent background
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white), // Text color
        decoration: InputDecoration(
          hintText: 'Search Workspaces',
          hintStyle: const TextStyle(color: Colors.white70), // Hint text color

          // 🔍 Search icon (prefix)
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 20,
              height: 20,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),

          // ❌ Clear icon (suffix)
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () {
                    _controller.clear(); // Clear text when pressed
                    setState(() {}); // Refresh UI
                  },
                )
              : null,

          border: InputBorder.none, // Remove default border
        ),
        onChanged: (text) {
          setState(() {}); // Update UI to show/hide the clear icon
        },
      ),
    );
  }
}
*/

/*
class WorkspaceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String details;
  final double rating;
  final int reviews;
  final String price;

  const WorkspaceCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.details,
    required this.rating,
    required this.reviews,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child:
                    Icon(Icons.favorite_border, color: Colors.white, size: 28),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // Location
                Text(
                  "in (workspace name)",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                // Distance
                Text(
                  location,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),

                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "$rating ($reviews reviews)",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    details,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),

                // Price
                Text(
                  price,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // See More
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See more →",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/
//old card

class WorkspaceCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String location;
  final String details;
  final double rating;
  final int reviews;
  final String price;

  const WorkspaceCard({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.details,
    required this.rating,
    required this.reviews,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.75; // 75% of screen width
    double cardHeight = screenWidth * 0.6; // 60% of screen width
    double imageHeight = cardHeight * 0.5; // Image takes 50% of card height

    return Container(
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
          // IMAGE SECTION
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

          // TEXT CONTENT (SCROLLABLE)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // ✅ Smooth scrolling
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE & LOCATION
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

                  // DETAILS (SCROLLS IF LONG)
                  Text(
                    details,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  const SizedBox(height: 6),

                  // RATING & PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // STAR RATING
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            " $rating (${reviews.toString()} reviews)",
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
                      ),

                      // PRICE
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

                  // SEE MORE BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "See more →",
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
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black, // Background color
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.search, "Search", 1),
            _buildNavItem(Icons.bookmark, "Booking", 2),
            _buildNavItem(Icons.favorite, "Favorite", 3),
            _buildNavItem(Icons.person, "Account", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selectedIndex == index ? Colors.white : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: selectedIndex == index ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
