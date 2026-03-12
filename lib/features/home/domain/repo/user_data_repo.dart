import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/domain/entity/user_data_entity.dart';

abstract class UserDataRepo {
  FutureEither<UserDataEntity> getUserData();
  FutureVoid updateUserData(Map<String, dynamic> updatedData);
}
