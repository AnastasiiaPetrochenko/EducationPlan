import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ui_lab_3/models/event.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Event.fromFirestore', () {
    test('правильно парсить тип "lecture"', () {
      final doc = FakeDocumentSnapshot('event1', {
        'courseId': 'c1',
        'name': 'Лекція з математики',
        'type': 'lecture',
        'start': Timestamp.fromDate(DateTime(2025, 6, 1, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 30)),
        'auditorium': '101',
        'authorId': 'user1',
        'priority': 1,
      });

      final event = Event.fromFirestore(doc);
      expect(event.type, EventType.lecture);
    });

    test('правильно парсить тип "exam"', () {
      final doc = FakeDocumentSnapshot('event2', {
        'courseId': 'c1',
        'name': 'Іспит',
        'type': 'exam',
        'start': Timestamp.fromDate(DateTime(2025, 6, 10, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 10, 11, 0)),
        'auditorium': '201',
        'authorId': 'user1',
        'priority': 3,
      });

      final event = Event.fromFirestore(doc);
      expect(event.type, EventType.exam);
    });

    test('невідомий тип → EventType.lecture (default)', () {
      final doc = FakeDocumentSnapshot('event3', {
        'courseId': 'c1',
        'name': 'Заняття',
        'type': 'unknown_type',
        'start': Timestamp.fromDate(DateTime(2025, 6, 1, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 0)),
        'authorId': 'user1',
      });

      final event = Event.fromFirestore(doc);
      expect(event.type, EventType.lecture);
    });

    test('відсутнє поле name → порожній рядок', () {
      final doc = FakeDocumentSnapshot('event4', {
        'courseId': 'c1',
        'type': 'lab',
        'start': Timestamp.fromDate(DateTime(2025, 6, 1, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 0)),
        'authorId': 'user1',
      });

      final event = Event.fromFirestore(doc);
      expect(event.name, '');
    });

    test('priority за замовчуванням 1 якщо не вказано', () {
      final doc = FakeDocumentSnapshot('event5', {
        'courseId': 'c1',
        'type': 'practical',
        'start': Timestamp.fromDate(DateTime(2025, 6, 1, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 0)),
        'authorId': 'user1',
      });

      final event = Event.fromFirestore(doc);
      expect(event.priority, 1);
    });

    test('кидає StateError якщо data == null', () {
      final doc = FakeDocumentSnapshot('event6', null);
      expect(() => Event.fromFirestore(doc), throwsStateError);
    });

    test('id береться з документа', () {
      final doc = FakeDocumentSnapshot('my_event_id', {
        'courseId': 'c1',
        'type': 'lecture',
        'start': Timestamp.fromDate(DateTime(2025, 6, 1, 9, 0)),
        'end': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 0)),
        'authorId': 'user1',
      });

      final event = Event.fromFirestore(doc);
      expect(event.id, 'my_event_id');
    });
  });

  group('Event.toFirestore', () {
    test('тип конвертується в рядок', () {
      final event = Event(
        id: 'e1',
        courseId: 'c1',
        name: 'Лекція',
        type: EventType.practical,
        startTime: DateTime(2025, 6, 1, 9, 0),
        endTime: DateTime(2025, 6, 1, 10, 30),
        authorId: 'user1',
      );

      final map = event.toFirestore();
      expect(map['type'], 'practical');
    });
  });

  group('Event.copyWith', () {
    test('copyWith змінює тільки вказані поля', () {
      final original = Event(
        id: 'e1',
        courseId: 'c1',
        name: 'Оригінал',
        type: EventType.lecture,
        startTime: DateTime(2025, 6, 1, 9, 0),
        endTime: DateTime(2025, 6, 1, 10, 30),
        authorId: 'user1',
      );

      final copy = original.copyWith(name: 'Нова назва', auditorium: '305');

      expect(copy.name, 'Нова назва');
      expect(copy.auditorium, '305');
      expect(copy.type, EventType.lecture);
      expect(copy.courseId, 'c1');
    });
  });
}