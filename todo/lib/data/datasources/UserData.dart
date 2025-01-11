import 'package:todo/domain/entities/userApp.dart';

abstract class UserData {
  Future<User> getUser();
  Future<User> login(String email, String password);
  Future<void> logout();
}

