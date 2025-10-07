import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String tasksKey = 'tasks';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks
        .map(
          (t) => jsonEncode({
            'title': t.title,
            'description': t.description,
            'isDone': t.isDone,
          }),
        )
        .toList();
    await prefs.setStringList(tasksKey, jsonList);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(tasksKey) ?? [];
    return jsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr);
      return Task(
        title: map['title'],
        description: map['description'],
        isDone: map['isDone'],
      );
    }).toList();
  }
}
