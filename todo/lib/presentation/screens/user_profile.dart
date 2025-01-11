import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/domain/entities/userApp.dart';
import '../providers/todo.dart';
import '../../theme.dart';
import '../providers/user.dart';

/* class userProfileApp extends StatelessWidget {
  const userProfileApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: colorScheme['primary'] as Color),
        useMaterial3: true,
      ),
      home: const UserProfilePage(title: 'Profile'),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Todo list'),
      },
    );
  }
} */

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.title});

  final String title;

  @override
  State<UserProfilePage> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserProvider>().currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: colorScheme['primary'],
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu), // L'icône du hamburger menu

            onPressed: () {
              // Action lorsque le bouton est pressé
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 1000,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.lightGreen.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          50), // Ajoute le rayon des bords
                      image: const DecorationImage(
                        image: AssetImage("assets/images/account_profil.png"),
                        fit: BoxFit.cover, // Ajuste l'image
                      ),
                    ),
                  ),
                ),
                Text(
                  currentUser?.username ?? 'Utilisateur inconnu',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text('Développeur flutter',
                    style: TextStyle(color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            context
                                .watch<TodoProvider>()
                                .todoList
                                .where(
                                    (element) => element.isChecked == false)
                                .length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text("Todo en cours",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            context
                                .watch<TodoProvider>()
                                .todoList
                                .where((todo) => todo.isChecked == true)
                                .length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text("Todo terminés",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            // on met le nombre de todo total grace a notre notifier providers,
                            context
                                .watch<TodoProvider>()
                                .todoList
                                .length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text("Todo total",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: () {
                      // on back
                      context
                          .read<UserProvider>()
                          .logout();  // Utilisation de UserProvider ici
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Text('Déconnexion'),
                  ),
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
