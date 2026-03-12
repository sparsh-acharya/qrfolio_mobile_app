import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';
import 'package:qr_folio/features/media/domain/usecase/add_image_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/add_video_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/add_document_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/delete_media_usecase.dart';
import 'package:qr_folio/features/media/domain/usecase/get_media_usecase.dart';

part 'media_event.dart';
part 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetMediaUsecase getMediaUsecase;
  final AddImageUsecase addImageUsecase;
  final AddVideoUsecase addVideoUsecase;
  final AddDocumentUsecase addDocumentUsecase;
  final DeleteMediaUsecase deleteMediaUsecase;
  MediaBloc({
    required this.getMediaUsecase,
    required this.addImageUsecase,
    required this.addVideoUsecase,
    required this.addDocumentUsecase,
    required this.deleteMediaUsecase,
  }) : super(MediaInitial()) {
    on<FetchMediaEvent>(_onFetchMedia);
    on<AddImageEvent>(_onAddImage);
    on<AddVideoEvent>(_onAddVideo);
    on<AddDocumentEvent>(_onAddDocument);
    on<DeleteMediaEvent>(_onDeleteMedia);
  }

  FutureOr<void> _onFetchMedia(
    FetchMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(LoadingMediaState());
    final result = await getMediaUsecase();
    result.fold((failure) {
      print("Error fetching media: ${failure.message}");
      emit(ErrorMediaState(failure.message));
    }, (mediaList) => emit(LoadedMediaState(mediaList)));
  }

  FutureOr<void> _onAddImage(
    AddImageEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(AddingImageState());
    final result = await addImageUsecase(
      title: event.title,
      description: event.description,
      imagePath: event.imagePath,
    );
    result.fold(
      (failure) {
        emit(ErrorAddingImageState(failure.message));
      },
      (_) {
        emit(AddedImageState());

        add(FetchMediaEvent());
      },
    );
  }

  FutureOr<void> _onAddVideo(
    AddVideoEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(AddingVideoState());
    final result = await addVideoUsecase(
      title: event.title,
      description: event.description,
      videoUrl: event.videoUrl,
    );
    result.fold(
      (failure) {
        emit(ErrorAddingVideoState(failure.message));
        add(FetchMediaEvent());
      },
      (_) {
        emit(AddedVideoState());

        add(FetchMediaEvent());
      },
    );
  }

  FutureOr<void> _onAddDocument(
    AddDocumentEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(AddingDocumentState());
    final result = await addDocumentUsecase(
      title: event.title,
      description: event.description,
      documentPath: event.documentPath,
    );
    result.fold(
      (failure) {
        emit(ErrorAddingDocumentState(failure.message));
        add(FetchMediaEvent());
      },
      (_) {
        emit(AddedDocumentState());

        add(FetchMediaEvent());
      },
    );
  }

  FutureOr<void> _onDeleteMedia(
    DeleteMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(DeletingMediaState());
    final result = await deleteMediaUsecase(mediaId: event.mediaId);
    result.fold(
      (failure) {
        emit(ErrorDeletingMediaState(failure.message));
        add(FetchMediaEvent());
      },
      (_) {
        emit(DeletedMediaState());
        add(FetchMediaEvent());
      },
    );
  }
}
