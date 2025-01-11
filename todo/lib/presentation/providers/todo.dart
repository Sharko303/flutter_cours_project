import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/domain/entities/todo.dart';
import 'package:todo/domain/usecases/todo.dart';

class TodoProvider with ChangeNotifier {
  final AddTodo addTodoUseCase;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoProvider({required this.addTodoUseCase});

  List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList;

  Future<void> fetchTodos() async {
    try {
      final userId = FirebaseAuth.instance.currentUser
          ?.uid; // Ou utilisez context.read<UserProvider>().currentUser?.id

      if (userId == null) {
        print("Utilisateur non connecté");
        return; // Vous pouvez aussi gérer cela autrement, par exemple en affichant une erreur
      }

      // Récupérez les todos depuis Firestore en filtrant par userId
      final snapshot = await _firestore
          .collection('todos')
          .where('userId', isEqualTo: userId) // Filtre par userId
          .get();

      _todoList = snapshot.docs
          .map((doc) => Todo(
                id: doc.id,
                title: doc['title'],
                isChecked: doc['isChecked'],
                userId: doc['userId'],
              ))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Erreur lors de la récupération des todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      // Ajouter la todo à Firestore
      await _firestore.collection('todos').doc(todo.id).set({
        'title': todo.title,
        'isChecked': todo.isChecked,
        'userId': todo.userId,
      });

      // Ajouter localement
      _todoList.add(todo);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'ajout de la todo: $e');
    }
  }

  Future<void> removeTodoList(int index) async {
    try {
      final todo = _todoList[index];
      await _firestore.collection('todos').doc(todo.id).delete();

      _todoList.removeAt(index);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la suppression de la todo: $e');
    }
  }

  Future<void> addCheckedTodoList(int index) async {
    try {
      final todo = _todoList[index];
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        isChecked: !todo.isChecked,
        userId: todo.userId,
      );

      // Mettre à jour dans Firestore
      await _firestore.collection('todos').doc(todo.id).update({
        'isChecked': updatedTodo.isChecked,
      });

      _todoList[index] = updatedTodo;
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la mise à jour de la todo: $e');
    }
  }
}



/* import 'package:flutter/material.dart';

class Todo with ChangeNotifier {
  // on veut gérer nos todo avec change notifier
  List todoList = [];

  addTodoList(todo) {
    todoList.add(todo);
    notifyListeners();
  }

  removeTodoList(index) {
    todoList.removeAt(index);
    notifyListeners();
  }

  addCheckedTodoList(index) {
    todoList[index]["isChecked"] = !todoList[index]["isChecked"];
    notifyListeners();
  }

  removeCheckedTodoList(index) {
    todoList[index]["isChecked"] = false;
    notifyListeners();
  }

  removeAllTodoList() {
    todoList = [];
    notifyListeners();
  }
} */