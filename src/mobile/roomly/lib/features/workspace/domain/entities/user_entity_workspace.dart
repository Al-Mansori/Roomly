import 'package:equatable/equatable.dart';

class UserEntity2 extends Equatable {
  final String name;

  const UserEntity2({required this.name});

  @override
  List<Object> get props => [name];
}


