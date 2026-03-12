class MediaEntity {
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

  MediaEntity({
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

  @override
  String toString() => "id: $id, type: $type, url: $url, mimetype: $mimeType";
}
