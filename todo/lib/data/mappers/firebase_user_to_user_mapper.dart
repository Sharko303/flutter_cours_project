import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/data/models/userModel.dart';

class FirebaseUserToUserMapper {
  UserModel map(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '', 
    );
  }
}
