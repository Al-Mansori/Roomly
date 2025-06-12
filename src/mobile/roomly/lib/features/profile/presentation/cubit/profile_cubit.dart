import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:roomly/core/error/failures.dart';
import 'package:roomly/features/auth/domain/entities/user_entity.dart';
import '../../domain/usecases/get_cached_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetCachedUser getCachedUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  ProfileCubit({
    required this.getCachedUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(ProfileInitial());

  Future<void> loadUser() async {
    emit(ProfileLoading());
    
    final result = await getCachedUser();
    
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> updateUserData(UserEntity user) async {
    emit(ProfileLoading());
    
    final result = await updateUser(user);
    
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (message) => emit(ProfileUpdateSuccess(message)),
    );
  }

  Future<void> deleteUserAccount(String userId) async {
    emit(ProfileLoading());
    
    final result = await deleteUser(userId);
    
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (message) => emit(ProfileDeleteSuccess(message)),
    );
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NetworkFailure:
        return 'Network error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}

