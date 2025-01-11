import 'package:todo/data/models/userModel.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithEmailPassword(String email, String password);
}