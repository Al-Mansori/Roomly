import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/BookingsStatus/domain/entities/booking_with_room.dart';
import 'package:roomly/features/BookingsStatus/presentation/cubit/bookings_cubit.dart';
import 'package:roomly/features/BookingsStatus/presentation/screens/BookingCard.dart';
import 'package:roomly/features/GlobalWidgets/app_session.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import '../../../GlobalWidgets/navBar.dart';
import 'package:go_router/go_router.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isNavVisible = true;
  bool _isScrollingDown = false;
  String? _currentUserId;

  final List<String> tabs = ["Upcoming", "On-going", "Pending", "History"];
  int selectedTab = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final UserEntity? user = AppSession().currentUser;
      final userId = user?.id;
      if (userId != null) {
        setState(() => _currentUserId = userId);
        context.read<BookingsCubit>().loadBookings(userId);
      } else {
        print('No user ID found - user may not be logged in');
      }
    } catch (e) {
      print('Error loading user ID: $e');
    }
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
        ScrollDirection.forward) {
      setState(() {
        _isScrollingDown = false;
        _isNavVisible = true;
      });
    }
  }

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
              // Tab Selector
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
                      children: List.generate(
                        tabs.length,
                        (index) => GestureDetector(
                          onTap: () => setState(() => selectedTab = index),
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

              // Bookings List
              Expanded(
                child: BlocBuilder<BookingsCubit, BookingsState>(
                  builder: (context, state) {
                    if (state is BookingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BookingsLoaded) {
                      final List<BookingWithRoom> filteredBookings =
                          _filterBookings(state.bookings);
                      return _buildBookingsList(filteredBookings);
                    } else if (state is BookingsError) {
                      return _buildErrorState(state);
                    }
                    return const Center(child: Text('No bookings available'));
                  },
                ),
              ),
            ],
          ),

          // Animated NavBar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? -100
                : (_isNavVisible ? 20 : -80),
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity:
                  _isNavVisible && MediaQuery.of(context).viewInsets.bottom == 0
                      ? 1.0
                      : 0.0,
              child: BottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }

  List<BookingWithRoom> _filterBookings(List<BookingWithRoom> bookings) {
    switch (selectedTab) {
      case 0: // Upcoming
        return bookings
            .where((b) =>
                b.reservation.reservationDate.isAfter(DateTime.now()) &&
                b.reservation.status != 'CANCELLED')
            .toList();
      case 1: // On-going
        return bookings
            .where((b) =>
                b.reservation.startTime.isBefore(DateTime.now()) &&
                b.reservation.endTime.isAfter(DateTime.now()) &&
                b.reservation.status != 'CANCELLED')
            .toList();
      case 2: // Pending
        return bookings
            .where((b) => b.reservation.status == 'PENDING')
            .toList();
      case 3: // History
        return bookings
            .where((b) =>
                b.reservation.endTime.isBefore(DateTime.now()) ||
                b.reservation.status == 'CANCELLED')
            .toList();
      default:
        return [];
    }
  }

  Widget _buildBookingsList(List<BookingWithRoom> bookings) {
    if (bookings.isEmpty) {
      return Center(
          child: Text('No ${tabs[selectedTab].toLowerCase()} bookings found',
              style: const TextStyle(fontSize: 16)));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80), // Space for NavBar
      itemCount: bookings.length,
      itemBuilder: (context, index) => BookingCard(
        bookingWithRoom: bookings[index],
        type: _getCardType(),
        onCancel: () {
          final userId = _currentUserId;
          final reservationId = bookings[index].reservation.id;
          if (userId != null) {
            context.read<BookingsCubit>().cancelReservation(
                  reservationId: reservationId,
                  userId: userId,
                );
          }
        },
        onRebook: () {
          final roomId = bookings[index].roomId;
          final workspaceId = bookings[index].workspaceId;
          context.push('/room/$roomId', extra: {'workspaceId': workspaceId});
        },
      ),
    );
  }

  Widget _buildErrorState(BookingsError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: ${state.message}',
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _currentUserId != null
                ? context.read<BookingsCubit>().loadBookings(_currentUserId!)
                : _loadCurrentUserId(),
            child: const Text('Retry'),
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
