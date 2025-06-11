import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/BookingsStatus/domain/entities/booking_with_room.dart';
import 'package:roomly/features/BookingsStatus/presentation/cubit/bookings_cubit.dart';
import 'package:roomly/features/BookingsStatus/presentation/screens/BookingCard.dart';
import '../../../GlobalWidgets/TabBar.dart';
import '../../../GlobalWidgets/navBar.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context
        .read<BookingsCubit>()
        .loadBookings('usr001'); // Replace with actual user ID
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrollingDown) {
        setState(() {
          _isScrollingDown = true;
          _isNavVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _scrollController.position.atEdge) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

  final List<String> tabs = ["Upcoming", "On-going", "Pending", "History"];
  int selectedTab = 1;

  BookingCardType _getCardType() {
    switch (selectedTab) {
      case 0:
        return BookingCardType.upcoming;
      case 1:
        return BookingCardType.ongoing;
      case 2:
        return BookingCardType.pending;
      case 3:
        return BookingCardType.history;
      default:
        return BookingCardType.ongoing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        tabs.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: selectedTab == index
                                  ? Colors.white
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color: selectedTab == index
                                    ? Colors.black
                                    : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<BookingsCubit, BookingsState>(
                  builder: (context, state) {
                    if (state is BookingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BookingsLoaded) {
                      final bookings = state.bookings;
                      List<BookingWithRoom> filteredBookings = [];
                      switch (selectedTab) {
                        case 0: // Upcoming
                          filteredBookings = bookings
                              .where((b) =>
                                  b.reservation.reservationDate
                                      .isAfter(DateTime.now()) &&
                                  b.reservation.status != 'CANCELLED')
                              .toList();
                          break;
                        case 1: // On-going
                          filteredBookings = bookings
                              .where((b) =>
                                  b.reservation.startTime
                                      .isBefore(DateTime.now()) &&
                                  b.reservation.endTime
                                      .isAfter(DateTime.now()) &&
                                  b.reservation.status != 'CANCELLED')
                              .toList();
                          break;
                        case 2: // Pending
                          filteredBookings = bookings
                              .where((b) => b.reservation.status == 'PENDING')
                              .toList();
                          break;
                        case 3: // History
                          filteredBookings = bookings
                              .where((b) =>
                                  b.reservation.endTime
                                      .isBefore(DateTime.now()) ||
                                  b.reservation.status == 'CANCELLED')
                              .toList();
                          break;
                      }
                      if (filteredBookings.isEmpty) {
                        return Center(
                          child: Text(
                            'No ${tabs[selectedTab].toLowerCase()} bookings found',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return BookingCard(
                            bookingWithRoom: booking,
                            type: _getCardType(),
                            onCancel: () {
                              // TODO: Implement cancel logic
                            },
                            onModify: () {
                              // TODO: Implement modify logic
                            },
                            onRebook: () {
                              // TODO: Implement rebook logic
                            },
                          );
                        },
                      );
                    } else if (state is BookingsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<BookingsCubit>().loadBookings(
                                    'usr001'); // Replace with actual user ID
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(child: Text('No bookings available'));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? -100
                : (_isNavVisible ? 0 : -80),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isNavVisible &&
                        MediaQuery.of(context).viewInsets.bottom == 0
                    ? 1.0
                    : 0.0,
                child: BottomNavBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
