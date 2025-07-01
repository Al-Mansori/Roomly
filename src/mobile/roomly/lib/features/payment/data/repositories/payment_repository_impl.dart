import 'package:dartz/dartz.dart';
import 'package:roomly/core/error/exceptions.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/core/network/network_info.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_source/payment_remote_data_source.dart';
import '../models/card_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
Future<Either<Failure, List<CardEntity>>> getUserCards(String userId) async {
  if (await networkInfo.isConnected) {
    try {
      final cards = await remoteDataSource.getUserCards(userId);
      if (cards.isEmpty) {
        return const Left(NoCardsFailure(message: 'No cards found'));
      }
      return Right(cards);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  } else {
    return const Left(NetworkFailure(message: 'No internet connection'));
  }
}

  @override
  Future<Either<Failure, void>> addCard(AddCardRequest request) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addCard(request);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.toString(),));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

