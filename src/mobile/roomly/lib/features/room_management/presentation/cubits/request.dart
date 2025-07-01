// features/request/presentation/cubit/request_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/room_management/data/data_sources/api_service.dart';

import '../../domain/entities/request_entity.dart';
import '../../domain/usecases/submit_request_usecase.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestSuccess extends RequestState {
}

class RequestError extends RequestState {
  final String message;
  RequestError(this.message);
}

class SendRequestCubit extends Cubit<RequestState> {
  final SubmitRequest submitRequestUseCase;

  SendRequestCubit({required this.submitRequestUseCase}) : super(RequestInitial());

  Future<void> submitRequest({
    required String type,
    required String details,
    required String userId,
    String? staffId,
  }) async {
    emit(RequestLoading());
    try {
      final request = await submitRequestUseCase.call(
        type: type,
        details: details,
        userId: userId,
        staffId: staffId,
      );
      emit(RequestSuccess());
    } catch (e) {
      emit(RequestError(e.toString()));
    }
  }
}
