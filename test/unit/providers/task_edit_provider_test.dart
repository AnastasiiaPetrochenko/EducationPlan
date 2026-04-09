import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/providers/task_edit_provider.dart';
// Зверни увагу на шлях до нашого хелпера з FakeTasksRepository!
import '../../helpers/test_helpers.dart';

void main() {
  late FakeTasksRepository fakeRepo;
  late TaskEditProvider provider;

  setUp(() {
    fakeRepo = FakeTasksRepository();
    provider = TaskEditProvider(fakeRepo);
  });

  group('TaskEditProvider — Валідація', () {
    test('початковий статус валідації - false (бо поля порожні)', () {
      expect(provider.isValid(), false);
    });

    test('validateTitle повертає помилку, якщо назва порожня', () {
      provider.setTitle('');
      expect(provider.validateTitle(), 'Назва завдання не може бути порожньою');
    });

    test('validateTitle повертає помилку, якщо назва коротша за 3 символи', () {
      provider.setTitle('АБ');
      expect(provider.validateTitle(), 'Назва занадто коротка');
    });

    test('validateTitle повертає null, якщо назва коректна', () {
      provider.setTitle('Зробити лабу');
      expect(provider.validateTitle(), isNull);
    });

    test('validateCourseId повертає помилку, якщо предмет не обрано', () {
      provider.setCourseId('');
      expect(provider.validateCourseId(), 'Виберіть предмет');
    });

    test('isValid повертає true, якщо всі поля заповнені правильно', () {
      provider.setTitle('Моє завдання');
      provider.setCourseId('course_1');
      expect(provider.isValid(), true);
    });
  });

  group('TaskEditProvider — Скидання (reset)', () {
    test('метод reset очищає всі поля до дефолтних', () {
      // Спочатку щось вводимо
      provider.setTitle('Тестова назва');
      provider.setCourseId('course_1');
      provider.setCompleted(true);
      
      // Скидаємо
      provider.reset();

      // Перевіряємо
      expect(provider.title, '');
      expect(provider.courseId, '');
      expect(provider.completed, false);
      expect(provider.status, TaskEditStatus.initial);
    });
  });
}