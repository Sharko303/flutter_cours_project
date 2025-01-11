import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebase; // Importation de FirebaseAuth
import 'package:todo/domain/entities/userApp.dart';
import '../../domain/usecases/user.dart';

class UserProvider extends ChangeNotifier {
  final GetUser getUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final firebase.FirebaseAuth firebaseAuth; // Ajout de FirebaseAuth

  User? _currentUser;
  User? get currentUser => _currentUser;

  UserProvider({
    required this.getUser,
    required this.loginUser,
    required this.logoutUser,
    required this.firebaseAuth, // Ajout du constructeur
  }) {
    // Écoutez les changements d'état d'authentification
    firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        // Si un utilisateur est connecté, mettez à jour _currentUser
        _currentUser = User(
          id: user.uid, // Utilisez l'ID de Firebase comme ID de l'utilisateur
          username:
              user.displayName ?? '', // Utilisez le nom d'affichage de Firebase
          email: user.email ?? '',
        );
        print('User: ${_currentUser?.username}');
      } else {
        print("User is not logged in");
        // Si aucun utilisateur n'est connecté, réinitialisez _currentUser
        _currentUser = null;
      }
      notifyListeners(); // Notifiez les écouteurs du changement
    });
  }

  // Fonction pour récupérer l'utilisateur par ID
  Future<void> getUserById(String id) async {
    _currentUser = (await getUser(id)) as User?;
    notifyListeners();
  }

// Fonction de connexion
  Future<void> login(String username, String email, String password) async {
    try {
      // Vérifiez si l'utilisateur existe et si les informations sont correctes
      final success = await loginUser(email, password);
      print(success?.id);

      // Si l'utilisateur n'existe pas ou si l'ID est nul, le mot de passe est incorrect
      if (success?.id == null) {
        throw Exception("Email ou mot de passe incorrect");
      }

      print("success");

      // Tentative de connexion avec FirebaseAuth
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Si l'utilisateur est connecté via FirebaseAuth, mettez à jour _currentUser
      final user = userCredential.user;
      if (user != null) {
        _currentUser = User(
          id: user.uid,
          username: username,
          email: user.email ?? '',
        );
        notifyListeners();
      } else {
        throw Exception("Erreur lors de la connexion à Firebase");
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      rethrow; // Relancez l'erreur pour la gérer dans l'appelant
    }
  }

  // Fonction de déconnexion
  Future<void> logout() async {
    await logoutUser();
    await firebaseAuth.signOut(); // Déconnexion via FirebaseAuth
    _currentUser = null;
    notifyListeners();
  }
}
