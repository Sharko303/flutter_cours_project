import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoFirestoreDataSource {
  final FirebaseFirestore firestore;

  TodoFirestoreDataSource(this.firestore);

  Future<void> addTodo(TodoModel todo) async {
    await firestore.collection('todos').doc(todo.id).set(todo.toFirestore());
  }

  Future<void> removeTodo(String id) async {
    await firestore.collection('todos').doc(id).delete();
  }

  Future<void> updateTodo(TodoModel todo) async {
    await firestore.collection('todos').doc(todo.id).update(todo.toFirestore());
  }

  Future<List<TodoModel>> fetchTodos() async {
    final snapshot = await firestore.collection('todos').get();
    return snapshot.docs
        .map((doc) => TodoModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}
