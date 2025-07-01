import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/card_model.dart';
import '../../domain/usecases/add_card_usecase.dart';
import '../../domain/usecases/get_user_cards_usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final GetUserCardsUseCase getUserCardsUseCase;
  final AddCardUseCase addCardUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentCubit({
    required this.getUserCardsUseCase,
    required this.addCardUseCase,
    required this.processPaymentUseCase,
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

  Future<void> processPayment({
    required String cardId,
    required String cvv,
    required double amount,
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String paymentMethod,
  }) async {
    emit(PaymentProcessing());

    final result = await processPaymentUseCase(
      reservationId: reservationId,
      userId: userId,
      cardNumber: cardNumber,
      cvv: cvv,
      amount: amount,
      paymentMethod: paymentMethod,
    );

    print("🎯 Payment Result: $result");

    result.fold(
          (failure) {
        print("❌ Payment Failure: ${failure.message}");
        emit(PaymentError(failure.message));
      },
          (response) {
        print("✅ Payment Response: $response");

        if (response['Status'] != 'CONFIRMED') {
          print("⚠️ Payment Status Not Confirmed: ${response['Status']}");
          emit(PaymentError('Payment status: ${response['Status']}'));
        } else {
          emit(PaymentProcessed(
            amount: amount,
            transactionId: response['PaymentId'] ?? '',
            apiResponse: response,
          ));
        }
      },
    );
  }

  void resetState() {
    emit(PaymentInitial());
  }

}
