import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors based on the image analysis
    const Color appBarColor = Color(0xFFE0E0E0); // Light grey
    const Color primaryBlue = Color(0xFF0D47A1); // Deep blue for indicators/logo
    const Color textGrey = Colors.grey;
    const Color textBlack = Colors.black87;
    const Color searchBarBorderColor = Color(0xFFBDBDBD); // Grey for border
    const Color searchBarFillColor = Color(0xFFFAFAFA); // Very light grey/off-white fill
    const Color iconOrange = Colors.orange; // Placeholder
    const Color iconBlue = Colors.blue; // Placeholder

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textBlack),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(color: textBlack, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'How Can We\nHelp You Today?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textBlack,
                ),
              ),
              const SizedBox(height: 20),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Reservation',
                  hintStyle: const TextStyle(color: textGrey),
                  prefixIcon: const Icon(Icons.search, color: textGrey),
                  filled: true,
                  fillColor: searchBarFillColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: searchBarBorderColor, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30.0),
                     borderSide: const BorderSide(color: searchBarBorderColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30.0),
                     borderSide: const BorderSide(color: primaryBlue, width: 1.0), // Highlight focus
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Horizontal Scroll Cards
              SizedBox(
                height: 130, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Example count
                  itemBuilder: (context, index) {
                    return _buildHelpCard(primaryBlue, textBlack, textGrey);
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'latest discussions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textBlack,
                ),
              ),
              const SizedBox(height: 15),
              // Discussion List
              _buildDiscussionItem('How do i edit my reservation?', iconOrange, textBlack),
              const Divider(thickness: 0.5),
              _buildDiscussionItem('How do i change my password?', iconBlue, textBlack),
              const Divider(thickness: 0.5),
              _buildDiscussionItem('How do i change my password?', iconOrange, textBlack),
              // Add more items or use ListView.builder for dynamic list

              const SizedBox(height: 40),
              // Roomly Logo Placeholder
              Center(
                child: Container(
                  height: 30,
                  width: 100,
                  color: Colors.grey[200], // Placeholder color
                  child: const Center(
                    child: Text(
                      'ROOMLY Logo',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the horizontal cards
  Widget _buildHelpCard(Color primaryBlue, Color textBlack, Color textGrey) {
    return Container(
      width: 220, // Adjust width as needed
      margin: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
         border: Border.all(color: Colors.grey[300]!, width: 0.5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'How do I cancel my Reservation without fees?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textBlack,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'you can achieve that by , lorim ispum lorim etc',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                   maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for discussion list items
  Widget _buildDiscussionItem(String title, Color iconColor, Color textBlack) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Placeholder for Icon
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.question_answer_outlined, color: iconColor, size: 20), // Placeholder icon
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textBlack,
                fontSize: 15,
                 fontWeight: FontWeight.w500
              ),
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
import 'help_center_screen.dart'; // Assuming your file is named help_center_screen.dart

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
        fontFamily: 'YourAppFont', // Optional: Define a default font
      ),
      home: const HelpCenterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
*/

