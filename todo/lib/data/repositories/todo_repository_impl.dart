import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/domain/entities/todo.dart';
import 'package:todo/domain/repositories/todo_repository.dart';
import '../datasources/todo_firestore_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoFirestoreDataSource dataSource;
  // on récupére l'userId de l'utilisateur connecté
  final userId = FirebaseAuth.instance.currentUser?.uid;

  TodoRepositoryImpl(this.dataSource);

  @override
  Future<void> addTodo(Todo todo) async {
     if (userId == "") {
      return;
    }
    print('userId: $userId');
    final todoModel = TodoModel(
      id: todo.id,
      title: todo.title,
      isChecked: todo.isChecked,
      userId: userId ?? '',
    );
    await dataSource.addTodo(todoModel);
  }

  @override
  Future<void> removeTodo(String id) async {
    await dataSource.removeTodo(id);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todoModel = TodoModel(
      id: todo.id,
      title: todo.title,
      isChecked: todo.isChecked,
      userId: userId ?? '',
    );
    await dataSource.updateTodo(todoModel);
  }

  @override
  Future<List<Todo>> fetchTodos() async {
    return await dataSource.fetchTodos();
  }
}
