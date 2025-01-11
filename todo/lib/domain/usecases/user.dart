
import 'package:todo/data/models/userModel.dart';
import 'package:todo/domain/entities/userApp.dart';
import 'package:todo/domain/repositories/userRepository.dart';

class GetUser {
  final UserRepository  repository;
  GetUser(this.repository);
  Future<UserApp?> call(String id) => repository.getUserById(id);
}

class LoginUser {
  final UserRepository repository;
  LoginUser(this.repository);
  Future<UserModel?> call(String email, String password) => repository.signInWithEmailPassword(email, password);
}

class LogoutUser {
  final UserRepository repository;
  LogoutUser(this.repository);
  Future<void> call() => repository.logout();
}