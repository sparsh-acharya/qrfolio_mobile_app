import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/domain/entity/media_entity.dart';

abstract class MediaRepo {
  FutureEither<List<MediaEntity>> getMediaList();
  FutureVoid addImage({
    required String title,
    required String description,
    required String imagePath,
  });
  FutureVoid addVideo({
    required String title,
    required String description,
    required String videoUrl,
  });
  FutureVoid addDocument({
    required String title,
    required String description,
    required String documentPath,
  });
  FutureVoid deleteMedia({
    required String mediaId,
  });
}
