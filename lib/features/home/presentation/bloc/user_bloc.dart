import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/domain/usecase/get_user_usecase.dart';
import 'package:qr_folio/features/home/domain/usecase/update_user_usecase.dart';
import 'package:qr_folio/features/home/domain/usecase/upload_photo_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUsecase getUserUsecase;
  final UpdateUserUsecase updateUserUsecase;
  final UploadPhotoUsecase uploadPhotoUsecase;
  UserDataEntity? _currentUser;

  UserBloc({
    required this.getUserUsecase,
    required this.updateUserUsecase,
    required this.uploadPhotoUsecase,
  }) : super(UserInitialState()) {
    on<GetUserDataEvent>(_onGetUserData);
    on<UpdateUserDataEvent>(_onUpdateUserData);
    on<UploadPhotoEvent>(_onUploadPhoto);
    on<NavItemSelectedEvent>((event, emit) {
      if (_currentUser != null) {
        emit(NavItemSelectedState(event.index, _currentUser!));
      }
    });
  }

  FutureOr<void> _onUploadPhoto(
    UploadPhotoEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UploadingPhotoState());

    final result = await uploadPhotoUsecase(event.filePath);

    result.fold(
      (failure) => emit(PhotoUploadErrorState(failure.message)),
      (_) => emit(PhotoUploadedState("Photo uploaded successfully")),
    );
  }

  FutureOr<void> _onGetUserData(
    GetUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    final result = await getUserUsecase();

    result.fold((failure) => emit(UserErrorState(failure.message)), (user) {
      _currentUser = user;
      emit(UserLoadedState(user));
      emit(NavItemSelectedState(0, user)); // Set default selected nav item to Home
    });
  }

  FutureOr<void> _onUpdateUserData(
    UpdateUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(ProcessingUpdateState());

    final result = await updateUserUsecase(event.updatedData);

    result.fold(
      (failure) => emit(UserErrorState(failure.message)),
      (_) => emit(UpdatedUserDataState("User data updated successfully")),
    );
  }
}
