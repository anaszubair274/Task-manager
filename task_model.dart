import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}