import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/models/task.dart';
import '../helpers/test_helpers.dart';
void main() {
  late FakeTasksRepository repo;

  setUp(() {
    repo = FakeTasksRepository();
  });

  tearDown(() {
    repo.dispose();
  });

  group('Інтеграція: додавання завдань', () {
    test('додане завдання зʼявляється в stream', () async {
      final task = makeTask(title: 'Нове завдання');
      await repo.addTask(task);

      final tasks = await repo.getTasksStream('user1').first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Нове завдання');
    });

    test('два завдання додаються коректно', () async {
      await repo.addTask(makeTask(title: 'Завдання 1'));
      await repo.addTask(makeTask(title: 'Завдання 2'));

      final tasks = await repo.getTasksStream('user1').first;
      expect(tasks.length, 2);
    });

    test('завдання різних користувачів не перетинаються', () async {
      await repo.addTask(makeTask(title: 'Завдання user1', authorId: 'user1'));
      await repo.addTask(makeTask(title: 'Завдання user2', authorId: 'user2'));

      final user1Tasks = await repo.getTasksStream('user1').first;
      final user2Tasks = await repo.getTasksStream('user2').first;

      expect(user1Tasks.length, 1);
      expect(user2Tasks.length, 1);
      expect(user1Tasks.first.title, 'Завдання user1');
      expect(user2Tasks.first.title, 'Завдання user2');
    });
  });


  group('Інтеграція: оновлення завдань', () {
    test('оновлення завдання змінює дані в stream', () async {
      await repo.addTask(makeTask(title: 'Стара назва'));
      final tasks = await repo.getTasksStream('user1').first;
      final taskId = tasks.first.id;

      await repo.updateTask(tasks.first.copyWith(title: 'Нова назва'));

      final updated = await repo.getTasksStream('user1').first;
      expect(updated.first.title, 'Нова назва');
      expect(updated.first.id, taskId);
    });

    test('позначення завдання як виконаного зберігається', () async {
      await repo.addTask(makeTask(completed: false));
      final tasks = await repo.getTasksStream('user1').first;

      await repo.updateTask(tasks.first.copyWith(completed: true));

      final updated = await repo.getTasksStream('user1').first;
      expect(updated.first.completed, true);
    });

    test('оновлення пріоритету зберігається коректно', () async {
      await repo.addTask(makeTask(priority: TaskPriority.low));
      final tasks = await repo.getTasksStream('user1').first;

      await repo.updateTask(
          tasks.first.copyWith(priority: TaskPriority.high));

      final updated = await repo.getTasksStream('user1').first;
      expect(updated.first.priority, TaskPriority.high);
    });
  });


  group('Інтеграція: видалення завдань', () {
    test('видалене завдання зникає зі stream', () async {
      await repo.addTask(makeTask(title: 'Для видалення'));
      final tasks = await repo.getTasksStream('user1').first;
      expect(tasks.length, 1);

      await repo.deleteTask(tasks.first.id);

      final afterDelete = await repo.getTasksStream('user1').first;
      expect(afterDelete.isEmpty, true);
    });

    test('видалення одного з двох завдань залишає інше', () async {
      await repo.addTask(makeTask(title: 'Залишити'));
      await repo.addTask(makeTask(title: 'Видалити'));

      final tasks = await repo.getTasksStream('user1').first;
      final toDelete = tasks.firstWhere((t) => t.title == 'Видалити');

      await repo.deleteTask(toDelete.id);

      final afterDelete = await repo.getTasksStream('user1').first;
      expect(afterDelete.length, 1);
      expect(afterDelete.first.title, 'Залишити');
    });
  });

  group('Інтеграція: getTaskById', () {
    test('getTaskById повертає правильне завдання', () async {
      await repo.addTask(makeTask(title: 'Знайди мене'));
      final tasks = await repo.getTasksStream('user1').first;
      final taskId = tasks.first.id;

      final found = await repo.getTaskById(taskId);
      expect(found, isNotNull);
      expect(found!.title, 'Знайди мене');
    });

    test('getTaskById повертає null якщо ID не існує', () async {
      final found = await repo.getTaskById('non_existing_id');
      expect(found, isNull);
    });
  });

  group('Інтеграція: повний CRUD цикл', () {
    test('створити → оновити → видалити', () async {
      // Створити
      await repo.addTask(makeTask(title: 'Початок'));
      var tasks = await repo.getTasksStream('user1').first;
      expect(tasks.length, 1);
      expect(tasks.first.title, 'Початок');

      // Оновити
      await repo.updateTask(tasks.first.copyWith(title: 'Оновлено'));
      tasks = await repo.getTasksStream('user1').first;
      expect(tasks.first.title, 'Оновлено');

      // Видалити
      await repo.deleteTask(tasks.first.id);
      tasks = await repo.getTasksStream('user1').first;
      expect(tasks.isEmpty, true);
    });
  });
}
