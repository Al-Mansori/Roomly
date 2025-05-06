class RegistrationRequestEntity {
  final String? firstName;
  final String? lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;
  final bool isStaff;

  RegistrationRequestEntity({
    this.firstName,
    this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
    required this.isStaff,
  });
}