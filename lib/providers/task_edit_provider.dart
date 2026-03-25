import 'package:flutter/foundation.dart';
import 'package:ui_lab_3/services/notification_service.dart';
import '../models/task.dart';
import '../repositories/tasks_repository.dart';

// Стани для створення/редагування завдання
enum TaskEditStatus { initial, saving, success, error }

class TaskEditProvider with ChangeNotifier {
  final TasksRepository _repository;
  final NotificationService _notificationService = NotificationService();

  TaskEditStatus _status = TaskEditStatus.initial;
  String? _errorMessage;

  // Поля форми
  String _title = '';
  String _courseId = '';
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  TaskPriority _priority = TaskPriority.medium;
  bool _completed = false;
  String _description = '';
  String _notes = '';
  String _authorId = '';

  TaskEditProvider(this._repository);

  // Getters
  TaskEditStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get title => _title;
  String get courseId => _courseId;
  DateTime get deadline => _deadline;
  TaskPriority get priority => _priority;
  bool get completed => _completed;
  String get description => _description;
  String get notes => _notes;

  // Setters
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setCourseId(String value) {
    _courseId = value;
    notifyListeners();
  }

  void setDeadline(DateTime value) {
    _deadline = value;
    notifyListeners();
  }

  void setPriority(TaskPriority value) {
    _priority = value;
    notifyListeners();
  }

  void setCompleted(bool value) {
    _completed = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  void setAuthorId(String value) {
    _authorId = value;
  }

  // Завантаження існуючого завдання для редагування
  void loadTask(Task task) {
    _title = task.title;
    _courseId = task.courseId;
    _deadline = task.deadline;
    _priority = task.priority;
    _completed = task.completed;
    _description = task.description ?? '';
    _notes = task.notes ?? '';
    _authorId = task.authorId;
    _status = TaskEditStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _title = '';
    _courseId = '';
    _deadline = DateTime.now().add(const Duration(days: 7));
    _priority = TaskPriority.medium;
    _completed = false;
    _description = '';
    _notes = '';
    _status = TaskEditStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  String? validateTitle() {
    if (_title.trim().isEmpty) {
      return 'Назва завдання не може бути порожньою';
    }
    if (_title.length < 3) {
      return 'Назва занадто коротка';
    }
    return null;
  }

  String? validateCourseId() {
    if (_courseId.trim().isEmpty) {
      return 'Виберіть предмет';
    }
    return null;
  }

  bool isValid() {
    return validateTitle() == null && validateCourseId() == null;
  }

  Future<bool> createTask() async {
    if (!isValid()) {
      _errorMessage = 'Заповніть всі обов\'язкові поля';
      _status = TaskEditStatus.error;
      notifyListeners();
      return false;
    }

    _status = TaskEditStatus.saving;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTask = Task(
        id: '', // згенеровано Firestore
        title: _title.trim(),
        courseId: _courseId,
        deadline: _deadline,
        priority: _priority,
        completed: _completed,
        description: _description.trim().isEmpty ? null : _description.trim(),
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
        authorId: _authorId,
      );

      await _repository.addTask(newTask);

      if (deadline.isAfter(DateTime.now())) {
        _notificationService.scheduleNotification(
          newTask.hashCode,
          'Нагадування про дедлайн',
          'Завтра дедлайн для завдання: $title',
          DateTime.now().add(const Duration(seconds: 10)),
        );
      }

      _status = TaskEditStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = TaskEditStatus.error;
      _errorMessage = 'Помилка створення завдання: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(String taskId) async {
    if (!isValid()) {
      _errorMessage = 'Заповніть всі обов\'язкові поля';
      _status = TaskEditStatus.error;
      notifyListeners();
      return false;
    }

    _status = TaskEditStatus.saving;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTask = Task(
        id: taskId,
        title: _title.trim(),
        courseId: _courseId,
        deadline: _deadline,
        priority: _priority,
        completed: _completed,
        description: _description.trim().isEmpty ? null : _description.trim(),
        notes: _notes.trim().isEmpty ? null : _notes.trim(),
        authorId: _authorId,
      );

      await _repository.updateTask(updatedTask);
      if (deadline.isAfter(DateTime.now())) {
        _notificationService.scheduleNotification(
          updatedTask.hashCode,
          'Нагадування про дедлайн',
          'Завтра дедлайн для завдання: $title',
          deadline.subtract(const Duration(days: 1)),
        );
      }

      _status = TaskEditStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = TaskEditStatus.error;
      _errorMessage = 'Помилка оновлення завдання: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    _status = TaskEditStatus.saving;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteTask(taskId);

      _status = TaskEditStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = TaskEditStatus.error;
      _errorMessage = 'Помилка видалення завдання: $e';
      notifyListeners();
      return false;
    }
  }
}