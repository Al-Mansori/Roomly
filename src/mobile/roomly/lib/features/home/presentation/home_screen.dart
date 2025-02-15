// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unused_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: Padding(
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
            ],
          ),
        ),
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
              color: const Color.fromARGB(127, 0, 0, 0),
              shape: BoxShape.circle),
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(127, 0, 0, 0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          decoration: InputDecoration(
            hintText: 'Search Workspaces',
            hintStyle: TextStyle(color: Color.fromARGB(127, 255, 255, 255)),
            border: InputBorder.none,
            icon: SvgPicture.asset(
              'assets/icons/magnifying-glass-solid.svg',
              width: 15,
              height: 15,
              colorFilter: const ColorFilter.mode(
                  Color.fromARGB(127, 255, 255, 255),
                  BlendMode.srcIn), // Apply color if needed
            ),
            // suffixIcon: Padding(
            //   padding: EdgeInsets.all(15),
            //   child: SvgPicture.asset(
            //     'assets/icons/xmark-solid (1).svg',
            //     width: 10,
            //     height: 10,
            //     colorFilter: const ColorFilter.mode(
            //         Color.fromARGB(127, 255, 255, 255),
            //         BlendMode.srcIn), // Apply color if needed
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecommendedWorkspaces() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          return _buildWorkspaceCard();
        },
      ),
    );
  }

  Widget _buildWorkspaceCard() {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
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
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/workspace.jpg'),
                fit: BoxFit.cover,
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
        _buildCategoryItem('Desk', Icons.desk),
        _buildCategoryItem('Meeting Room', Icons.meeting_room),
        _buildCategoryItem('Gaming Room', Icons.videogame_asset),
      ],
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          radius: 30,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

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

// class SearchBar extends StatefulWidget {
//   const SearchBar({super.key});

//   @override
//   _SearchBarState createState() => _SearchBarState();
// }

// class _SearchBarState extends State<SearchBar> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.3), // Semi-transparent background
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: TextField(
//         controller: _controller,
//         style: const TextStyle(color: Colors.white), // Text color
//         decoration: InputDecoration(
//           hintText: 'Search Workspaces',
//           hintStyle: const TextStyle(color: Colors.white70), // Hint text color

//           // 🔍 Search icon (prefix)
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(12),
//             child: SvgPicture.asset(
//               'assets/icons/search.svg',
//               width: 20,
//               height: 20,
//               colorFilter:
//                   const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//             ),
//           ),

//           // ❌ Clear icon (suffix)
//           suffixIcon: _controller.text.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.clear, color: Colors.white),
//                   onPressed: () {
//                     _controller.clear(); // Clear text when pressed
//                     setState(() {}); // Refresh UI
//                   },
//                 )
//               : null,

//           border: InputBorder.none, // Remove default border
//         ),
//         onChanged: (text) {
//           setState(() {}); // Update UI to show/hide the clear icon
//         },
//       ),
//     );
//   }
// }
