import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/entities/userApp.dart';
import 'package:todo/presentation/providers/auth.dart';
import 'package:todo/presentation/providers/user.dart';
import '../../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

// écrant de login de l'application
class _LoginState extends State<LoginPage> {
  final usernameText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme['primary'],
        title: Text("Login"),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              Navigator.pushNamed(context, '/userProfile');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Connectez-vous",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: usernameText,
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: emailText,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: passwordText,
                obscureText: true, // Rend le champ Password masqué
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  /*  try {
                    // Récupération de l'instance de votre AuthRepository ou service
                    final authRepository = context.read<AuthRepository>();
                    // Appel à la méthode de connexion
                    final userCredential =
                        await authRepository.signInWithEmailPassword(
                      emailText.text,
                      passwordText.text,
                    );

                    // Vérifiez si l'utilisateur est authentifié
                    // Vérifiez si l'utilisateur est authentifié
                    if (userCredential != null && userCredential.displayName != null && userCredential.email != null) {
                      // Convertir l'utilisateur Firebase en UserModel
                      UserApp appUser =
                          UserApp.fromFirebaseUser({userCredential.displayName, userCredential.email} as User);

                      // Vous pouvez maintenant utiliser appUser dans votre logique d'application
                      print("Utilisateur connecté : ${appUser.displayName}");

                      // Connexion réussie
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Connexion réussie !')),
                      );

                      // Optionnel : Naviguer ou mettre à jour l'état de l'application
                      context.read<Todo>().removeAllTodoList();
                    } else {
                      // Échec de la connexion
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email ou mot de passe incorrect')),
                      );
                    }
                  } catch (e) {
                    print(e);
                    // Gestion des erreurs
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : ${e.toString()}')),
                    );
                  } */

                  /* await authProvider.signIn(
                    emailText.text,
                    passwordText.text,
                  ); */
                  try {
                    await userProvider.login(
                      usernameText.text,
                      emailText.text,
                      passwordText.text,
                    );
                    if (userProvider.currentUser != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email ou mot de passe incorrect')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: ${e.toString()}')),
                    );
                  }
                },
                child: const Text("Connexion"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
