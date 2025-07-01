import 'package:google_sign_in/google_sign_in.dart';

class GoogleUserEntity {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  GoogleUserEntity(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName});
}
