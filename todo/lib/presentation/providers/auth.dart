import 'package:flutter/material.dart';
import 'package:todo/domain/entities/userApp.dart';

import '../../domain/usecases/signinwithemail.dart';

class AuthProvider extends ChangeNotifier {
  final SignInWithEmail signInWithEmail;

  AuthProvider(this.signInWithEmail);

  UserApp? _user;
  UserApp? get user => _user;

  Future<void> signIn(String email, String password) async {
    _user = await signInWithEmail(email, password);
    notifyListeners();
  }
}