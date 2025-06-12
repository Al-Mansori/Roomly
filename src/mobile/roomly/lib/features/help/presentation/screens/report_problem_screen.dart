import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors based on the image analysis
    const Color appBarColor = Color(0xFFE0E0E0); // Light grey
    const Color primaryBlue = Color(0xFF0D47A1); // Deep blue for button/logo/icon
    const Color textGrey = Colors.grey;
    const Color textBlack = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0, // Minimal elevation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Back icon
          onPressed: () {
            // Handle back navigation
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Report a Problem',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView for smaller screens
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Placeholder for the illustration image
              Container(
                height: 200,
                width: double.infinity,
                color: const Color.fromARGB(255, 255, 255, 255), // Placeholder color
                child: Center(
                  // Add image from assets
                  child: Image.asset(
                    'assets/images/report-problem.jpg',
                    width: 400,
                    height: 400,
                  ), 
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'How Can Roomly Help You?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textBlack,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Send Us Your Problem and We Will\nWork on Solving it',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textGrey,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: Colors.grey[300]!, width: 0.5)
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.email_outlined, // Placeholder icon
                      size: 40,
                      color: primaryBlue,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Email Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Contact Us Through Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: textGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Email button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      ),
                      child: const Text('Email'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // Placeholder for the Roomly logo
              Container(
                 height: 50,
                 width: 200,
                 color: const Color.fromARGB(255, 255, 255, 255), // Placeholder color
                 child: Center(
                  child: SvgPicture.asset(
                    'assets/images/roomly_small.svg',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
               const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
