import 'package:flutter/material.dart';
import 'todo/todo_app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  try {
    await Hive.initFlutter();
    await Hive.openBox("todo");
 runApp(TodoApp());
  } catch (e) {
    print("Error initializing Hive: $e");
  }
}
