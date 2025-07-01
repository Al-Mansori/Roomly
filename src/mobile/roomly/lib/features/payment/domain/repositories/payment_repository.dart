import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import '../../data/models/card_model.dart';
import '../entities/card_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<CardEntity>>> getUserCards(String userId);
  Future<Either<Failure, void>> addCard(AddCardRequest request);
}

