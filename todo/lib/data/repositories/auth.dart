import 'package:todo/data/datasources/firebase_auth_datasource.dart';
import 'package:todo/data/mappers/firebase_user_to_user_mapper.dart';
import 'package:todo/data/models/userModel.dart';
import 'package:todo/domain/repositories/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;


class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource authService;
  final FirebaseUserToUserMapper firebaseToModelMapper;

  AuthRepositoryImpl({
    required this.authService,
    required this.firebaseToModelMapper,
  });

  @override
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    firebase_auth.User? firebaseUser = (await authService.signInWithEmailPassword(email, password));
    if(firebaseUser != null) {
      return firebaseToModelMapper.map(firebaseUser);
    }
    return null;
  }
}