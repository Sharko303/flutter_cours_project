import 'package:todo/data/mappers/user_model_to_user_app_mapper.dart';
import 'package:todo/domain/entities/userApp.dart';

import '../repositories/auth.dart';

class SignInWithEmail {
    final AuthRepository authRepository;
    final UserModelToUserAppMapper userModelToUserAppMapper;
    SignInWithEmail(this.authRepository, this.userModelToUserAppMapper);
    Future<UserApp?> call(String email, String password) async {
        final userModel = await authRepository.signInWithEmailPassword(email, password);
        if(userModel != null) {
            return userModelToUserAppMapper(userModel);
        }
        return null;
    }
}