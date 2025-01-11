import 'package:todo/data/models/userModel.dart';
import 'package:todo/domain/entities/userApp.dart';

abstract class UserRepository {
  Future<UserApp?> getUserById(String id); // Retourne UserApp?, pas User
  Future<UserModel?> signInWithEmailPassword(String email, String password);
  Future<void> logout();
}
