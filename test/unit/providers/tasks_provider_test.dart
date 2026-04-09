import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_lab_3/models/task.dart';
import 'package:ui_lab_3/providers/tasks_provider.dart';
import 'package:ui_lab_3/repositories/tasks_repository.dart';
import '../../helpers/test_helpers.dart'; 


class TestableTasksProvider extends ChangeNotifier {
  final TasksRepository _repo;
  StreamSubscription<List<Task>>? _sub;

  List<Task> _allTasks = [];
  TasksStatus _status = TasksStatus.initial;
  String? _errorMessage;
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.deadline;

  TestableTasksProvider(this._repo);

  List<Task> get tasks => _getFilteredAndSortedTasks();
  TasksStatus get status => _status;
  String? get errorMessage => _errorMessage;
  TaskFilter get currentFilter => _filter;

  int get activeTasks => _allTasks.where((t) => !t.completed).length;
  int get completedTasks => _allTasks.where((t) => t.completed).length;
  int get urgentTasks => _allTasks
      .where((t) =>
          !t.completed &&
          t.priority == TaskPriority.high &&
          t.deadline.difference(DateTime.now()).inDays <= 3)
      .length;

  void subscribeToUser(String userId) {
    _status = TasksStatus.loading;
    _allTasks = [];
    notifyListeners();

    _sub?.cancel();
    _sub = _repo.getTasksStream(userId).listen(
      (tasks) {
        _allTasks = tasks;
        _status = TasksStatus.loaded;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _status = TasksStatus.error;
        _errorMessage = 'Помилка: $error';
        notifyListeners();
      },
    );
  }

  void logout() {
    _sub?.cancel();
    _allTasks = [];
    _status = TasksStatus.initial;
    notifyListeners();
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
        const order = {
          TaskPriority.high: 0,
          TaskPriority.medium: 1,
          TaskPriority.low: 2,
        };
        filtered.sort(
            (a, b) => order[a.priority]!.compareTo(order[b.priority]!));
        break;
      case TaskSort.subject:
        filtered.sort((a, b) => a.courseId.compareTo(b.courseId));
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

void main() {
  late FakeTasksRepository fakeRepo;
  late TestableTasksProvider provider;

  setUp(() {
    fakeRepo = FakeTasksRepository();
    provider = TestableTasksProvider(fakeRepo);
  });

  tearDown(() {
    provider.dispose();
    fakeRepo.dispose();
  });

  group('TasksProvider — статус', () {
    test('початковий статус — initial', () {
      expect(provider.status, TasksStatus.initial);
    });

    test('після підписки статус спочатку loading, потім loaded', () async {
      provider.subscribeToUser('user1');
      expect(provider.status, TasksStatus.loading);

      fakeRepo.seedTasks([]);
      await Future.delayed(Duration.zero);

      expect(provider.status, TasksStatus.loaded);
    });

    test('після logout статус — initial і список порожній', () async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([makeTask(id: 't1', title: 'Завдання')]);
      await Future.delayed(Duration.zero);

      provider.logout();

      expect(provider.status, TasksStatus.initial);
      expect(provider.tasks, isEmpty);
    });

    test('помилка стріму → статус error і errorMessage не null', () async {
      provider.subscribeToUser('user1');
      await Future.delayed(Duration.zero);
      fakeRepo.emitError(Exception('Помилка мережі'));
      await Future.delayed(Duration.zero);

      expect(provider.status, TasksStatus.error);
      expect(provider.errorMessage, isNotNull);
      expect(provider.errorMessage, contains('Помилка'));
    });
  });


  group('TasksProvider — фільтрація', () {
    setUp(() async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([
        makeTask(id: 't1', title: 'Активне 1', completed: false),
        makeTask(id: 't2', title: 'Виконане',  completed: true),
        makeTask(id: 't3', title: 'Активне 2', completed: false),
      ]);
      await Future.delayed(Duration.zero);
    });

    test('фільтр all → повертає всі 3 завдання', () {
      provider.setFilter(TaskFilter.all);
      expect(provider.tasks.length, 3);
    });

    test('фільтр active → тільки невиконані', () {
      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.length, 2);
      expect(provider.tasks.every((t) => !t.completed), true);
    });

    test('фільтр completed → тільки виконані', () {
      provider.setFilter(TaskFilter.completed);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.completed, true);
    });
  });

  group('TasksProvider — сортування', () {
    setUp(() async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([
        makeTask(
          id: 't1',
          title: 'Пізній дедлайн',
          deadline: DateTime.now().add(const Duration(days: 10)),
          priority: TaskPriority.low,
          courseId: 'z_course',
        ),
        makeTask(
          id: 't2',
          title: 'Ранній дедлайн',
          deadline: DateTime.now().add(const Duration(days: 1)),
          priority: TaskPriority.high,
          courseId: 'a_course',
        ),
      ]);
      await Future.delayed(Duration.zero);
    });

    test('сортування за дедлайном — найближчий перший', () {
      provider.setSort(TaskSort.deadline);
      expect(provider.tasks.first.id, 't2');
    });

    test('сортування за пріоритетом — high перший', () {
      provider.setSort(TaskSort.priority);
      expect(provider.tasks.first.priority, TaskPriority.high);
    });

    test('сортування за предметом — алфавітний порядок', () {
      provider.setSort(TaskSort.subject);
      expect(provider.tasks.first.courseId, 'a_course');
    });
  });

  group('TasksProvider — лічильники', () {
    test('activeTasks та completedTasks рахують правильно', () async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([
        makeTask(id: 't1', title: 'А', completed: false),
        makeTask(id: 't2', title: 'Б', completed: true),
        makeTask(id: 't3', title: 'В', completed: false),
      ]);
      await Future.delayed(Duration.zero);

      expect(provider.activeTasks, 2);
      expect(provider.completedTasks, 1);
    });

    test('urgentTasks — high priority і дедлайн ≤ 3 дні', () async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([
        makeTask(
          id: 't1',
          title: 'Термінове',
          priority: TaskPriority.high,
          deadline: DateTime.now().add(const Duration(days: 2)),
        ),
        makeTask(
          id: 't2',
          title: 'Не скоро',
          priority: TaskPriority.high,
          deadline: DateTime.now().add(const Duration(days: 10)),
        ),
        makeTask(
          id: 't3',
          title: 'Low priority але скоро',
          priority: TaskPriority.low,
          deadline: DateTime.now().add(const Duration(days: 1)),
        ),
      ]);
      await Future.delayed(Duration.zero);

      expect(provider.urgentTasks, 1);
    });

    test('urgentTasks не рахує виконані завдання', () async {
      provider.subscribeToUser('user1');
      fakeRepo.seedTasks([
        makeTask(
          id: 't1',
          title: 'Виконане термінове',
          priority: TaskPriority.high,
          deadline: DateTime.now().add(const Duration(days: 1)),
          completed: true,
        ),
      ]);
      await Future.delayed(Duration.zero);

      expect(provider.urgentTasks, 0);
    });
  });
}