import 'package:dartz/dartz.dart';
import 'package:roomly/features/payment/domain/repositories/payment_repo_final.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';


abstract class ProcessPaymentUseCase {
  Future<Either<Failure, Map<String, dynamic>>> call({
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required String paymentMethod,
    required double amount,
  });
}

class ProcessPaymentUseCaseImpl implements ProcessPaymentUseCase {
  final PaymentRepositoryFinal repository;

  ProcessPaymentUseCaseImpl(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call({
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required double amount,
    required String paymentMethod,
  }) async {
    return await repository.processPayment(
      reservationId: reservationId,
      userId: userId,
      cardNumber: cardNumber,
      cvv: cvv,
      amount: amount,
      paymentMethod: paymentMethod,
    );
  }
}