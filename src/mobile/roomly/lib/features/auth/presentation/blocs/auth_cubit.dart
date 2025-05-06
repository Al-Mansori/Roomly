import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/complete_profile_case.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_staff_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/verify_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterCustomerUseCase registerCustomerUseCase;
  final RegisterStaffUseCase registerStaffUseCase;
  final VerifyUserUseCase verifyUserUseCase;
  final CompleteProfileUseCase completeProfileUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerCustomerUseCase,
    required this.registerStaffUseCase,
    required this.verifyUserUseCase,
    required this.completeProfileUseCase,
  }) : super(AuthInitial());


  Future<void> login(String email, String password, bool isStaff) async {
    emit(AuthLoading());
    try {
      final response = await loginUseCase(LoginRequestEntity(
        email: email,
        password: password,
        isStaff: isStaff,
      ));

      if (response['user'] == null || response['token'] == null) {
        emit(AuthError(response['error'] ?? 'Wrong credentials'));
        return;
      }

      await SecureStorage.saveToken(response['token']);

      emit(AuthLoggedIn(response['user'], response['token']));
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    bool isStaff = false,
  }) async {
    emit(AuthLoading());
    try {
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      final response = isStaff
          ? await registerStaffUseCase(RegistrationRequestEntity(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        isStaff: true,
      ))
          : await registerCustomerUseCase(RegistrationRequestEntity(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        isStaff: false,
      ));

      if (response['registrationStatus'] == true) {
        emit(AuthRegistrationSuccess(
          email: email,
          userId: response['userId'] ?? '',
          isStaff: isStaff,
        ));
      } else {
        throw Exception(response['error'] ?? 'Registration failed');
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp(int otp) async {
    emit(AuthLoading());
    try {
      final response = await verifyUserUseCase(otp);
      if (response['registrationStatus'] == true) {
        emit(AuthVerificationSuccess());
      } else {
        throw Exception(response['error'] ?? 'Verification failed');
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> completeProfile(Map<String, dynamic> profileData) async {
    emit(AuthLoading());
    try {
      final response = await completeProfileUseCase(profileData);
      emit(AuthProfileCompleted(response));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
