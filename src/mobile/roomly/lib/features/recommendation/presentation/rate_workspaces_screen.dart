import 'package:flutter/material.dart';

class RateWorkspacesScreen extends StatelessWidget {
  RateWorkspacesScreen({super.key});

  // Placeholder data for the list
  final List<Map<String, dynamic>> workspaceData = [
    {
      'image_placeholder': 'assets/images/workspace1.png', // Replace with actual image path/URL
      'name': 'Maadi WorkSpace',
      'rating': 4.92,
      'reviews': 116,
      'description': '2 rooms - business , gaming, studying workspace\ncan be customized',
      'price': '\$15,000 for day'
    },
    {
      'image_placeholder': 'assets/images/workspace2.png', // Replace with actual image path/URL
      'name': 'Maadi WorkSpace',
      'rating': 4.92,
      'reviews': 116,
      'description': '2 rooms - business , gaming, studying workspace\ncan be customized',
      'price': '\$15,000 for day'
    },
    {
      'image_placeholder': 'assets/images/workspace3.png', // Replace with actual image path/URL
      'name': 'Maadi WorkSpace',
      'rating': 4.92,
      'reviews': 116,
      'description': '2 rooms - business , gaming, studying workspace\ncan be customized',
      'price': '\$15,000 for day'
    },
    // Add more workspace data here
  ];

  @override
  Widget build(BuildContext context) {
    const Color textBlack = Colors.black87;
    const Color textGrey = Colors.grey;
    const Color primaryBlue = Colors.blue; // For 'See more'
    const Color starYellow = Colors.amber;
    const Color appBarBg = Colors.white; // Or very light grey
    const Color cardBg = Colors.white;
    const Color backButtonBg = Color(0xFFBDBDBD); // Grey for back button circle

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background for the body
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1, // Slight elevation for separation
        shadowColor: Colors.grey.withOpacity(0.3),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
             onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
             borderRadius: BorderRadius.circular(20),
             child: Container(
                decoration: const BoxDecoration(
                  color: backButtonBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new, // Using new variant
                  color: Colors.white,
                  size: 18,
                ),
             ),
          ),
        ),
        title: const Text(
          'Rate Workspaces',
          style: TextStyle(
            color: textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false, // Title appears left-aligned in the image
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: workspaceData.length,
        itemBuilder: (context, index) {
          final item = workspaceData[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Spacing between cards
            child: _buildWorkspaceCard(
              context,
              item,
              textBlack,
              textGrey,
              primaryBlue,
              starYellow,
              cardBg
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkspaceCard(
      BuildContext context,
      Map<String, dynamic> item,
      Color textBlack,
      Color textGrey,
      Color primaryBlue,
      Color starYellow,
      Color cardBg) {
    return Card(
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: cardBg,
      clipBehavior: Clip.antiAlias, // Clip the image to the rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            height: 180, // Adjust height as needed
            width: double.infinity,
            color: Colors.grey[300], // Placeholder color
            child: Center(
              child: Text(
                'Image Placeholder\n(${item['image_placeholder']})',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            // If using actual images:
            // child: Image.asset(
            //   item['image_placeholder'],
            //   fit: BoxFit.cover,
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Title & Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: starYellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item['rating'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: textBlack,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${item['reviews']} reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Row 2: Description
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: textGrey,
                  ),
                ),
                const SizedBox(height: 12),
                // Row 3: Price & See More
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['price'],
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Handle 'See more' tap
                      },
                      child: Row(
                        children: [
                          Text(
                            'See more',
                            style: TextStyle(
                              fontSize: 13,
                              color: primaryBlue,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, color: primaryBlue, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// To run this screen, you would typically have a main.dart file like this:
/*
import 'package:flutter/material.dart';
import 'preference_workspaces_screen.dart'; // Assuming your file is named preference_workspaces_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const PreferenceWorkspacesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
*/

