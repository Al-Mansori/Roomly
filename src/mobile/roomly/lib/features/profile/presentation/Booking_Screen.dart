import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../GlobalWidgets/ReusableCarrasoul.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _voucherController = TextEditingController();
  final List<String> roomImages = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel with images
            Stack(
              children: [
                ReusableCarousel(
                  images: roomImages,
                  height: MediaQuery.of(context).size.height * 0.5,
                  autoPlay: true,
                  showOverlay: true,
                ),

                // AppBar overlapping the carousel
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          // Handle share action
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          // Handle favorite action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content section below the carousel
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Workspace Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Meeting Room', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),

                  // Loyalty Points Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.loyalty, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Use Your Loyalty Points To Save Money',
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                          onPressed: () {
                            // Handle loyalty points action
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Voucher Code Section
                  TextField(
                    controller: _voucherController,
                    decoration: InputDecoration(
                      hintText: 'Enter voucher code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          // Handle voucher code submission
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Open Hours Section
                  const Text(
                    'Open Hours:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Phone: 10:00 AM - 10:29 PM', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 16),

                  // Amenities Section
                  const Text(
                    'Amenities:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.wifi, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('WiFi'),
                      SizedBox(width: 16),
                      Icon(Icons.local_parking, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Parking'),
                      SizedBox(width: 16),
                      Icon(Icons.local_drink, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Free Tea'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location Section
                  const Text(
                    'Location:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(
                  //   height: 200, // Set the height of the map
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: const MapSample(), // Use the MapSample widget here
                  //   ),
                  // ),
                  const Text(
                    '63 Syria, MI:Masha, Agueta, Oltia\nGovernorate 12665\n12 km away',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  const Text(
                    'Price:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '57.0 EGP/Hour',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Select Date Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle select date action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Select Date'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}