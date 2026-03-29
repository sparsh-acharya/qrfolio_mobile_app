import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr/qr.dart';
import 'package:qr_folio/core/errors/failure.dart';
import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/core/utils/constants.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/data/datasource/datasource.dart';
import 'package:qr_folio/features/home/data/model/user_data_model.dart';

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;
  UserDatasourceImpl({required this.dio});

  PrettyQrDecoration kQrDecoration = const PrettyQrDecoration(
  // image: PrettyQrDecorationImage(

  //   image: Svg('assets/logo.svg'),
  // ),
  shape: PrettyQrShape.custom(
    PrettyQrSquaresSymbol(color: Colors.black),
  ),
);


  Future<String> _generateProfileQrBase64(String userId) async {
    final trimmedUserId = userId.trim();
    if (trimmedUserId.isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }

    final webBase = dotenv.env['WEB_BASE_URL']!;
    final profileUrl = '$webBase/profile/$trimmedUserId';
    final qrCode = QrCode.fromData(
      data: profileUrl,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    final qrImage = QrImage(qrCode);
    final byteData = await qrImage.toImageAsBytes(
      size: 512,
      format: ui.ImageByteFormat.png,
      decoration: kQrDecoration,
    );

    if (byteData == null) {
      throw StateError('Failed to render QR image bytes');
    }

    return 'data:image/png;base64,${base64Encode(byteData.buffer.asUint8List())}';
  }

  @override
  FutureEither<UserDataModel> getUserData() async {
    final String? token = await AppStorage().getToken();
    final String? userName = await AppStorage().getName();
    final String? userEmail = await AppStorage().getEmail();
    final bool isVerified = await AppStorage().getIsVerified() == "true";
    final bool isPaid = await AppStorage().getIsPaid() == "true";

    //TODO: add isverified and is payed
    try {
      final result = await dio.get(
        '$baseUrl/user/me',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (result.statusCode == 200) {
        result.data['token'] = token;
        result.data['name'] = userName;
        result.data['email'] = userEmail;
        result.data['isVerified'] = isVerified;
        result.data['isPaid'] = isPaid;

        result.data['qrCodeImage'] =
            (result.data['qrCodeImage'] == null ||
                result.data['qrCodeImage'].isEmpty)
            ? await _generateProfileQrBase64(result.data['_id'])
            : result.data['qrCodeImage'];

        result.data['qrCodeUrl'] =
            (result.data['qrCodeUrl'] == null ||
                result.data['qrCodeUrl'].isEmpty)
            ? '${dotenv.env['WEB_BASE_URL'] ?? 'https://www.qrfolio.net'}/profile/${result.data['_id']}'
            : result.data['qrCodeUrl'];


        return right(UserDataModel.fromJson(result.data));
      } else {
        return left(ApiError(message: 'Failed to fetch user data'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid updateUserData(Map<String, dynamic> updatedData) async {
    try {
      final String? token = await AppStorage().getToken();
      final result = await dio.put(
        '$baseUrl/user/edit-profile',
        data: jsonEncode(updatedData),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (result.statusCode == 200) {
        return right(null);
      } else {
        return left(ApiError(message: 'Failed to update user data'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }

  @override
  FutureVoid uploadPhoto(String filePath) async {
    try {
      final String? token = await AppStorage().getToken();
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      final result = await dio.post(
        '$baseUrl/user/upload-photo',
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: 'multipart/form-data',
        ),
      );

      if (result.statusCode == 200) {
        return right(null);
      } else {
        return left(ApiError(message: 'Failed to upload photo'));
      }
    } catch (e) {
      return left(ApiError(message: 'An error occurred: $e'));
    }
  }
}
