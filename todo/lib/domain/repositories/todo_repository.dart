import 'package:todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<void> addTodo(Todo todo);
  Future<void> removeTodo(String id);
  Future<void> updateTodo(Todo todo);
  Future<List<Todo>> fetchTodos();
}
