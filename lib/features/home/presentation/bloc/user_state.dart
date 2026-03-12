part of 'user_bloc.dart';

@immutable
sealed class UserState {}

//User Data States
final class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final UserDataEntity user;

  UserLoadedState(this.user);
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState(this.message);
}

//Update User States
class ProcessingUpdateState extends UserState {}

class UpdatedUserDataState extends UserState {
  final String message;

  UpdatedUserDataState(this.message);
}

//Navigation State
class NavItemSelectedState extends UserState {
  final int index;
  final UserDataEntity user;

  NavItemSelectedState(this.index, this.user);
}
