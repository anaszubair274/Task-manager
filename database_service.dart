import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> addTask(String userId, Task task) async {
    try {
      final taskData = task.toMap();
      await _db
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .add(taskData);
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(String userId, Task task) async {
    try {
      final taskData = task.toMap();
      await _db
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(task.id)
          .update(taskData);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}