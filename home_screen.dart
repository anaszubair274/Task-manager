import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/task_model.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State {
  final _authService = AuthService();
  final _dbService = DatabaseService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser!.uid;

    final screens = [
      _TaskListView(userId: userId, dbService: _dbService),
      _CalendarView(userId: userId, dbService: _dbService),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(userId: userId),
          ),
        ),
        child: Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _TaskListView extends StatelessWidget {
  final String userId;
  final DatabaseService dbService;

  _TaskListView({required this.userId, required this.dbService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: dbService.getTasks(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final tasks = snapshot.data!;
        if (tasks.isEmpty) {
          return Center(child: Text('No tasks yet!'));
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(task.description),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  task.isCompleted = value!;
                  dbService.updateTask(userId, task);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTaskScreen(userId: userId, task: task),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => dbService.deleteTask(userId, task.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CalendarView extends StatelessWidget {
  final String userId;
  final DatabaseService dbService;

  _CalendarView({required this.userId, required this.dbService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: dbService.getTasks(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final tasks = snapshot.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text('${task.description}\nDue: ${task.dueDate.toString().split(' ')[0]}'),
              leading: Icon(Icons.calendar_today),
            );
          },
        );
      },
    );
  }
}