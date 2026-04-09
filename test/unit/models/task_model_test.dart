import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ui_lab_3/models/task.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Task.fromFirestore', () {
    test('пріоритет 3 → TaskPriority.high', () {
      final doc = FakeDocumentSnapshot('task1', {
        'title': 'Здати лабораторну',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 3,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.priority, TaskPriority.high);
    });

    test('пріоритет 2 → TaskPriority.medium', () {
      final doc = FakeDocumentSnapshot('task2', {
        'title': 'Підготовка до іспиту',
        'courseId': 'course2',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 10)),
        'priority': 2,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.priority, TaskPriority.medium);
    });

    test('пріоритет 1 → TaskPriority.low', () {
      final doc = FakeDocumentSnapshot('task3', {
        'title': 'Прочитати книгу',
        'courseId': 'course3',
        'deadline': Timestamp.fromDate(DateTime(2025, 7, 1)),
        'priority': 1,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.priority, TaskPriority.low);
    });

    test('невідомий пріоритет → TaskPriority.medium (default)', () {
      final doc = FakeDocumentSnapshot('task4', {
        'title': 'Завдання',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 99,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.priority, TaskPriority.medium);
    });

    test('відсутнє поле title → порожній рядок', () {
      final doc = FakeDocumentSnapshot('task5', {
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 2,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.title, '');
    });

    test('поле subjectId використовується якщо немає courseId', () {
      final doc = FakeDocumentSnapshot('task6', {
        'title': 'Завдання',
        'subjectId': 'subject_abc',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 2,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.courseId, 'subject_abc');
    });

    test('completed за замовчуванням false', () {
      final doc = FakeDocumentSnapshot('task7', {
        'title': 'Завдання',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 2,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.completed, false);
    });

    test('пріоритет як рядок "high" → TaskPriority.high', () {
      final doc = FakeDocumentSnapshot('task8', {
        'title': 'Завдання',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 'high',
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.priority, TaskPriority.high);
    });

    test('attachmentUrls правильно парситься як список', () {
      final doc = FakeDocumentSnapshot('task9', {
        'title': 'Завдання',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 2,
        'completed': false,
        'authorId': 'user1',
        'attachmentUrls': ['url1', 'url2'],
      });

      final task = Task.fromFirestore(doc);
      expect(task.attachmentUrls, ['url1', 'url2']);
    });

    test('id береться з документа', () {
      final doc = FakeDocumentSnapshot('my_task_id', {
        'title': 'Завдання',
        'courseId': 'course1',
        'deadline': Timestamp.fromDate(DateTime(2025, 6, 1)),
        'priority': 2,
        'completed': false,
        'authorId': 'user1',
      });

      final task = Task.fromFirestore(doc);
      expect(task.id, 'my_task_id');
    });
  });

  group('Task.toFirestore', () {
    test('пріоритет high → число 3', () {
      final task = Task(
        id: 't1',
        title: 'Тест',
        courseId: 'c1',
        deadline: DateTime(2025, 6, 1),
        priority: TaskPriority.high,
        authorId: 'user1',
      );

      final map = task.toFirestore();
      expect(map['priority'], 3);
    });

    test('pріоритет low → число 1', () {
      final task = Task(
        id: 't2',
        title: 'Тест',
        courseId: 'c1',
        deadline: DateTime(2025, 6, 1),
        priority: TaskPriority.low,
        authorId: 'user1',
      );

      final map = task.toFirestore();
      expect(map['priority'], 1);
    });

    test('toFirestore містить всі обовязкові поля', () {
      final task = Task(
        id: 't3',
        title: 'Моє завдання',
        courseId: 'c1',
        deadline: DateTime(2025, 6, 1),
        priority: TaskPriority.medium,
        authorId: 'user1',
      );

      final map = task.toFirestore();
      expect(map.containsKey('title'), true);
      expect(map.containsKey('courseId'), true);
      expect(map.containsKey('deadline'), true);
      expect(map.containsKey('priority'), true);
      expect(map.containsKey('completed'), true);
      expect(map.containsKey('authorId'), true);
    });
  });

  group('Task.copyWith', () {
    test('copyWith змінює тільки вказані поля', () {
      final original = Task(
        id: 't1',
        title: 'Оригінал',
        courseId: 'c1',
        deadline: DateTime(2025, 6, 1),
        priority: TaskPriority.low,
        authorId: 'user1',
      );

      final copy = original.copyWith(title: 'Копія', completed: true);

      expect(copy.title, 'Копія');
      expect(copy.completed, true);
      expect(copy.courseId, 'c1');
      expect(copy.priority, TaskPriority.low);
    });
  });
}