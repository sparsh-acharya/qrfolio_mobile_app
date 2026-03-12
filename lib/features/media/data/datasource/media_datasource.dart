import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/data/model/media_model.dart';

abstract class MediaDatasource {
  FutureEither<List<MediaModel>> fetchMediaList();
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
