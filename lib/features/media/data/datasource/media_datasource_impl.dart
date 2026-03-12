import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qr_folio/core/errors/failure.dart';
import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/core/utils/constants.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/media/data/datasource/media_datasource.dart';
import 'package:qr_folio/features/media/data/model/media_model.dart';

class MediaDatasourceImpl implements MediaDatasource {
  final Dio dio;
  MediaDatasourceImpl({required this.dio});

  @override
  FutureEither<List<MediaModel>> fetchMediaList() async {
    final String? token = await AppStorage().getToken();
    try {
      final result = await dio.get(
        '$baseUrl/gallery/',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (result.statusCode == 200) {
        List<MediaModel> mediaList = (result.data['items'] as List)
            .map((mediaJson) => MediaModel.fromJson(mediaJson))
            .toList();
        return right(mediaList);
      } else {
        return left(ApiError(message: 'Failed to fetch media list'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid addImage({
    required String title,
    required String description,
    required String imagePath,
  }) async {
    final String? token = await AppStorage().getToken();
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "file": await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
    });
    try {
      final result = await dio.post(
        '$baseUrl/gallery/images',
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: "multipart/form-data",
        ),
      );
      if (result.statusCode == 200) {
        print("uploaded");
        return right(null);
      } else {
        return left(ApiError(message: 'Failed to add image'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid addVideo({
    required String title,
    required String description,
    required String videoUrl,
  }) async {
    final String? token = await AppStorage().getToken();
    try {
      final json = jsonEncode({
        "title": title,
        "description": description,
        "url": videoUrl,
      });
      print(json);
      final result = await dio.post(
        '$baseUrl/gallery/videos',
        data: json,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (result.statusCode == 200) {
        print("uploaded");
        return right(null);
      } else {
        return left(ApiError(message: 'Failed to add video'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid addDocument({
    required String title,
    required String description,
    required String documentPath,
  }) async {
    final String? token = await AppStorage().getToken();
    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "file": await MultipartFile.fromFile(
        documentPath,
        filename: documentPath.split('/').last,
      ),
    });
    try {
      final result = await dio.post(
        '$baseUrl/gallery/images',
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: "multipart/form-data",
        ),
      );
      if (result.statusCode == 200) {
        print("document uploaded");
        return right(null);
      } else {
        return left(ApiError(message: 'Failed to add document'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid deleteMedia({required String mediaId}) async {
    final String? token = await AppStorage().getToken();

  try {
    print("Attempting to delete media with ID: $mediaId");
    final response = await dio.delete(
      'https://api.qrfolio.net/api/gallery/$mediaId',
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return right(null);
    } else {
      return left(ApiError(message: "Failed to delete"));
    }
  } on DioException catch (e) {
    print("code: $mediaId");
    print("STATUS: ${e.response?.statusCode}");
    print("DATA: ${e.response?.data}");
    return left(ApiError(
        message: e.response?.data.toString() ?? "Delete failed"));
  }
  }
}
