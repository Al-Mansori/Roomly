import 'package:equatable/equatable.dart';
import '../../domain/entities/card_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentCardsLoaded extends PaymentState {
  final List<CardEntity> cards;

  const PaymentCardsLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentCardAdded extends PaymentState {}

class PaymentCardAddError extends PaymentState {
  final String message;

  const PaymentCardAddError(this.message);

  @override
  List<Object> get props => [message];
}



