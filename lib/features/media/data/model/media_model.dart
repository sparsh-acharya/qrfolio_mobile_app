import 'package:qr_folio/features/media/domain/entity/media_entity.dart';

class MediaModel {
  final String id;
  final String type;
  final String url;
  final String mimeType;
  final int size;
  final String title;
  final String description;
  final String storageKey;
  final String planKey;
  final DateTime createdAt;

  MediaModel({
    required this.id,
    required this.type,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.title,
    required this.description,
    required this.storageKey,
    required this.planKey,
    required this.createdAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['_id'].toString(),
      type: json['type'].toString(),
      url: json['url'].toString(),
      mimeType: json['mimeType'].toString(),
      size: json['size'],
      title: json['title'].toString(),
      description: json['description'].toString(),
      storageKey: json['storageKey'].toString(),
      planKey: json['planKey'].toString(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  MediaEntity toEntity() {
    return MediaEntity(
      id: id,
      type: type,
      url: url,
      mimeType: mimeType,
      size: size,
      title: title,
      description: description,
      storageKey: storageKey,
      planKey: planKey,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => "id: $id, type: $type, url: $url, mimetype: $mimeType";
}
