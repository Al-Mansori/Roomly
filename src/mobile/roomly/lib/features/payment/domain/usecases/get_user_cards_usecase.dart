import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import '../entities/card_entity.dart';
import '../repositories/payment_repository.dart';

class GetUserCardsUseCase {
  final PaymentRepository repository;

  GetUserCardsUseCase(this.repository);

  Future<Either<Failure, List<CardEntity>>> call(String userId) async {
    return await repository.getUserCards(userId);
  }
}

