import 'package:equatable/equatable.dart';
import 'package:roomly/features/request/domain/entities/request.dart';

abstract class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<Request> requests;

  const RequestsLoaded({required this.requests});

  @override
  List<Object> get props => [requests];
}

class RequestsError extends RequestsState {
  final String message;

  const RequestsError({required this.message});

  @override
  List<Object> get props => [message];
}


