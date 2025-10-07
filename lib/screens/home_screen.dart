import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  final StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final loadedTasks = await storage.loadTasks();
    setState(() {
      tasks.addAll(loadedTasks);
    });
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    storage.saveTasks(tasks);
  }

  void toggleTask(Task task, bool? value) {
    setState(() {
      task.isDone = value ?? false;
    });
    storage.saveTasks(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo App')),
      body: ListView(
        children: tasks.map((task) {
          return TaskTile(
            task: task,
            onChanged: (value) => toggleTask(task, value),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task?>(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (newTask != null) addTask(newTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
