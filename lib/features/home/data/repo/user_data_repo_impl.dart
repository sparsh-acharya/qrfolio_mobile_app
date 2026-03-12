import 'package:dartz/dartz.dart';
import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/data/datasource/datasource.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';
import 'package:qr_folio/features/home/domain/repo/user_data_repo.dart';

class UserDataRepoImpl implements UserDataRepo {
  final UserDatasource datasource;
  UserDataRepoImpl({required this.datasource});
  @override
  FutureEither<UserDataEntity> getUserData() async {
    final result = await datasource.getUserData();
    return result.fold((failure) => left(failure), (userDataModel) {
      print('-----------model-------------');
      print(userDataModel.toString());
      return right(userDataModel.toEntity());
    });
  }

  @override
  FutureVoid updateUserData(Map<String, dynamic> updatedData) async {
    final result = await datasource.updateUserData(updatedData);
    return result.fold((failure) => left(failure), (_) => right(null));
  }
}
