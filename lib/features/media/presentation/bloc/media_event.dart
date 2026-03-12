part of 'media_bloc.dart';

@immutable
sealed class MediaEvent {}
class FetchMediaEvent extends MediaEvent {}

class AddImageEvent extends MediaEvent {
  final String title;
  final String description;
  final String imagePath;

  AddImageEvent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
class AddVideoEvent extends MediaEvent {
  final String title;
  final String description;
  final String videoUrl;

  AddVideoEvent({
    required this.title,
    required this.description,
    required this.videoUrl,
  });
}

class AddDocumentEvent extends MediaEvent {
  final String title;
  final String description;
  final String documentPath;

  AddDocumentEvent({
    required this.title,
    required this.description,
    required this.documentPath,
  });
}

class DeleteMediaEvent extends MediaEvent {
  final String mediaId;

  DeleteMediaEvent({required this.mediaId});
}
