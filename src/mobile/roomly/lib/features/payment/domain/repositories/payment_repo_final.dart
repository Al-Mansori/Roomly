import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class PaymentRepositoryFinal {
  Future<Either<Failure, Map<String, dynamic>>> processPayment({
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required double amount,
    required String paymentMethod,
  });
}