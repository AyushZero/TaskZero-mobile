import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: _taskController.text));
        _taskController.clear();
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
    });
  }

  void _completeTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      task.isCompleted = true;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
      _tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          style: TextStyle(
                            color: _showArchived ? Colors.black.withOpacity(0.25) : Colors.black,
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
                          style: TextStyle(
                            color: _showArchived ? Colors.black : Colors.black.withOpacity(0.25),
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
                        color: const Color(0xFF8C8C8C),
                        shape: const OvalBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _tasks.where((task) => task.isArchived == _showArchived).length,
                  itemBuilder: (context, index) {
                    final task = _tasks.where((task) => task.isArchived == _showArchived).toList()[index];
                    return Dismissible(
                      key: Key(task.title),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _archiveTask(index);
                        } else {
                          _completeTask(index);
                        }
                      },
                      background: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.archive, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
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
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
                      child: TextField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          hintText: 'Add a new task',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: _addTask,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}