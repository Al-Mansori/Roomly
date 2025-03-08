import 'package:flutter/material.dart';

class BookingCard extends StatelessWidget {
  final String bookingDate;
  final String imageUrl;
  final String roomTitle;
  final String roomDescription;
  final String distance;
  final VoidCallback onCancel;
  final VoidCallback onModify;

  const BookingCard({
    Key? key,
    required this.bookingDate,
    required this.imageUrl,
    required this.roomTitle,
    required this.roomDescription,
    required this.distance,
    required this.onCancel,
    required this.onModify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookingDate,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.14)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: 108,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            roomDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Cancel Booking" , style: TextStyle(fontSize: 10),),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onModify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.edit, size: 10),
                        label: const Text("Modify" , style: TextStyle(fontSize: 10),),
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



class BookingList extends StatelessWidget {
  final List<Map<String, String>> bookings = [
    {
      "bookingDate": "March 8, 2025",
      "imageUrl": "https://i.pinimg.com/736x/a5/06/0f/a5060f1a5bd1d9bfe99d474bd052a891.jpg",
      "roomTitle": "Meeting Room (2 people)",
      "roomDescription": "2 rooms - business, gaming, studying workspace\ncan be customized",
      "distance": "12.5 km away"
    },
    {
      "bookingDate": "March 9, 2025",
      "imageUrl": "https://i.pinimg.com/736x/a5/06/0f/a5060f1a5bd1d9bfe99d474bd052a891.jpg",
      "roomTitle": "Private Office",
      "roomDescription": "1 office - ideal for business meetings and work sessions",
      "distance": "8 km away"
    },
    {
      "bookingDate": "March 10, 2025",
      "imageUrl": "https://i.pinimg.com/736x/a5/06/0f/a5060f1a5bd1d9bfe99d474bd052a891.jpg",
      "roomTitle": "Conference Room",
      "roomDescription": "Spacious room for team discussions and presentations",
      "distance": "15 km away"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            bookingDate: booking["bookingDate"]!,
            imageUrl: booking["imageUrl"]!,
            roomTitle: booking["roomTitle"]!,
            roomDescription: booking["roomDescription"]!,
            distance: booking["distance"]!, onCancel: () {  }, onModify: () {  },
          );
        },
      ),
    );
  }
}
