// presentation/cubit/room_availability_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/seats_availability_entity.dart';
import '../../domain/usecases/seats_availability_use_case.dart';

class SeatsAvailabilityCubit extends Cubit<SeatsAvailabilityState> {
  final CheckSeatsAvailabilityUseCase checkAvailability;

  SeatsAvailabilityCubit({required this.checkAvailability})
      : super(SeatsAvailabilityInitial());

  Future<void> loadAvailability({
    required String roomId,
    required DateTime date,
  }) async {
    // Add debug logging
    print('🪑 Loading seat availability for room: $roomId, date: ${date.toIso8601String()}');

    emit(SeatsAvailabilityLoading());

    try {
      print('🔄 Calling seat availability API...');

      final availability = await checkAvailability(
        roomId: roomId,
        date: date,
      );

      if (availability.isEmpty) {
        print('📭 No availability data found - room has never been booked');
        print('   All time slots within operating hours are available at full capacity');
      } else {
        print('✅ Seat availability loaded successfully:');
        for (var slot in availability) {
          print('   Hour ${slot.hour}: ${slot.availableSeats}/${slot.capacity} seats (${slot.status})');
        }
      }

      emit(SeatsAvailabilityLoaded(availability: availability));

    } catch (e) {
      print('❌ Error loading seat availability: $e');
      emit(SeatsAvailabilityError(message: e.toString()));
    }
  }
}

// presentation/states/SeatsAvailability_availability_state.dart
abstract class SeatsAvailabilityState {}

class SeatsAvailabilityInitial extends SeatsAvailabilityState {}

class SeatsAvailabilityLoading extends SeatsAvailabilityState {}

class SeatsAvailabilityLoaded extends SeatsAvailabilityState {
  final List<SeatsAvailability> availability;

  SeatsAvailabilityLoaded({required this.availability});
}

class SeatsAvailabilityError extends SeatsAvailabilityState {
  final String message;

  SeatsAvailabilityError({required this.message});
}

