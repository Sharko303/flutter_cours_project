import 'package:todo/domain/entities/userApp.dart';

class UserModel {
  final String id, displayName, email;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
  });

  UserModel map(User firebaseUser) {
    return UserModel(
      id: firebaseUser.id,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
    );
  }

  UserApp toDomain() {
    return UserApp(
      id: id,
      displayName: displayName,
      email: email,
    );
  }
}
