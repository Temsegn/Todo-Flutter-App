import 'package:hive_flutter/hive_flutter.dart';

class TodoListDatabase {
  List todoList = [];

  final _todo = Hive.box("todo");

  void createInitialData() {
    todoList = [
      ["meet markos", false],
      ["meet abegiya", false],
    ];
    updateDatabase();
  }

  void loadData() {
    todoList = _todo.get('task');
  }

  void updateDatabase() {
    _todo.put("task", todoList);
  }
}
