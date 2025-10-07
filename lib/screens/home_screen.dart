import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';
import '../theme/colors.dart';

enum TaskFilter { all, completed, incomplete }

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

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

  String get appBarTitle {
    switch (_filter) {
      case TaskFilter.completed:
        return 'Tareas completadas';
      case TaskFilter.incomplete:
        return 'Tareas incompletas';
      case TaskFilter.all:
      default:
        return 'Todas las tareas';
    }
  }

  Icon get appBarIcon {
    switch (_filter) {
      case TaskFilter.completed:
        return const Icon(Icons.check_circle);
      case TaskFilter.incomplete:
        return const Icon(Icons.pending_actions);
      case TaskFilter.all:
      default:
        return const Icon(Icons.list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: appBarIcon,
        actions: [
          // Icono para cambiar tema
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: widget.toggleTheme,
          ),
          // Popup para filtros
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) => setState(() => _filter = filter),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryLight.withOpacity(0.3),
              widget.isDarkMode ? backgroundDark : background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: filteredTasks.isEmpty
            ? Center(
                child: Text(
                  _filter == TaskFilter.all
                      ? 'No tienes tareas'
                      : _filter == TaskFilter.completed
                      ? 'No tienes tareas completadas'
                      : 'No tienes tareas incompletas',
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.isDarkMode
                        ? textDark.withOpacity(0.7)
                        : text.withOpacity(0.7),
                  ),
                ),
              )
            : ListView(
                children: filteredTasks.map((task) {
                  return TaskTile(
                    task: task,
                    onChanged: (value) => toggleTask(task, value),
                    onDelete: () => deleteTask(task),
                    onEdit: () async {
                      final editedTask = await Navigator.push<Task?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTaskScreen(task: task),
                        ),
                      );
                      if (editedTask != null) {
                        setState(() {
                          final index = tasks.indexOf(task);
                          tasks[index] = editedTask;
                        });
                        storage.saveTasks(tasks);
                      }
                    },
                  );
                }).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task?>(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (newTask != null) addTask(newTask);
        },
        child: const Icon(Icons.add, size: 32),
        elevation: 8,
      ),
    );
  }
}
