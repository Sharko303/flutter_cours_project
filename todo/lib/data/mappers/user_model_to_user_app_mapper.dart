import 'package:todo/data/models/userModel.dart';
import 'package:todo/domain/entities/userApp.dart';

class UserModelToUserAppMapper {
  UserApp call(UserModel userModel) {
    return UserApp(
      id: userModel.id,
      email: userModel.email,
      displayName: userModel.displayName, // Ajoutez les champs supplémentaires si nécessaires
    );
  }
}
