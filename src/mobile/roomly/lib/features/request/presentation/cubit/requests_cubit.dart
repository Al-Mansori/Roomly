import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomly/features/request/domain/usecases/get_requests_usecase.dart';
import 'package:roomly/features/request/presentation/cubit/requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final GetRequestsUseCase getRequestsUseCase;

  RequestsCubit({required this.getRequestsUseCase}) : super(RequestsInitial());

  Future<void> fetchRequests(String userId) async {
    emit(RequestsLoading());
    final failureOrRequests = await getRequestsUseCase(Params(userId: userId));
    failureOrRequests.fold(
      (failure) => emit(RequestsError(message: failure.message)),
      (requests) => emit(RequestsLoaded(requests: requests)),
    );
  }
}


