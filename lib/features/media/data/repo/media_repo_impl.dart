import 'package:dartz/dartz.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/data/datasource/media_datasource.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';
import 'package:qr_folio/features/media/domain/repo/media_repo.dart';

class MediaRepoImpl implements MediaRepo {
  final MediaDatasource mediaDatasource;
  MediaRepoImpl({required this.mediaDatasource});

  @override
  FutureEither<List<MediaEntity>> getMediaList() async {
    final result = await mediaDatasource.fetchMediaList();
    return result.fold((failure) => left(failure), (mediaList) {
      for (final media in mediaList) {
        print(media.toString());
      }
      return right(mediaList.map((media) => media.toEntity()).toList());
    });
  }

  @override
  FutureVoid addImage({
    required String title,
    required String description,
    required String imagePath,
  }) async {
    final result = await mediaDatasource.addImage(
      title: title,
      description: description,
      imagePath: imagePath,
    );
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureVoid addVideo({
    required String title,
    required String description,
    required String videoUrl,
  }) async {
    final result = await mediaDatasource.addVideo(
      title: title,
      description: description,
      videoUrl: videoUrl,
    );
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureVoid addDocument({
    required String title,
    required String description,
    required String documentPath,
  }) async {
    final result = await mediaDatasource.addDocument(
      title: title,
      description: description,
      documentPath: documentPath,
    );
    return result.fold((failure) => left(failure), (_) => right(null));
  }

  @override
  FutureVoid deleteMedia({required String mediaId}) async {
    final result = await mediaDatasource.deleteMedia(mediaId: mediaId);
    return result.fold((failure) => left(failure), (_) => right(null));
  }
}
