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
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'address': address,
    'isStaff': isStaff,
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    isStaff: json['isStaff'],
  );

}