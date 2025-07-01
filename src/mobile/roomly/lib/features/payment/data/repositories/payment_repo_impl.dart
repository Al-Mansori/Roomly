import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/payment_repo_final.dart';
import '../data_source/payment_remote_data_source.dart';

class PaymentRepositoryFinalImpl implements PaymentRepositoryFinal {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryFinalImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> processPayment({
    required String reservationId,
    required String userId,
    required String cardNumber,
    required String cvv,
    required String paymentMethod,
    required double amount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.processPayment(
          reservationId: reservationId,
          userId: userId,
          cardNumber: cardNumber,
          cvv: cvv,
          paymentMethod: paymentMethod,
          amount: amount,
        );

        print("✅ Repo Received Response: $response");

        if (response['Status'] == 'CANCELLED') {
          return Left(PaymentFailure(message: 'Payment was cancelled'));
        }

        return Right(response); // ✅ لا تستخدم as Map<String, dynamic>
      } on ServerException catch (e) {
        print("❌ ServerException caught in repo: $e");
        return Left(ServerFailure(message: 'Server error'));
      } catch (e, stackTrace) {
        print("❌ Unknown exception caught in repo: $e");
        print("📍 StackTrace: $stackTrace");
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}

class PaymentFailure extends Failure {
  PaymentFailure({required String message}) : super(message: message);
}