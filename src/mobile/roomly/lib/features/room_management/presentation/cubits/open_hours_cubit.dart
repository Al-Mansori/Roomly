// presentation/cubits/operating_hours_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/operating_entites.dart';
import '../../domain/repositories/open_hours_repo.dart';

abstract class OperatingHoursState extends Equatable {
  const OperatingHoursState();

  @override
  List<Object> get props => [];
}

class OperatingHoursInitial extends OperatingHoursState {}

class OperatingHoursLoading extends OperatingHoursState {}

class OperatingHoursLoaded extends OperatingHoursState {
  final OperatingHours operatingHours;

  const OperatingHoursLoaded(this.operatingHours);

  @override
  List<Object> get props => [operatingHours];
}

class OperatingHoursError extends OperatingHoursState {
  final String message;

  const OperatingHoursError(this.message);

  @override
  List<Object> get props => [message];
}

class OperatingHoursCubit extends Cubit<OperatingHoursState> {
  final OperatingHoursRepository repository;

  OperatingHoursCubit(this.repository) : super(OperatingHoursInitial());

  Future<void> loadOperatingHours({
    required String workspaceId,
    required DateTime date,
  }) async {
    // Add debug logging
    print('🕐 Loading operating hours for workspace: $workspaceId, date: ${date.toIso8601String()}');

    emit(OperatingHoursLoading());

    try {
      print('🔄 Calling operating hours API...');

      final operatingHours = await repository.getOperatingHours(
        workspaceId: workspaceId,
        date: date,
      );

      print('✅ Operating hours loaded successfully:');
      print('   Start: ${operatingHours.startTime}');
      print('   End: ${operatingHours.endTime}');

      emit(OperatingHoursLoaded(operatingHours));

    } catch (e) {
      print('❌ Error loading operating hours: $e');
      emit(OperatingHoursError(e.toString()));
    }
  }
}

