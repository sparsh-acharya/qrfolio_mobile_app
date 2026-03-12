import 'package:qr_folio/core/utils/typedef.dart';
import 'package:qr_folio/features/home/data/model/user_data_model.dart';

abstract class UserDatasource {
  FutureEither<UserDataModel> getUserData();
  FutureVoid updateUserData(Map<String, dynamic> updatedData);
}
