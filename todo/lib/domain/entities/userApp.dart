import 'package:todo/data/models/userModel.dart';

class User {
  final String id, username, email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  String get displayName => 'User: $username';
}

class UserApp {
  final String id;
  final String displayName;
  final String email;

  UserApp({
    required this.id,
    required this.displayName,
    required this.email,
  });

  UserApp map(UserModel userModel) {
    return UserApp(
      id: userModel.id,
      displayName: userModel.displayName,
      email: userModel.email,
    );
  }

  // Convertir un utilisateur Firebase en utilisateur de l'application
  factory UserApp.fromFirebaseUser(User firebaseUser) {
    return UserApp(
      id: firebaseUser.id,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
    );
  }
}