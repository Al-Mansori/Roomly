import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../GlobalWidgets/app_session.dart';
import '../../../loyalty/presentation/cubit/loyalty_points_cubit.dart';
import '../../../loyalty/presentation/cubit/loyalty_points_state.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_staffId_usecase.dart';
import '../cubits/booking/cubit/booking_cubit.dart';
import '../cubits/booking/state/booking_state.dart';

class ReviewBookingScreen extends StatefulWidget {
  final RoomEntity room;
  final DateTime selectedDate;
  final String checkInTime;
  final String checkOutTime;
  final int numberOfSeats;
  final double totalPrice;
  final String workspaceId;

  const ReviewBookingScreen({
    super.key,
    required this.room,
    required this.selectedDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.numberOfSeats,
    required this.totalPrice,
    required this.workspaceId,
  });

  @override
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  String? _selectedPayment;
  bool _isRedeemLoyaltySelected = false;
  final TextEditingController _loyaltyPointsController = TextEditingController();
  String? _errorMessage;
  int _pointsToRedeem = 0;

  @override
  void initState() {
    super.initState();
    context.read<LoyaltyPointsCubit>().loadLoyaltyPoints();
    _loyaltyPointsController.addListener(_updatePointsToRedeem);
  }

  @override
  void dispose() {
    _loyaltyPointsController.removeListener(_updatePointsToRedeem);
    _loyaltyPointsController.dispose();
    super.dispose();
  }

  void _updatePointsToRedeem() {
    setState(() {
      _pointsToRedeem = int.tryParse(_loyaltyPointsController.text) ?? 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoyaltyPointsCubit>(

          create: (context) => context.read<LoyaltyPointsCubit>(),
        ),
        BlocProvider<BookingCubit>(
          create: (context) => context.read<BookingCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Review Booking'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<LoyaltyPointsCubit, LoyaltyPointsState>(
              listener: (context, state) {
                if (state is LoyaltyPointsError) {
                  setState(() {
                    _errorMessage = state.message;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is LoyaltyPointsActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  if (_isRedeemLoyaltySelected) {
                    _makeReservation(context);
                  }
                }
              },
            ),
            BlocListener<BookingCubit, BookingState>(
              listener: (context, state) {
                if (state is BookingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is BookingSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Booking successful!')),
                  );
                  // context.go('/cards');
                  context.push('/payment', extra: {
                    'amount': widget.totalPrice,
                    'paymentFor': '${widget.room.name} Booking',
                    'userId': AppSession().userId,
                    'reservationId': state.reservationId,
                    'paymentMethod': _selectedPayment ?? 'CARD',
                  });
                }
              },
            ),
          ],
          child: BlocBuilder<LoyaltyPointsCubit, LoyaltyPointsState>(
            builder: (context, state) {
              int availablePoints = 0;
              if (state is LoyaltyPointsLoaded) {
                availablePoints = state.loyaltyPoints.totalPoints;
              } else if (state is LoyaltyPointsActionLoading) {
                availablePoints = state.currentLoyaltyPoints.totalPoints;
              } else if (state is LoyaltyPointsActionSuccess) {
                availablePoints = state.loyaltyPoints.totalPoints;
              } else if (state is LoyaltyPointsError) {
                // Optionally show error message
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                });
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _buildRoomSummary(widget.room),
                          const SizedBox(height: 24),
                          _buildBookingDetails(),
                          const SizedBox(height: 24),
                          _buildSeatsSelection(),
                          const SizedBox(height: 24),
                          _buildRequestButton(context),
                          const SizedBox(height: 16),
                          _buildPaymentMethod(availablePoints),
                          const SizedBox(height: 24),
                          _buildPaymentSummary(),
                          const SizedBox(height: 32),
                          _buildReserveButton(context, availablePoints),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRequestButton(BuildContext context) {
    return TextButton(
      onPressed: () async {

        final getStaffIdUseCase = sl<GetStaffIdUseCase>();
        final staffId = await getStaffIdUseCase(widget.workspaceId);
        if (staffId != null) {
          context.push(
            '/request',
            extra: {
              'workspaceId': widget.workspaceId,
              'staffId': staffId,
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No staff available for this workspace')),
          );
        }
      },
      child: const Text(
        'Need Help? Make a Request',
        style: TextStyle(
          color: Color(0xFF0A3FB3),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoomSummary(RoomEntity room) {
    final primaryImage = room.roomImages?.isNotEmpty == true
        ? room.roomImages!.first.imageUrl
        : 'assets/images/image1.jpg';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              primaryImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/image1.jpg',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${room.name ?? 'Meeting Room'} (${room.capacity ?? 2} people)',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (room.description != null)
                  Text(
                    room.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                if (room.type != null)
                  Text(
                    'Type: ${room.type!}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  'Price: EGP ${widget.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                if (room.roomStatus != null)
                  Text(
                    'Status: ${room.roomStatus!}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getStatusColor(room.roomStatus!),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'booked':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBookingDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'From: ${_formatDate(widget.selectedDate)} ${widget.checkInTime}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'To: ${_formatDate(widget.selectedDate)} ${widget.checkOutTime}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Color(0xFF0A3FB3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildSeatsSelection() {
    final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPrivate ? 'Private Room' : '${widget.numberOfSeats} Seats',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.room.pricePerHour != null)
          Text(
            isPrivate
                ? 'Price: EGP ${widget.room.pricePerHour!.toStringAsFixed(2)} (inclusive of 14% VAT)'
                : 'Price: EGP ${(widget.room.pricePerHour! * widget.numberOfSeats).toStringAsFixed(2)} (inclusive of 14% VAT)',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        const SizedBox(height: 8),
        if (!isPrivate)
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'Change Seats',
              style: TextStyle(
                color: Color(0xFF0A3FB3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }


// 3. Remove the separate loyalty points checkbox and update _buildPaymentOption
  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = _selectedPayment == value ? null : value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Radio(
              value: value,
              groupValue: _selectedPayment,
              onChanged: (newValue) {
                setState(() {
                  _selectedPayment = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
// 4. Update the payment summary to show points deduction
// Update the payment summary calculation
  Widget _buildPaymentSummary() {
    final subtotal = widget.totalPrice;
    final serviceFee = subtotal * 0.14;

    // Calculate points deduction (1 point = 0.1 EGP)
    double pointsValue = _pointsToRedeem * 0.1;

    // Calculate total after points deduction
    double totalBeforePoints = subtotal + serviceFee;
    double totalAfterPoints = totalBeforePoints - pointsValue;

    // Adjust points if they would make total negative
    double actualPointsDeduction = pointsValue;
    double remainingPoints = 0;

    if (totalAfterPoints < 0) {
      actualPointsDeduction = totalBeforePoints;
      remainingPoints = (pointsValue - actualPointsDeduction) / 0.1;
      totalAfterPoints = 0;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildPaymentRow('Subtotal', 'EGP ${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPaymentRow('Service fee ⓒ', 'EGP ${serviceFee.toStringAsFixed(2)}'),
          if (_pointsToRedeem > 0)
            Column(
              children: [
                const SizedBox(height: 8),
                _buildPaymentRow('Points redeemed (${_pointsToRedeem} pts)', '-EGP ${actualPointsDeduction.toStringAsFixed(2)}'),
                if (remainingPoints > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Note: ${remainingPoints.toStringAsFixed(0)} points were not used to avoid negative balance',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          const Divider(height: 24),
          _buildPaymentRow('Total', 'EGP ${totalAfterPoints.toStringAsFixed(2)}', isTotal: true),
          if (_pointsToRedeem > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '1 loyalty point = 0.1 EGP',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF0A3FB3) : null,
          ),
        ),
      ],
    );
  }

// Update the reserve button logic
  Widget _buildReserveButton(BuildContext context, int availablePoints) {
    // Recalculate the total with points to validate
    final subtotal = widget.totalPrice;
    final serviceFee = subtotal * 0.14;
    final pointsValue = _pointsToRedeem * 0.1;
    double totalBeforePoints = subtotal + serviceFee;
    double totalAfterPoints = totalBeforePoints - pointsValue;

    // Adjust if points would make total negative
    if (totalAfterPoints < 0) {
      totalAfterPoints = 0;
    }

    final isAllValid = _selectedPayment != null &&
        (_pointsToRedeem == 0 ||
            (_pointsToRedeem <= availablePoints && totalAfterPoints >= 0));

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isAllValid ? () {
          if (_pointsToRedeem > availablePoints) {
            setState(() {
              _errorMessage = 'Insufficient points for redemption';
            });
            return;
          }

          if (totalAfterPoints < 0) {
            setState(() {
              _errorMessage = 'Cannot redeem more points than the total amount';
            });
            return;
          }

          _makeReservation(context);
        } : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isAllValid
              ? const Color(0xFF0A3FB3)
              : Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Reserve',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

// Update the payment method section to show the conversion rate
  Widget _buildPaymentMethod(int availablePoints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              _buildPaymentOption(
                title: 'Credit Card',
                icon: Icons.credit_card,
                value: 'CARD',
              ),
              _buildPaymentOption(
                title: 'Cash',
                icon: Icons.money,
                value: 'CASH',
              ),
              const SizedBox(height: 12),
              const Text(
                'Loyalty Points (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '1 point = 0.1 EGP',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Available Points: $availablePoints (${(availablePoints * 0.1).toStringAsFixed(1)} EGP)',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              TextField(
                controller: _loyaltyPointsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter points to redeem (optional)',
                  errorText: _errorMessage,
                ),
                onChanged: (value) {
                  final points = int.tryParse(value) ?? 0;
                  setState(() {
                    _pointsToRedeem = points;
                    if (points > availablePoints) {
                      _errorMessage = 'Insufficient points';
                    } else {
                      // Calculate if points would make total negative
                      final subtotal = widget.totalPrice;
                      final serviceFee = subtotal * 0.14;
                      final totalBeforePoints = subtotal + serviceFee;
                      final pointsValue = points * 0.1;

                      if (totalBeforePoints - pointsValue < 0) {
                        _errorMessage = 'Maximum redeemable: ${(totalBeforePoints / 0.1).toStringAsFixed(0)} points';
                      } else {
                        _errorMessage = null;
                      }
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

// Update the reservation method to handle partial points redemption
  Future<void> _makeReservation(BuildContext context) async {
    final userId = AppSession().userId;
    final paymentMethod = _selectedPayment!.toUpperCase().replaceAll(' ', '_');
    final startTime = _formatDateTime(widget.selectedDate, widget.checkInTime);
    final endTime = _formatDateTime(widget.selectedDate, widget.checkOutTime);

    // Calculate actual points to redeem (may be less than requested if it would make total negative)
    final subtotal = widget.totalPrice;
    final serviceFee = subtotal * 0.14;
    final totalBeforePoints = subtotal + serviceFee;
    final maxPointsValue = totalBeforePoints;
    final actualPointsToRedeem = (_pointsToRedeem * 0.1 > maxPointsValue)
        ? (maxPointsValue / 0.1).toInt()
        : _pointsToRedeem;

    final bookingRequest = BookingRequest(
      paymentMethod: paymentMethod,
      amenitiesCount: widget.numberOfSeats,
      startTime: startTime,
      endTime: endTime,
      userId: userId,
      workspaceId: widget.workspaceId,
      roomId: widget.room.id ?? 'default_room',
      loyalityPoint: _pointsToRedeem
    );

    // If points are being redeemed, call the redeem API first
    if (actualPointsToRedeem > 0) {
      try {
        await context.read<LoyaltyPointsCubit>().redeemPoints(actualPointsToRedeem);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error redeeming points: $e')),
        );
        return;
      }
    }

    context.read<BookingCubit>().reserve(bookingRequest);
  }

  String _formatDateTime(DateTime date, String time) {
    try {
      final timeFormat = DateFormat('h:mm a');
      final parsedTime = timeFormat.parse(time.trim());

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      // 🧼 احذفي .000 عبر format واضح
      return DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);
    } catch (e) {
      print('❌ Error parsing time: $time - $e');
      return DateFormat("yyyy-MM-ddTHH:mm:ss").format(
          DateTime(date.year, date.month, date.day, 9, 0));
    }
  }
}