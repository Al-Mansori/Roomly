class LoginRequestEntity {
  final String email;
  final String password;
  final bool isStaff;

  LoginRequestEntity({
    required this.email,
    required this.password,
    required this.isStaff,
  });
}