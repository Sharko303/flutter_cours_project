import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/data/datasources/firebase_auth_datasource.dart';
import 'package:todo/data/datasources/todo_firestore_data_source.dart';
import 'package:todo/data/mappers/firebase_user_to_user_mapper.dart';
import 'package:todo/data/mappers/user_model_to_user_app_mapper.dart';
import 'package:todo/data/repositories/auth.dart';
import 'package:todo/data/repositories/todo_repository_impl.dart';
import 'package:todo/data/repositories/userRepositories.dart';
import 'package:todo/domain/entities/todo.dart';
import 'package:todo/domain/repositories/auth.dart';
import 'package:todo/domain/usecases/signinwithemail.dart';
import 'package:todo/domain/usecases/todo.dart';
import 'package:todo/domain/usecases/user.dart';
import 'package:todo/presentation/providers/auth.dart';
import 'package:todo/presentation/providers/user.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "presentation/screens/user_profile.dart";
import './theme.dart';
import 'presentation/screens/login.dart';
import 'presentation/providers/todo.dart';

// create a const variable with the theme of the app primary #94BA4E and secondary #8B9575 color

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final userRepository = UserRepositoryImpl(
    authService: FirebaseAuthDataSource(),
    firebaseToModelMapper: FirebaseUserToUserMapper(),
  );
  final getUser = GetUser(userRepository); // crée l'instance de GetUser
  final loginUser = LoginUser(userRepository); // crée l'instance de LoginUser
  final logoutUser =
      LogoutUser(userRepository); // cree l'instance de LogoutUser

  final todoProvider = TodoProvider(
    addTodoUseCase: AddTodo(TodoRepositoryImpl(
      TodoFirestoreDataSource(FirebaseFirestore.instance),
    )),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TodoProvider(
          addTodoUseCase: AddTodo(TodoRepositoryImpl(
              TodoFirestoreDataSource(FirebaseFirestore.instance))),
        )..fetchTodos(), // Charger les todos au démarrage
      ),
      ChangeNotifierProvider(
        create: (context) => AuthProvider(
          SignInWithEmail(
            AuthRepositoryImpl(
              authService: FirebaseAuthDataSource(),
              firebaseToModelMapper: FirebaseUserToUserMapper(),
            ),
            UserModelToUserAppMapper(), // Ajoutez l'instance du mapper ici
          ),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(
          getUser: getUser, // injection de GetUser
          loginUser: loginUser, // injection de LoginUser
          logoutUser: logoutUser, // injection de LogoutUser
          firebaseAuth:
              firebase_auth.FirebaseAuth.instance, // Ajout de FirebaseAuth
        ),
      ),
      Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
                authService: FirebaseAuthDataSource(),
                firebaseToModelMapper: FirebaseUserToUserMapper(),
              )),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: colorScheme['primary'] as Color),
        useMaterial3: true,
      ),
      home: // si on est connecté on affiche la page d'accueil sinon on affiche la page de login
          /* context.watch<User>().isLogged
              ? const MyHomePage(title: 'Todo list')
              : */
          const LoginPage(
        title: "Connexion",
      ),
      initialRoute: '/',
      routes: {
        '/userProfile': (context) => const UserProfilePage(title: 'Profile'),
        '/login': (context) => const LoginPage(
              title: "Connexion",
            ),
        '/home': (context) => const MyHomePage(title: 'Todo list'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textTodoInput = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().todoList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme['primary'],
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              Navigator.pushNamed(context, '/userProfile');
            },
          ),
        ],
      ),
      body: todos.isEmpty
          ? const Center(child: Text("No todos available"))
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isChecked,
                    onChanged: (bool? value) {
                      // Appel de la méthode pour cocher/décocher une tâche
                      Provider.of<TodoProvider>(context, listen: false)
                          .addCheckedTodoList(index);
                    },
                  ),
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Ajoutez ici la suppression dans Firestore si nécessaire
                      Provider.of<TodoProvider>(context, listen: false)
                          .removeTodoList(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme['secondary'],
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Add a todo'),
            content: TextField(
              controller: textTodoInput,
              decoration: const InputDecoration(hintText: 'Enter your todo'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (textTodoInput.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid todo'),
                      ),
                    );
                    return;
                  }

                  final newTodo = Todo(
                    id: DateTime.now().toString(),
                    title: textTodoInput.text.trim(),
                    isChecked: false,
                    userId: context.read<UserProvider>().currentUser?.id ?? '',
                  );

                  try {
                    await context.read<TodoProvider>().addTodo(newTodo);
                    Navigator.pop(context, 'Add');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add todo: $e'),
                      ),
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        tooltip: 'Add todo',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
