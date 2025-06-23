import '../../domain/entities/google_user_entity.dart';

class GoogleUserModel extends GoogleUserEntity {
  GoogleUserModel(
      {required super.id,
      required super.email,
      required super.firstName,
      required super.lastName});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  factory GoogleUserModel.fromJson(Map<String, dynamic> json) {
    return GoogleUserModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  GoogleUserEntity toEntity() {
    return GoogleUserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }
}
