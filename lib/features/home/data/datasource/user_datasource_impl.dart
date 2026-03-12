import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qr_folio/core/errors/failure.dart';
import 'package:qr_folio/core/utils/app_storage.dart';
import 'package:qr_folio/core/utils/constants.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/data/datasource/datasource.dart';
import 'package:qr_folio/features/home/data/model/user_data_model.dart';

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;
  UserDatasourceImpl({required this.dio});

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
      final result = await dio.put(
        '$baseUrl/user/edit-profile',
        data: jsonEncode(updatedData),
        options: Options(
          headers: {"Authorization": "Bearer ${await AppStorage().getToken()}"},
        ),
      );
      if (result.statusCode == 200) {
        return Future.value(right(null));
      } else {
        return Future.value(
          left(ApiError(message: 'Failed to update user data')),
        );
      }
    } catch (e) {
      return Future.value(left(ApiError(message: 'An error occurred: $e')));
    }
  }
}
