import 'package:flutter/material.dart';

class WorkspacePlanScreen extends StatelessWidget {
  const WorkspacePlanScreen({super.key});

  // Placeholder data for the plans
  final List<Map<String, dynamic>> planData = const [
    {
      'plan_name': 'Basic Plan',
      'header_color': Color(0xFFE0E0E0), // Light Grey
      'header_text_color': Color(0xFFAAAAAA), // Lighter Grey Text
      'workspace_title': 'Basic Workspace',
      'rating': 4.2,
      'reviews': 89,
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Perfect for small teams and individual professionals.',
      'price': ' \$5,000 per month',
      'button_color': Color(0xFF0D47A1), // Deep Blue
    },
    {
      'plan_name': 'Professional Plan',
      'header_color': Color(0xFFBBDEFB), // Light Blue
      'header_text_color': Color(0xFF0D47A1), // Deep Blue Text
      'workspace_title': 'Professional Workspace',
      'rating': 4.7,
      'reviews': 156,
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. Ideal for growing businesses and medium teams.',
      'price': '	\$12,000 per month',
      'button_color': Color(0xFF0D47A1), // Deep Blue
    },
    {
      'plan_name': 'Enterprise Plan',
      'header_color': Color(0xFFFFECB3), // Light Yellow/Orange
      'header_text_color': Color(0xFFFFA000), // Orange Text
      'workspace_title': 'Enterprise Workspace',
      'rating': 4.9,
      'reviews': 203,
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore. Perfect for large organizations and enterprises.',
      'price': '	\$25,000 per month',
      'button_color': Color(0xFF0D47A1), // Deep Blue
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color textBlack = Colors.black87;
    const Color textGrey = Colors.grey;
    const Color appBarBg = Colors.white;
    const Color cardContentBg = Colors.white;
    const Color backButtonBg =
        Color(0xFF616161); // Dark Grey for back button circle
    const Color starColor = Colors.black87; // Dark star icon

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background for the body
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 1,
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
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        title: const Text(
          'Workspace Plan',
          style: TextStyle(
            color: textBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: planData.length,
        itemBuilder: (context, index) {
          final item = planData[index];
          return Padding(
            padding:
                const EdgeInsets.only(bottom: 20.0), // Spacing between cards
            child: _buildPlanCard(
              context,
              item,
              textBlack,
              textGrey,
              starColor,
              cardContentBg,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    Map<String, dynamic> item,
    Color textBlack,
    Color textGrey,
    Color starColor,
    Color cardContentBg,
  ) {
    const double cardBorderRadius = 12.0;

    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: item['header_color'],
              // Only top corners are rounded here if needed, but Card clip handles it
            ),
            child: Center(
              child: Text(
                item['plan_name'],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: item['header_text_color'],
                ),
              ),
            ),
          ),
          // Content Section
          Container(
            color: cardContentBg,
            padding: const EdgeInsets.all(16.0),
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
                        item['workspace_title'],
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
                        Icon(Icons.star, color: starColor, size: 16),
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
                const SizedBox(height: 10),
                // Row 2: Description
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: textBlack, // Description text seems darker than grey
                    height: 1.4, // Line height
                  ),
                ),
                const SizedBox(height: 16),
                // Row 3: Price & Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['price'],
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle 'Apply Now' tap
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item['button_color'],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                      ),
                      child: const Text('Apply Now',
                          style: TextStyle(fontSize: 14)),
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
import 'workspace_plan_screen.dart'; // Assuming your file is named workspace_plan_screen.dart

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
      home: const WorkspacePlanScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
*/
