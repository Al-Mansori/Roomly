import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/failures.dart';
import '../../data/models/card_model.dart';
import '../repositories/payment_repository.dart';

class AddCardUseCase {
  final PaymentRepository repository;

  AddCardUseCase(this.repository);

  Future<Either<Failure, void>> call(AddCardRequest request) async {
    return await repository.addCard(request);
  }
}

