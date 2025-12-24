import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class AddTaskScreen extends StatefulWidget {
  final String userId;
  final Task? task;

  const AddTaskScreen({Key? key, required this.userId, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dbService = DatabaseService();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  Future<void> _saveTask() async {
    final task = Task(
      id: widget.task?.id ?? '',
      title: _titleController.text,
      description: _descController.text,
      dueDate: _selectedDate,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    if (widget.task == null) {
      await _dbService.addTask(widget.userId, task);
    } else {
      await _dbService.updateTask(widget.userId, task);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Due: ${_selectedDate.toString().split(' ')[0]}'),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                  child: Text('Pick Date'),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}