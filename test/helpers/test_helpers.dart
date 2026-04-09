import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ui_lab_3/models/task.dart';
import 'package:ui_lab_3/repositories/tasks_repository.dart';

// ignore: subtype_of_sealed_class
class FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;
  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;
  @override
  Map<String, dynamic>? data() => _data;
  @override
  bool get exists => _data != null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class FakeTasksRepository implements TasksRepository {
  final List<Task> _tasks = [];
  final StreamController<List<Task>> _controller = StreamController<List<Task>>.broadcast();

  void _emit() => _controller.add(List.unmodifiable(_tasks));
  
  void emitError(Object error) => _controller.addError(error);

  void seedTasks(List<Task> initialTasks) {
    _tasks.clear();
    _tasks.addAll(initialTasks);
    _emit();
  }

  @override
  Stream<List<Task>> getTasksStream(String userId) {
    Future.microtask(() => _emit());
    return _controller.stream.map((tasks) => tasks.where((t) => t.authorId == userId).toList());
  }

  @override
  Future<void> addTask(Task task) async {
    final withId = task.copyWith(id: 'id_${_tasks.length + 1}');
    _tasks.add(withId);
    _emit();
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      _emit();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    _emit();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void dispose() => _controller.close();
}


Task makeTask({
  String id = '',
  String title = 'Тестове завдання',
  String courseId = 'Математика',
  bool completed = false,
  TaskPriority priority = TaskPriority.medium,
  String authorId = 'user1',
  DateTime? deadline,
}) {
  return Task(
    id: id,
    title: title,
    courseId: courseId,
    deadline: deadline ?? DateTime.now().add(const Duration(days: 7)),
    priority: priority,
    completed: completed,
    authorId: authorId,
  );
}