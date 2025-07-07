import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roomly/features/room_management/presentation/cubits/open_hours_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../domain/entities/operating_entites.dart';
import '../../domain/entities/seats_availability_entity.dart';
import '../cubits/seats_availability_cubit.dart';

class SelectDataScreen extends StatefulWidget {
  final dynamic room;
  final double discountedPrice;
  final String workspaceId;

  const SelectDataScreen({
    super.key,
    required this.room,
    required this.discountedPrice,
    required this.workspaceId,
  });

  @override
  _SelectDataScreenState createState() => _SelectDataScreenState();
}

class _SelectDataScreenState extends State<SelectDataScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  late final SeatsAvailabilityCubit _availabilityCubit;
  late final OperatingHoursCubit _operatingHoursCubit;
  List<SeatsAvailability> _availability = [];
  int _maxSeats = 0;
  bool _isLoading = true;
  bool _isOperatingHoursLoading = true;
  OperatingHours? _operatingHours;

  String _checkInTime = '';
  String _checkOutTime = '';
  bool _noAvailabilityData = false;

  int _numberOfSeats = 2;
  bool _isButtonVisible = true;
  bool _isDailyBooking = false;
  final ScrollController _scrollController = ScrollController();

  bool _isTimeValid = true;
  String _timeValidationMessage = '';

  List<String> _checkInTimes = [];
  List<String> _checkOutTimes = [];

  @override
  void initState() {
    super.initState();
    _operatingHoursCubit = context.read<OperatingHoursCubit>();
    _availabilityCubit = context.read<SeatsAvailabilityCubit>();
    _scrollController.addListener(_handleScroll);

    _checkInTimes = List.generate(
      48,
          (index) => DateFormat('h:mm a').format(
        DateTime(2024, 1, 1, index ~/ 2, (index % 2) * 30),
      ),
    );
    _checkOutTimes = List.generate(
      48,
          (index) => DateFormat('h:mm a').format(
        DateTime(2024, 1, 1, index ~/ 2, (index % 2) * 30),
      ),
    );

    _loadInitialData();
  }

  void _loadInitialData() {
    print('🚀 Loading initial data for date: ${_selectedDate.toIso8601String()}');
    _loadOperatingHours();
    _loadInitialAvailability();
  }

  void _loadInitialAvailability() {
    setState(() => _isLoading = true);
    _availabilityCubit.loadAvailability(
      roomId: widget.room.id,
      date: _selectedDate,
    ).then((_) {
      setState(() => _isLoading = false);
      _validateTimes();
    });
  }

  void _loadOperatingHours() {
    setState(() => _isOperatingHoursLoading = true);
    _operatingHoursCubit.loadOperatingHours(
      workspaceId: widget.workspaceId,
      date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
    ).then((_) {
      setState(() => _isOperatingHoursLoading = false);
      _validateTimes();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _validateTimes() {
    final now = DateTime.now();
    final isToday = isSameDay(_selectedDate, now);

    setState(() {
      _isTimeValid = true;
      _timeValidationMessage = '';
    });

    if (_isDailyBooking) {
      final minSeats = _calculateMinAvailableSeats(
        _operatingHours?.startTime.hour ?? 9,
        _operatingHours?.endTime.hour ?? 23,
      );
      if (minSeats <= 0) {
        setState(() {
          _isTimeValid = false;
          _timeValidationMessage = 'No available seats for full day';
        });
      }
      return;
    }

    if (_checkInTime.isEmpty || _checkOutTime.isEmpty) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Please select check-in and check-out times';
      });
      return;
    }

    final checkIn = _parseTime(_checkInTime);
    final checkOut = _parseTime(_checkOutTime);

    if (isToday && !_isDailyBooking) {
      final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
      final selectedCheckIn = DateTime(now.year, now.month, now.day, checkIn.hour, checkIn.minute);

      if (selectedCheckIn.isBefore(currentTime.subtract(const Duration(minutes: 1)))) {
        setState(() {
          _isTimeValid = false;
          _timeValidationMessage = 'Cannot select past times for today';
        });
        return;
      }
    }

    if (checkOut.isBefore(checkIn)) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Check-out must be after check-in';
      });
    } else if (checkOut == checkIn) {
      setState(() {
        _isTimeValid = false;
        _timeValidationMessage = 'Check-out cannot be same as check-in';
      });
    } else {
      final checkInHour = checkIn.hour;
      final checkOutHour = checkOut.hour;
      bool allHoursAvailable = true;
      String unavailableHour = '';

      for (int hour = checkInHour; hour < checkOutHour; hour++) {
        if (!_isHourAvailable(hour)) {
          allHoursAvailable = false;
          unavailableHour = DateFormat('h:mm a').format(DateTime(2024, 1, 1, hour, 0));
          break;
        }
      }

    }
  }

  bool _isHourAvailable(int hour) {
    if (_noAvailabilityData) {
      if (_operatingHours != null) {
        final startHour = _operatingHours!.startTime.hour;
        final endHour = _operatingHours!.endTime.hour;
        return hour >= startHour && hour < endHour;
      }
      return true; // Default to available if no operating hours data
    }

    final slot = _availability.firstWhere(
          (slot) => slot.hour == hour,
      orElse: () => SeatsAvailability(
        roomId: widget.room.id,
        date: _selectedDate,
        hour: hour,
        availableSeats: widget.room.capacity ?? 30,
        capacity: widget.room.capacity ?? 30,
        status: 'AVAILABLE',
      ),
    );

    return slot.status == 'AVAILABLE' && slot.availableSeats > 0;
  }

  void _toggleDailyBooking(bool? value) {
    if (value != null) {
      setState(() {
        _isDailyBooking = value;

        if (_isDailyBooking) {
          if (_operatingHours != null) {
            _checkInTime = DateFormat('h:mm a').format(_operatingHours!.startTime.toLocal());
            _checkOutTime = DateFormat('h:mm a').format(_operatingHours!.endTime.toLocal());
          } else {
            _checkInTime = '9:00 AM';
            _checkOutTime = '6:00 PM';
          }

          _maxSeats = _noAvailabilityData ? (widget.room.capacity ?? 30) : _calculateMinAvailableSeats(
            _operatingHours?.startTime.hour ?? 9,
            _operatingHours?.endTime.hour ?? 23,
          );
          if (_numberOfSeats > _maxSeats) {
            _numberOfSeats = _maxSeats;
          }
        }

        _updateAvailableTimes();
        _validateTimes();
      });
    }
  }

  void _handleCheckInChange(String time) {
    setState(() {
      _checkInTime = time;
      _updateAvailableTimes();
      _validateTimes();
    });
  }

  void _handleCheckOutChange(String time) {
    setState(() {
      _checkOutTime = time;
      _updateAvailableTimes();
      _validateTimes();
    });
  }

  DateTime _parseTime(String time) {
    final cleanedTime = time.replaceAll(RegExp(r'\s+'), ' ').trim();

    try {
      return DateFormat('h:mm a').parse(cleanedTime);
    } catch (e) {
      print('Error parsing 12-hour time: $time, error: $e');
      try {
        return DateFormat('H:mm').parse(cleanedTime);
      } catch (e2) {
        print('Error parsing 24-hour time: $time, error: $e2');
        return DateTime.now();
      }
    }
  }

  void _updateAvailableTimes() {
    print('🔄 Updating available times...');
    print('   Operating hours: ${_operatingHours?.startTime} - ${_operatingHours?.endTime}');
    print('   No availability data: $_noAvailabilityData');
    print('   Availability slots: ${_availability.length}');

    if (_operatingHours == null) {
      print('⚠️ Operating hours not loaded yet, using default times');
      return;
    }

    final now = DateTime.now();
    final isToday = isSameDay(_selectedDate, now);

    final localStart = _operatingHours!.startTime.toLocal();
    final localEnd = _operatingHours!.endTime.toLocal();

    final allPossibleTimes = _generateTimeSlots(localStart, localEnd);
    print('   Generated ${allPossibleTimes.length} possible time slots');

    _checkInTimes = allPossibleTimes.where((time) {
      final parsedTime = _parseTime(time);
      final hour = parsedTime.hour;

      final slotDateTime = DateTime(
        now.year, now.month, now.day,
        parsedTime.hour, parsedTime.minute,
      );
      final slotEnd = slotDateTime.add(const Duration(minutes: 30));

      final isSlotPassed = isToday && slotEnd.isBefore(now.add(const Duration(seconds: 1)));
      if (isSlotPassed) return false;

      if (_noAvailabilityData) {
        return true; // All times within operating hours are available
      }

      return _isHourAvailable(hour);
    }).toList();

    print('   Available check-in times: ${_checkInTimes.length}');

    if (_checkInTime.isNotEmpty && _checkInTimes.contains(_checkInTime)) {
      final checkInHour = _parseTime(_checkInTime).hour;

      _checkOutTimes = allPossibleTimes.where((time) {
        final checkOutHour = _parseTime(time).hour;

        if (checkOutHour <= checkInHour) return false;

        if (_noAvailabilityData) {
          return true; // All times after check-in within operating hours are available
        }

        for (int hour = checkInHour; hour < checkOutHour; hour++) {
          if (!_isHourAvailable(hour)) {
            return false;
          }
        }
        return true;
      }).toList();

      print('   Available check-out times: ${_checkOutTimes.length}');

      if (_checkOutTime.isNotEmpty) {
        final checkOutHour = _parseTime(_checkOutTime).hour;
        _maxSeats = _noAvailabilityData ? (widget.room.capacity ?? 30) : _calculateMinAvailableSeats(checkInHour, checkOutHour);

        if (_numberOfSeats > _maxSeats) {
          setState(() => _numberOfSeats = _maxSeats > 0 ? _maxSeats : 1);
        }
      }
    } else {
      _checkOutTimes = [];
    }
  }

  List<String> _generateTimeSlots(DateTime start, DateTime end) {
    final slots = <String>[];
    final format = DateFormat("h:mm a");

    DateTime current = DateTime(
      start.year,
      start.month,
      start.day,
      start.hour,
      0,
    );

    while (current.isBefore(end)) {
      slots.add(format.format(current));
      current = current.add(const Duration(hours: 1));
    }

    return slots;
  }

  int _calculateMinAvailableSeats(int startHour, int endHour) {
    if (_noAvailabilityData) {
      return widget.room.capacity ?? 30; // Full capacity if no availability data
    }

    int minSeats = widget.room.capacity ?? 30;

    if (_isDailyBooking) {
      startHour = _operatingHours?.startTime.hour ?? 9;
      endHour = _operatingHours?.endTime.hour ?? 23;
    }

    for (int hour = startHour; hour < endHour; hour++) {
      if (_isHourAvailable(hour)) {
        final slot = _availability.firstWhere(
              (slot) => slot.hour == hour,
          orElse: () => SeatsAvailability(
            roomId: widget.room.id,
            date: _selectedDate,
            hour: hour,
            availableSeats: widget.room.capacity ?? 30,
            capacity: widget.room.capacity ?? 30,
            status: 'AVAILABLE',
          ),
        );

        if (slot.availableSeats < minSeats) {
          minSeats = slot.availableSeats;
        }
      } else {
        return 0;
      }
    }

    return minSeats;
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isButtonVisible) {
        setState(() => _isButtonVisible = false);
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isButtonVisible) {
        setState(() => _isButtonVisible = true);
      }
    }
  }

  Widget _buildTimeSelector({
    required List<String> times,
    required String selectedTime,
    required ValueChanged<String>? onSelect,
    required bool isEnabled,
  }) {
    final now = DateTime.now();
    final isToday = isSameDay(_selectedDate, now);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          final parsedTime = _parseTime(time);
          final hour = parsedTime.hour;

          final isTimePassed = isToday && parsedTime.isBefore(now);
          final isAvailable = _noAvailabilityData || _isDailyBooking || _isHourAvailable(hour);
          final isDisabled = !isEnabled || (!_isDailyBooking && !isAvailable);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              style: time == selectedTime
                  ? ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3FB3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              )
                  : ElevatedButton.styleFrom(
                backgroundColor: isDisabled ? Colors.grey[200] : Colors.white,
                foregroundColor: isDisabled ? Colors.grey : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isDisabled ? Colors.grey[300]! : Colors.grey,
                  ),
                ),
              ),
              onPressed: isDisabled ? null : () => onSelect?.call(time),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time),
                  if (!isAvailable && !isTimePassed && !_isDailyBooking)
                    const Icon(Icons.block, size: 12, color: Colors.red),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SeatsAvailabilityCubit, SeatsAvailabilityState>(
          listener: (context, state) {
            print('🪑 Seat availability state changed: ${state.runtimeType}');
            if (state is SeatsAvailabilityLoaded) {
              setState(() {
                _availability = state.availability;
                _noAvailabilityData = state.availability.isEmpty;
                _updateAvailableTimes();
                _maxSeats = _noAvailabilityData ? (widget.room.capacity ?? 30) : _calculateMinAvailableSeats(
                  _operatingHours?.startTime.hour ?? 9,
                  _operatingHours?.endTime.hour ?? 23,
                );
              });
            } else if (state is SeatsAvailabilityError) {
              print('❌ Seat availability error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading availability: ${state.message}')),
              );
            }
          },
        ),
        BlocListener<OperatingHoursCubit, OperatingHoursState>(
          listener: (context, state) {
            print('🕐 Operating hours state changed: ${state.runtimeType}');
            if (state is OperatingHoursLoaded) {
              setState(() {
                _operatingHours = state.operatingHours;
                _updateAvailableTimes();
              });
            } else if (state is OperatingHoursError) {
              print('❌ Operating hours error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading operating hours: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(FontAwesomeIcons.arrowLeft, size: 16, color: Colors.black),
          ),
          title: const Text('Select Date and Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: Stack(
          children: [
            if (_isLoading || _isOperatingHoursLoading)
              const Center(child: CircularProgressIndicator()),
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_operatingHours != null)
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   margin: const EdgeInsets.only(bottom: 16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.blue[50],
                    //     borderRadius: BorderRadius.circular(8),
                    //     border: Border.all(color: Colors.blue[200]!),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text('Debug Info:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    //       Text('Operating Hours: ${DateFormat('h:mm a').format(_operatingHours!.startTime.toLocal())} - ${DateFormat('h:mm a').format(_operatingHours!.endTime.toLocal())}'),
                    //       Text('No Availability Data: $_noAvailabilityData'),
                    //       Text('Available Slots: ${_availability.length}'),
                    //       Text('Check-in Options: ${_checkInTimes.length}'),
                    //       Text('Check-out Options: ${_checkOutTimes.length}'),
                    //     ],
                    //   ),
                    // ),

                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isDailyBooking,
                        onChanged: _toggleDailyBooking,
                        activeColor: const Color(0xFF0A3FB3),
                      ),
                      const Text('Daily Booking'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _isDailyBooking,
                        onChanged: _toggleDailyBooking,
                        activeColor: const Color(0xFF0A3FB3),
                      ),
                      const Text('Custom Time'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        DateFormat("d MMMM y").format(_selectedDate),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMMM y').format(_focusedDay),
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 4)],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay;
                        });

                        print('📅 Date selected: ${selectedDay.toIso8601String()}');
                        _loadInitialData();
                      },
                      enabledDayPredicate: (day) {
                        return !day.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                      },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                        weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Check-in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTimeSelector(
                    times: _checkInTimes,
                    selectedTime: _checkInTime,
                    onSelect: _isDailyBooking ? null : _handleCheckInChange,
                    isEnabled: !_isDailyBooking,
                  ),
                  const SizedBox(height: 8),
                  if (!_isTimeValid && _timeValidationMessage.contains('check-in'))
                    Text(
                      _timeValidationMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  const SizedBox(height: 24),
                  const Text('Check-out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTimeSelector(
                    times: _checkOutTimes,
                    selectedTime: _checkOutTime,
                    onSelect: _isDailyBooking ? null : _handleCheckOutChange,
                    isEnabled: !_isDailyBooking,
                  ),
                  const SizedBox(height: 8),
                  if (!_isTimeValid && !_timeValidationMessage.contains('check-in'))
                    Text(
                      _timeValidationMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                  ? -100
                  : (_isButtonVisible ? 20 : -100),
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isButtonVisible && MediaQuery.of(context).viewInsets.bottom == 0 ? 1.0 : 0.0,
                child: _buildReviewButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getTotalPrice() {
    try {
      final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';
      final checkIn = _parseTime(_checkInTime);
      final checkOut = _parseTime(_checkOutTime);

      if (checkOut.isBefore(checkIn)) {
        return 0.0;
      }

      final hours = checkOut.difference(checkIn).inHours.toDouble();

      if (isPrivate) {
        return widget.discountedPrice * hours;
      } else {
        return widget.discountedPrice * hours * _numberOfSeats;
      }
    } catch (e) {
      print('Error calculating total price: $e');
      return 0.0;
    }
  }

  Widget _buildReviewButton() {
    final isPrivate = widget.room.type?.toUpperCase() == 'PRIVATE';
    final totalPrice = getTotalPrice();
    final isPriceValid = totalPrice > 0;
    final now = DateTime.now();
    final isDateValid = !_selectedDate.isBefore(DateTime(now.year, now.month, now.day));

    final checkInHour = _checkInTime.isNotEmpty ? _parseTime(_checkInTime).hour : -1;
    final checkOutHour = _checkOutTime.isNotEmpty ? _parseTime(_checkOutTime).hour : -1;
    final minAvailableSeats = _calculateMinAvailableSeats(checkInHour, checkOutHour);

    final isSeatsValid = isPrivate ? true : (_numberOfSeats >= 1 && _numberOfSeats <= minAvailableSeats);
    final isAllDataValid = _isTimeValid && isPriceValid && isSeatsValid && isDateValid;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isTimeValid || !isPriceValid || !isSeatsValid || !isDateValid)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                !_isTimeValid
                    ? _timeValidationMessage
                    : !isPriceValid
                    ? 'Invalid booking duration'
                    : !isSeatsValid
                    ? (_numberOfSeats < 1
                    ? 'Number of seats must be at least 1'
                    : 'Maximum available seats: $minAvailableSeats')
                    : 'Cannot select past dates',
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 12,
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event_seat, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      isPrivate ? "Private Room" : "Number of Seats:",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (!isPrivate) const SizedBox(width: 15),
                    if (!isPrivate) ...[
                      _buildControlButton(
                        Icons.remove,
                            () {
                          if (_numberOfSeats > 1) {
                            setState(() => _numberOfSeats--);
                          }
                        },
                        enabled: _numberOfSeats > 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '$_numberOfSeats',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _buildControlButton(
                        Icons.add,
                            () {
                          if (_numberOfSeats < _maxSeats) {
                            setState(() => _numberOfSeats++);
                          }
                        },
                        enabled: _numberOfSeats < _maxSeats,
                      ),
                      if (_maxSeats > 0)
                        Text(
                          '/ $_maxSeats',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                    ] else ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 56,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total ${totalPrice.toStringAsFixed(1)} EGP',
                        style: TextStyle(
                          color: isAllDataValid ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isPrivate)
                        Text(
                          '${widget.discountedPrice.toStringAsFixed(1)} EGP/hour × $_numberOfSeats seats',
                          style: TextStyle(
                            color: isAllDataValid ? Colors.white70 : Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (isPrivate)
                        Text(
                          '${widget.discountedPrice.toStringAsFixed(1)} EGP/hour',
                          style: TextStyle(
                            color: isAllDataValid ? Colors.white70 : Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isAllDataValid
                      ? () {
                    context.push(
                      '/review-booking',
                      extra: {
                        'room': widget.room,
                        'selectedDate': _selectedDate,
                        'checkInTime': _checkInTime,
                        'checkOutTime': _checkOutTime,
                        'numberOfSeats': isPrivate ? 1 : _numberOfSeats,
                        'isDailyBooking': _isDailyBooking,
                        'discountedPrice': widget.discountedPrice,
                        'totalPrice': totalPrice,
                        'workspaceId': widget.workspaceId,
                        'availableSeats': _maxSeats,
                      },
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAllDataValid ? const Color(0xFF0A3FB3) : Colors.grey[700],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Review Booking',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {bool enabled = true}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(
          color: enabled ? Colors.white : Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14, color: enabled ? Colors.white : Colors.grey),
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 14,
      ),
    );
  }
}