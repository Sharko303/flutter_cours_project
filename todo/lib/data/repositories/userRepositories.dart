import 'package:todo/data/datasources/firebase_auth_datasource.dart';
import 'package:todo/data/mappers/firebase_user_to_user_mapper.dart';
import 'package:todo/data/models/userModel.dart';
import 'package:todo/domain/entities/userApp.dart';
import 'package:todo/domain/repositories/userRepository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserRepositoryImpl implements UserRepository {
  UserModel? _mockUser;
  final FirebaseAuthDataSource authService;
  final FirebaseUserToUserMapper firebaseToModelMapper;

  UserRepositoryImpl({
    required this.authService,
    required this.firebaseToModelMapper,
  });

  @override
  Future<UserApp?> getUserById(String id) async {
    if (_mockUser != null && _mockUser!.id == id) {
      return _mockUser!.toDomain(); // Convertit en UserApp
    }
    return null; // Retourne null si aucun utilisateur trouvé
  }

  Future<bool> login(String username, String password) async {
    _mockUser = UserModel(
      id: '123',
      displayName: username,
      email: '$username@exeample.com',
    );
    return true;
  }

  @override
  Future<void> logout() async {
    _mockUser = null;
  }

  @override
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    firebase_auth.User? firebaseUser =
        (await authService.signInWithEmailPassword(email, password));
    if (firebaseUser != null) {
      return firebaseToModelMapper.map(firebaseUser);
    }
    return null;
  }
}
