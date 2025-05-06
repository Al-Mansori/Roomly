class UserEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? password;
  final String? phone;
  final String? address;
  final bool? isStaff;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.password,
    this.phone,
    this.address,
    this.isStaff,
  });
}