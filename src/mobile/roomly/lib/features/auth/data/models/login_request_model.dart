import '../../domain/entities/login_request_entity.dart';

class LoginRequestModel extends LoginRequestEntity {
  LoginRequestModel({
    required super.email,
    required super.password,
    required super.isStaff,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'isStaff': isStaff,
    };
  }
}