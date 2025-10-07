import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';

enum TaskFilter { all, completed, incomplete }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [];
  final StorageService storage = StorageService();
  TaskFilter _filter = TaskFilter.all;

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

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    storage.saveTasks(tasks);
  }

  List<Task> get filteredTasks {
    switch (_filter) {
      case TaskFilter.completed:
        return tasks.where((t) => t.isDone).toList();
      case TaskFilter.incomplete:
        return tasks.where((t) => !t.isDone).toList();
      case TaskFilter.all:
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              setState(() {
                _filter = filter;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: TaskFilter.all, child: Text('Todas')),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completadas'),
              ),
              PopupMenuItem(
                value: TaskFilter.incomplete,
                child: Text('Incompletas'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: filteredTasks.map((task) {
          return TaskTile(
            task: task,
            onChanged: (value) => toggleTask(task, value),
            onDelete: () => deleteTask(task),
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
