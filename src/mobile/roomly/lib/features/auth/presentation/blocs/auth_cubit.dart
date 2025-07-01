import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roomly/features/auth/domain/usecases/continue_with_google.dart';
import '../../../GlobalWidgets/app_session.dart';
import '../../data/data_sources/secure_storage.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/google_user_entity.dart';
import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/registration_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/ResetPasswordUseCase.dart';
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
  final SendForgotPasswordOtpUseCase sendForgotPasswordOtpUseCase;
  final VerifyResetOtpUseCase verifyResetOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final ContinueWithGoogleUseCase continueWithGoogleUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerCustomerUseCase,
    required this.registerStaffUseCase,
    required this.verifyUserUseCase,
    required this.completeProfileUseCase,
    required this.resetPasswordUseCase,
    required this.sendForgotPasswordOtpUseCase,
    required this.verifyResetOtpUseCase,
    required this.continueWithGoogleUseCase,
  }) : super(AuthInitial());

  Future<void> logout() async {
    await SecureStorage.clearAll();
    emit(AuthInitial());
  }

  Future<void> login(String email, String password, bool isStaff) async {
    emit(AuthLoading());
    try {
      final response = await loginUseCase(LoginRequestEntity(
        email: email.trim(),
        password: password,
        isStaff: isStaff,
      ));

      if (response['user'] != null && response['token'] != null) {
        // Convert the user map to UserEntity
        final userMap = response['user'] as Map<String, dynamic>;
        final userEntity = UserEntity(
          id: userMap['id'],
          email: userMap['email'],
          firstName: userMap['firstName'],
          lastName: userMap['lastName'],
          phone: userMap['phone'],
          address: userMap['address'],
          isStaff: userMap['isStaff'] ?? isStaff, // Use provided isStaff if not in response
        );

        // Save token and user data
        await SecureStorage.saveToken(response['token']);
        await SecureStorage.saveIdString(userEntity.id!);
        await AppSession().setToken(response['token']);

        // Save complete user data in AppSession
        AppSession().setUser(userEntity);

        // Also save in SecureStorage if needed for persistence
        final userModel = UserModel.fromEntity(userEntity);
        await SecureStorage.saveUserData(userModel);

        // Verify the saved data
        final userId = await SecureStorage.getId();
        print('User ID from SecureStorage: $userId');
        print('User in AppSession: ${AppSession().currentUser?.toJson()}');

        emit(AuthLoggedIn(userEntity, response['token']));
      } else {
        emit(AuthError('Login failed - invalid response'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> continueWithGoogle() async {
    emit(AuthLoading());
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(AuthError('Google Sign-In aborted'));
        return;
      }

      final googleUserEntity = GoogleUserEntity(
        id: googleUser.id,
        email: googleUser.email,
        firstName: googleUser.displayName?.split(' ').first ?? '',
        lastName: googleUser.displayName?.split(' ').last ?? '',
      );

      final response = await continueWithGoogleUseCase(googleUserEntity);

      if (response['user'] != null && response['token'] != null) {
        final userMap = response['user'] as Map<String, dynamic>;
        final userEntity = UserEntity(
          id: userMap['id'],
          email: userMap['email'],
          firstName: userMap['firstName'],
          lastName: userMap['lastName'],
          phone: userMap['phone'],
          address: userMap['address'],
        );

        await SecureStorage.saveToken(response['token']);
        emit(AuthLoggedIn(userEntity, response['token']));
      } else {
        emit(AuthError('Google Sign-In failed - invalid response'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
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

  Future<void> sendForgotPasswordOtp(String email) async {
    emit(AuthLoading());
    try {
      final response = await sendForgotPasswordOtpUseCase(email);
      if (response['status'] == true) {
        emit(ForgotPasswordOtpSent(email: email));
      } else {
        emit(AuthError(response['message'] ?? 'Failed to send OTP'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyResetOtp(String email, int otp) async {
    emit(AuthLoading());
    try {
      final response = await verifyResetOtpUseCase(email, otp);
      if (response['status'] == true) {
        emit(ResetOtpVerified(email: email));
      } else {
        emit(AuthError(response['message'] ?? 'OTP verification failed'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    emit(AuthLoading());
    try {
      final response = await resetPasswordUseCase(email, newPassword);
      if (response['status'] == true) {
        emit(PasswordResetSuccess(response['message']));
      } else {
        emit(AuthError(response['error'] ?? 'Password reset failed'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
