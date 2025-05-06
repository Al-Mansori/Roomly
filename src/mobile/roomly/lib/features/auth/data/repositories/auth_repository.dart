import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> login(LoginRequestEntity loginRequest) async {
    final result = await remoteDataSource.login(loginRequest);
    return {
      'user': UserModel.fromJson(result['user']).toEntity(),
      'token': result['token'],
    };
  }


  @override
  Future<Map<String, dynamic>> registerCustomer(RegistrationRequestEntity registrationRequest) async {
    return await remoteDataSource.registerCustomer(registrationRequest);
  }

  @override
  Future<Map<String, dynamic>> registerStaff(RegistrationRequestEntity registrationRequest) async {
    return await remoteDataSource.registerStaff(registrationRequest);
  }

  @override
  Future<Map<String, dynamic>> verifyUser(int otp) async {
    return await remoteDataSource.verifyUser(otp);
  }

  @override
  Future<Map<String, dynamic>> completeProfile(Map<String, dynamic> profileData) async {
    return await remoteDataSource.completeProfile(profileData);
  }
}