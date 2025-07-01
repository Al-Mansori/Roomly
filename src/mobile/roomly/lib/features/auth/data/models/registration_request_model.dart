import '../../domain/entities/registration_request_entity.dart';

class RegistrationRequestModel extends RegistrationRequestEntity {
  RegistrationRequestModel({
    super.firstName,
    super.lastName,
    required super.email,
    required super.password,
    required super.confirmPassword,
    super.phone,
    required super.isStaff,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
      'isStaff': isStaff,
    };
  }
}