part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final UserEntity user;
  final String token;

  const AuthLoggedIn(this.user, this.token);

  @override
  List<Object> get props => [user, token];
}

class AuthProfileCompleted extends AuthState {
  final Map<String, dynamic> response;
  const AuthProfileCompleted(this.response);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthRegistrationSuccess extends AuthState {
  final String email;
  final String userId;
  final bool isStaff;

  const AuthRegistrationSuccess({
    required this.email,
    required this.userId,
    required this.isStaff,
  });
}
class ForgotPasswordOtpSent extends AuthState {
  final String email;
  const ForgotPasswordOtpSent({required this.email});
}

class PasswordResetLoading extends AuthState {}
class PasswordForgetLoading extends AuthState {}

class ResetOtpVerified extends AuthState {
  final String email;
  const ResetOtpVerified({required this.email});
}

class PasswordResetSuccess extends AuthState {
  final String message;
  const PasswordResetSuccess(this.message);
}
class AuthVerificationSuccess extends AuthState {}
