import 'package:roomly/features/workspace/domain/entities/user_entity_workspace.dart';

class UserModel2 extends UserEntity2 {
  const UserModel2({
    required String name,
  }) : super(
          name: name,
        );

  factory UserModel2.fromJson(Map<String, dynamic> json) {
    return UserModel2(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}


