// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildSlyotaionSection(),
              const SizedBox(height: 20),
              _buildSearchBar(),
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
            const Icon(LucideIcons.mapPin, color: Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(width: 8),
            const Text(
              'Dokki',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
      ],
    );
  }

  Widget _buildSlyotaionSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello (Name)!\n",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              "Tell us where you want to go ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search Workspaces',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey),
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
