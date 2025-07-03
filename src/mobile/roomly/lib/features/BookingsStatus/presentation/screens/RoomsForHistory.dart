import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:roomly/features/BookingsStatus/presentation/cubit/bookings_cubit.dart';

class HistoryRoomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateRange;
  final String price;
  final String status;

  const HistoryRoomCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.dateRange,
    required this.price,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity, // Make the card take the full width
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01), // Add some vertical margin
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.36),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
            screenWidth * 0.075), // Responsive border radius
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.2, // Responsive width
            height: screenHeight * 0.1, // Responsive height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  screenWidth * 0.025), // Responsive border radius
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04), // Responsive spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.035, // Responsive font size
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                Text(
                  dateRange,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.035, // Responsive font size
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$price     ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035, // Responsive font size
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: status,
                        style: TextStyle(
                          color: const Color(0xFF0A3FB3),
                          fontSize: screenWidth * 0.035, // Responsive font size
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: () {
                // Add your rebook logic here
                print('Rebook button pressed');
              },
              icon: Icon(
                Icons.refresh, // You can change the icon as needed
                size: screenWidth * 0.04, // Responsive icon size
                color: const Color(0xFF0A3FB3),
              ),
              label: Text(
                'Rebook',
                style: TextStyle(
                  color: const Color(0xFF0A3FB3),
                  fontSize: screenWidth * 0.03, // Responsive font size
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03, // Responsive padding
                  vertical: screenHeight * 0.01, // Responsive padding
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: const Color(0xFF0A3FB3).withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.02), // Responsive border radius
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryRoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: BlocBuilder<BookingsCubit, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BookingsLoaded) {
              // Filter for history bookings (COMPLETED or CANCELLED)
              final historyBookings = state.bookings
                  .where((b) =>
                      b.reservation.status == 'COMPLETED' ||
                      b.reservation.status == 'CANCELLED')
                  .toList();

              if (historyBookings.isEmpty) {
                return Center(child: Text('No history bookings found.'));
              }

              return ListView.separated(
                itemCount: historyBookings.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: screenHeight * 0.02),
                itemBuilder: (context, index) {
                  final booking = historyBookings[index];
                  return HistoryRoomCard(
                    imageUrl: booking.roomDetails.imageUrl,
                    title: booking.roomDetails.name,
                    dateRange:
                        '${_formatDate(booking.reservation.startTime)} - ${_formatDate(booking.reservation.endTime)}',
                    price: '\$${booking.reservation.totalCost}',
                    status: booking.reservation.status,
                  );
                },
              );
            } else if (state is BookingsError) {
              return Center(child: Text('Error: \\${state.message}'));
            }
            return Center(child: Text('No bookings available.'));
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
