import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event.dart';
import '../repositories/schedule_repository.dart';

enum ScheduleStatus { initial, loading, loaded, error }

class ScheduleProvider with ChangeNotifier {
  final ScheduleRepository _repository;
  StreamSubscription<User?>? _authSubscription;

  List<Event> _events = [];
  ScheduleStatus _status = ScheduleStatus.initial;
  String _errorMessage = '';

  ScheduleProvider(this._repository) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        loadSchedule();
      } else {
        _events = [];
        _status = ScheduleStatus.initial;
        _errorMessage = '';
        notifyListeners();
      }
    });
  }

  List<Event> get events => _events;
  ScheduleStatus get status => _status;
  String get errorMessage => _errorMessage;

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> loadSchedule() async {
    _status = ScheduleStatus.loading;
    notifyListeners();

    try {
      final all = await _repository.getEvents();
      _events = all
          .where((e) => e.authorId == _currentUserId)
          .toList();
      _status = ScheduleStatus.loaded;
      _errorMessage = '';
    } catch (e) {
      _status = ScheduleStatus.error;
      _errorMessage = 'Помилка завантаження розкладу: $e';
    }
    notifyListeners();
  }

  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Event> getEventsByCourse(String courseId) {
    return _events.where((event) => event.courseId == courseId).toList();
  }

  List<Event> getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList();
  }

  Future<void> addEvent(Event event) async {
    try {
      await _repository.addEvent(event);
      await loadSchedule();
    } catch (e) {
      _errorMessage = 'Помилка додавання події: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _repository.updateEvent(event);
      await loadSchedule();
    } catch (e) {
      _errorMessage = 'Помилка оновлення події: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _repository.deleteEvent(id);
      _events.removeWhere((event) => event.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Помилка видалення події: $e';
      notifyListeners();
      rethrow;
    }
  }

  List<Event> filterByType(EventType type) {
    return _events.where((event) => event.type == type).toList();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}