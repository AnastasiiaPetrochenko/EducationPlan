import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

abstract class ScheduleRepository {
  Future<List<Event>> getEvents();
  Future<void> addEvent(Event event);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String id);
  Stream<List<Event>> eventsStream();
  Future<List<Event>> getEventsByCourse(String courseId);
  Future<List<Event>> getEventsForDate(DateTime date);
}

class FirestoreScheduleRepository implements ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'schedule';

  @override
  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Помилка завантаження розкладу: $e');
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection(_collectionName).add(event.toFirestore());
    } catch (e) {
      throw Exception('Помилка додавання події: $e');
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(event.id)
          .update(event.toFirestore());
    } catch (e) {
      throw Exception('Помилка оновлення події: $e');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Помилка видалення події: $e');
    }
  }

  @override
  Stream<List<Event>> eventsStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('start', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());
  }

  @override
  Future<List<Event>> getEventsByCourse(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('courseId', isEqualTo: courseId)
          .get();
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Помилка завантаження подій курсу: $e');
    }
  }

  @override
  Future<List<Event>> getEventsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('start',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('start', isLessThan: Timestamp.fromDate(endOfDay))
          .get();
      return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Помилка завантаження подій на дату: $e');
    }
  }
}