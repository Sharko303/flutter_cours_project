import 'package:todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.isChecked,
    required super.userId
  });

  factory TodoModel.fromFirestore(Map<String, dynamic> json, String id) {
    return TodoModel(
      id: id,
      title: json['title'],
      isChecked: json['isChecked'] ?? false,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isChecked': isChecked,
      'userId': userId,
    };
  }
}
