part of 'media_bloc.dart';

@immutable
sealed class MediaState {}

final class MediaInitial extends MediaState {}

//Media States
class LoadingMediaState extends MediaState {}

class LoadedMediaState extends MediaState {
  final List<MediaEntity> mediaList;

  LoadedMediaState(this.mediaList);
}

class ErrorMediaState extends MediaState {
  final String message;

  ErrorMediaState(this.message);
}

// add media states
class AddingImageState extends MediaState {}

class AddedImageState extends MediaState {}

class ErrorAddingImageState extends MediaState {
  final String message;
  ErrorAddingImageState(this.message);
}

// add video states
class AddingVideoState extends MediaState {}
class AddedVideoState extends MediaState {}
class ErrorAddingVideoState extends MediaState {
  final String message;
  ErrorAddingVideoState(this.message);
}

// add document states
class AddingDocumentState extends MediaState {}
class AddedDocumentState extends MediaState {}
class ErrorAddingDocumentState extends MediaState {
  final String message;
  ErrorAddingDocumentState(this.message);
}

// delete media states
class DeletingMediaState extends MediaState {}
class DeletedMediaState extends MediaState {}
class ErrorDeletingMediaState extends MediaState {
  final String message;
  ErrorDeletingMediaState(this.message);
}
