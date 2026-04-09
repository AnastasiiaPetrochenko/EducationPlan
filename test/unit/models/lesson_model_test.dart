 import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/models/lesson.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('Lesson.fromFirestore', () {
    test('правильно парсить всі поля', () {
      final doc = FakeDocumentSnapshot('lesson1', {
        'courseId': 1,
        'name': 'Математика',
        'teacher': 'Іванов І.І.',
        'color': '#FF0000',
        'semester': '2',
        'authorId': 'user1',
      });

      final lesson = Lesson.fromFirestore(doc);
      expect(lesson.id, 'lesson1');
      expect(lesson.courseId, 1);
      expect(lesson.name, 'Математика');
      expect(lesson.teacher, 'Іванов І.І.');
      expect(lesson.color, '#FF0000');
    });

    test('courseId як рядок конвертується в int', () {
      final doc = FakeDocumentSnapshot('lesson2', {
        'courseId': '42',
        'name': 'Фізика',
        'teacher': 'Петров П.П.',
        'authorId': 'user1',
      });

      final lesson = Lesson.fromFirestore(doc);
      expect(lesson.courseId, 42);
    });

    test('невалідний courseId → 0', () {
      final doc = FakeDocumentSnapshot('lesson3', {
        'courseId': 'abc',
        'name': 'Хімія',
        'teacher': 'Сидоров С.С.',
        'authorId': 'user1',
      });

      final lesson = Lesson.fromFirestore(doc);
      expect(lesson.courseId, 0);
    });

    test('відсутнє поле name → порожній рядок', () {
      final doc = FakeDocumentSnapshot('lesson4', {
        'courseId': 1,
        'teacher': 'Іванов І.І.',
        'authorId': 'user1',
      });

      final lesson = Lesson.fromFirestore(doc);
      expect(lesson.name, '');
    });

    test('необовязкові поля можуть бути null', () {
      final doc = FakeDocumentSnapshot('lesson5', {
        'courseId': 1,
        'name': 'Математика',
        'teacher': 'Іванов І.І.',
        'authorId': 'user1',
      });

      final lesson = Lesson.fromFirestore(doc);
      expect(lesson.color, isNull);
      expect(lesson.semester, isNull);
      expect(lesson.description, isNull);
      expect(lesson.teacherContact, isNull);
    });
  });

  group('Lesson.copyWith', () {
    test('copyWith змінює тільки вказані поля', () {
      final original = Lesson(
        id: 'l1',
        courseId: 1,
        name: 'Оригінал',
        teacher: 'Іванов',
        authorId: 'user1',
      );

      final copy = original.copyWith(name: 'Нова дисципліна', teacher: 'Петров');

      expect(copy.name, 'Нова дисципліна');
      expect(copy.teacher, 'Петров');
      expect(copy.courseId, 1);
      expect(copy.authorId, 'user1');
    });
  });
}