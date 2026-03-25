import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/tasks_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum TasksStatus { initial, loading, loaded, error }
enum TaskFilter { all, active, completed }
enum TaskSort { deadline, priority, subject }

class TasksProvider with ChangeNotifier {
  final TasksRepository _tasksRepository;
  StreamSubscription<List<Task>>? _tasksSubscription;
  StreamSubscription<User?>? _authSubscription;

  List<Task> _allTasks = [];
  TasksStatus _status = TasksStatus.loading;
  String? _errorMessage;
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.deadline;

  TasksProvider(this._tasksRepository) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToTasks(user.uid);
      } else {
        _tasksSubscription?.cancel();
        _allTasks = [];
        _status = TasksStatus.initial;
        notifyListeners();
      }
    });
  }

  List<Task> get tasks => _getFilteredAndSortedTasks();
  TasksStatus get status => _status;
  String? get errorMessage => _errorMessage;
  TaskFilter get currentFilter => _filter;
  TaskSort get currentSort => _sort;

  int get activeTasks => _allTasks.where((t) => !t.completed).length;
  int get completedTasks => _allTasks.where((t) => t.completed).length;
  int get urgentTasks => _allTasks
      .where((t) =>
          !t.completed &&
          t.priority == TaskPriority.high &&
          t.deadline.difference(DateTime.now()).inDays <= 3)
      .length;

  void _subscribeToTasks(String userId) {
    _status = TasksStatus.loading;
    _allTasks = [];
    notifyListeners();

    _tasksSubscription?.cancel();
    _tasksSubscription =
        _tasksRepository.getTasksStream(userId).listen(
      (tasksList) {
        _allTasks = tasksList;
        _status = TasksStatus.loaded;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _status = TasksStatus.error;
        _errorMessage = 'Помилка завантаження завдань: $error';
        notifyListeners();
      },
    );
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSort(TaskSort sort) {
    _sort = sort;
    notifyListeners();
  }

  List<Task> _getFilteredAndSortedTasks() {
    List<Task> filtered = List.from(_allTasks);

    switch (_filter) {
      case TaskFilter.active:
        filtered = filtered.where((t) => !t.completed).toList();
        break;
      case TaskFilter.completed:
        filtered = filtered.where((t) => t.completed).toList();
        break;
      case TaskFilter.all:
        break;
    }

    switch (_sort) {
      case TaskSort.deadline:
        filtered.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case TaskSort.priority:
        const priorityOrder = {
          TaskPriority.high: 0,
          TaskPriority.medium: 1,
          TaskPriority.low: 2,
        };
        filtered.sort((a, b) =>
            priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
        break;
      case TaskSort.subject:
        filtered.sort((a, b) => a.courseId.compareTo(b.courseId));
        break;
    }

    return filtered;
  }

  Future<void> toggleTaskCompleted(String taskId) async {
    final taskToUpdate = _allTasks.firstWhere((t) => t.id == taskId);
    final updatedTask =
        taskToUpdate.copyWith(completed: !taskToUpdate.completed);
    await _tasksRepository.updateTask(updatedTask);
  }

  Task? getTaskById(String id) {
    try {
      return _allTasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}