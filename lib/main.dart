import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF8C8C8C),
          secondary: Color(0xFFD9D9D9),
          surface: Colors.white,
          error: Colors.red,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8C8C8C),
          secondary: Color(0xFF2C2C2C),
          surface: Color(0xFF1A1A1A),
          error: Colors.red,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const TaskManagerScreen(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  bool isArchived;

  Task({
    required this.title,
    this.isCompleted = false,
    this.isArchived = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'isCompleted': isCompleted,
    'isArchived': isArchived,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    isCompleted: json['isCompleted'],
    isArchived: json['isArchived'],
  );
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<Task> _tasks = [];
  bool _isDarkMode = false;
  bool _showArchived = false;
  final TextEditingController _taskController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final tasksJson = _prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks.clear();
      _tasks.addAll(tasksJson.map((json) => Task.fromJson(jsonDecode(json))));
    });
  }

  Future<void> _saveTasks() async {
    final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await _prefs.setStringList('tasks', tasksJson);
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: _taskController.text));
        _taskController.clear();
        _saveTasks();
      });
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleView() {
    setState(() {
      _showArchived = !_showArchived;
    });
  }

  void _archiveTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      task.isArchived = true;
      _saveTasks();
    });
  }

  void _unarchiveTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      task.isArchived = false;
      _saveTasks();
    });
  }

  void _completeTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      task.isCompleted = true;
      _saveTasks();
    });
  }

  void _incompleteTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      task.isCompleted = false;
      _saveTasks();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      _tasks.remove(task);
      _saveTasks();
    });
  }

  void _showTaskOptions(BuildContext context, int index) {
    final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_showArchived) ...[
                ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
                  onTap: () {
                    if (task.isCompleted) {
                      _incompleteTask(index);
                    } else {
                      _completeTask(index);
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive),
                  title: const Text('Archive'),
                  onTap: () {
                    _archiveTask(index);
                    Navigator.pop(context);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.unarchive),
                  title: const Text('Unarchive'),
                  onTap: () {
                    _unarchiveTask(index);
                    Navigator.pop(context);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  _deleteTask(index);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_showArchived) _toggleView();
                          },
                          child: Text(
                            'Tasks',
                            style: textTheme.bodyLarge?.copyWith(
                              color: _showArchived ? colorScheme.primary.withAlpha(64) : colorScheme.primary,
                              fontSize: 28.80,
                              fontFamily: 'Nixie One',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            if (!_showArchived) _toggleView();
                          },
                          child: Text(
                            'Archived',
                            style: textTheme.bodyLarge?.copyWith(
                              color: _showArchived ? colorScheme.primary : colorScheme.primary.withAlpha(64),
                              fontSize: 28.80,
                              fontFamily: 'Nixie One',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _toggleTheme,
                      child: Container(
                        width: 39,
                        height: 39,
                        decoration: ShapeDecoration(
                          color: colorScheme.primary,
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      // Swipe right
                      if (_showArchived) _toggleView();
                    } else if (details.primaryVelocity! < 0) {
                      // Swipe left
                      if (!_showArchived) _toggleView();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    decoration: ShapeDecoration(
                      color: colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _tasks.where((task) => task.isArchived == _showArchived).length,
                      itemBuilder: (context, index) {
                        final allTasks = _tasks.where((task) => task.isArchived == _showArchived).toList();
                        final incompleteTasks = allTasks.where((task) => !task.isCompleted).toList();
                        final completedTasks = allTasks.where((task) => task.isCompleted).toList();
                        
                        // If we're past the incomplete tasks, show completed tasks
                        final task = index < incompleteTasks.length 
                            ? incompleteTasks[index]
                            : completedTasks[index - incompleteTasks.length];

                        return Dismissible(
                          key: Key(task.title),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              if (!_showArchived) {
                                _archiveTask(index);
                              } else {
                                _unarchiveTask(index);
                              }
                            } else {
                              if (!_showArchived) {
                                if (task.isCompleted) {
                                  _incompleteTask(index);
                                } else {
                                  _completeTask(index);
                                }
                              }
                            }
                          },
                          background: Container(
                            color: Colors.blue,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(
                              _showArchived ? Icons.unarchive : Icons.archive,
                              color: Colors.white,
                            ),
                          ),
                          secondaryBackground: Container(
                            color: Colors.green,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              task.isCompleted ? Icons.undo : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          child: GestureDetector(
                            onLongPress: () => _showTaskOptions(context, index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: double.infinity,
                              child: Text(
                                task.title,
                                style: textTheme.bodyMedium?.copyWith(
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: ShapeDecoration(
                          color: colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: TextField(
                          controller: _taskController,
                          style: textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Add a new task',
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary.withAlpha(128),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: ShapeDecoration(
                        color: colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: colorScheme.primary),
                        onPressed: _addTask,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}