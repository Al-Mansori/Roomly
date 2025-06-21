import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/card_model.dart';
import '../../domain/usecases/add_card_usecase.dart';
import '../../domain/usecases/get_user_cards_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final GetUserCardsUseCase getUserCardsUseCase;
  final AddCardUseCase addCardUseCase;

  PaymentCubit({
    required this.getUserCardsUseCase,
    required this.addCardUseCase,
  }) : super(PaymentInitial());

  Future<void> getUserCards(String userId) async {
    emit(PaymentLoading());
    
    final result = await getUserCardsUseCase(userId);
    
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (cards) => emit(PaymentCardsLoaded(cards)),
    );
  }

  Future<void> addCard({
    required String userId,
    required String cardNumber,
    required String cvv,
    required String endDate,
  }) async {
    emit(PaymentLoading());
    
    final request = AddCardRequest(
      userId: userId,
      cardNumber: cardNumber,
      cvv: cvv,
      endDate: endDate,
    );
    
    final result = await addCardUseCase(request);
    
    result.fold(
      (failure) => emit(PaymentCardAddError(failure.message)),
      (_) => emit(PaymentCardAdded()),
    );
  }

  void resetState() {
    emit(PaymentInitial());
  }
}

