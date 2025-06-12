import '../../domain/entities/user_entity.dart';
class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.firstName,
    super.lastName,
    required super.email,
    super.password,
    super.phone,
    super.address,
    super.isStaff,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isStaff: json['isStaff'] as bool?,
    );
  }
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
      address: address,
      isStaff: isStaff,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'isStaff': isStaff,
    };
  }
}