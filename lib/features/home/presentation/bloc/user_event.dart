part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class GetUserDataEvent extends UserEvent {}



class UpdateUserDataEvent extends UserEvent {
  final Map<String, dynamic> updatedData;

  UpdateUserDataEvent({required this.updatedData});
}

class NavItemSelectedEvent extends UserEvent {
  final int index;

  NavItemSelectedEvent({required this.index});
}

