// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Навчальний план';

  @override
  String get tasks => 'Завдання';

  @override
  String get schedule => 'Розклад';

  @override
  String get profile => 'Профіль';

  @override
  String get login => 'Увійти';

  @override
  String get register => 'Зареєструватися';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get noAccount => 'Немає акаунту?';

  @override
  String get signInWithGoogle => 'Увійти через Google';

  @override
  String get myTasks => 'Мої завдання';

  @override
  String get activeTasks => 'Активні завдання';

  @override
  String get completedTasks => 'Виконані';

  @override
  String get urgentTasks => 'Терміново';

  @override
  String get noTasks => 'Немає завдань';

  @override
  String get addTaskHint => 'Натисніть + щоб додати нове завдання';

  @override
  String get weekSchedule => 'Розклад на тиждень';

  @override
  String get noSchedule => 'Немає пар у розкладі';

  @override
  String get settings => 'Налаштування';

  @override
  String get logout => 'Вийти';

  @override
  String get lightTheme => 'Світла';

  @override
  String get darkTheme => 'Темна';

  @override
  String get systemTheme => 'Системна';

  @override
  String get language => 'Мова';

  @override
  String get theme => 'Тема';

  @override
  String get taskDetails => 'Деталі завдання';

  @override
  String get lessonDetails => 'Деталі заняття';

  @override
  String get newTask => 'Нове завдання';

  @override
  String get editTask => 'Редагувати завдання';

  @override
  String get deleteTask => 'Видалити завдання';

  @override
  String get deleteTaskConfirm => 'Цю дію неможливо скасувати.';

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get priorityHigh => 'Високий';

  @override
  String get priorityMedium => 'Середній';

  @override
  String get priorityLow => 'Низький';

  @override
  String get deadline => 'Дедлайн';

  @override
  String get priority => 'Пріоритет';

  @override
  String get subject => 'Предмет';

  @override
  String get description => 'Опис';

  @override
  String get notes => 'Нотатки';

  @override
  String get statusCompleted => 'Виконано';

  @override
  String get statusActive => 'Активне';

  @override
  String get filterAll => 'Всі';

  @override
  String get filterActive => 'Активні';

  @override
  String get filterCompleted => 'Виконані';

  @override
  String get sortByDeadline => 'За дедлайном';

  @override
  String get sortByPriority => 'За пріоритетом';

  @override
  String get sortBySubject => 'За предметом';

  @override
  String get taskCreated => 'Завдання створено';

  @override
  String get taskUpdated => 'Завдання оновлено';

  @override
  String get taskDeleted => 'Завдання видалено';

  @override
  String get errorLoading => 'Помилка завантаження';

  @override
  String get tryAgain => 'Спробувати знову';

  @override
  String get dashboard => 'Головна';

  @override
  String get newLesson => 'Нова пара';

  @override
  String get editLesson => 'Редагувати пару';

  @override
  String get disciplines => 'Дисципліни';

  @override
  String get myDisciplines => 'Мої дисципліни';

  @override
  String get manageDisciplines => 'Керування дисциплінами';

  @override
  String get newDiscipline => 'Нова дисципліна';

  @override
  String get editDiscipline => 'Редагувати дисципліну';

  @override
  String get noDisciplines => 'Немає дисциплін';

  @override
  String get addDisciplineHint => 'Натисніть + щоб додати';

  @override
  String overdue(int days) {
    return 'Прострочено на $days дн.';
  }

  @override
  String daysLeft(int days) {
    return 'Залишилось $days дн.';
  }

  @override
  String get myDisciplinesTitle => 'Мої дисципліни';

  @override
  String get newDisciplineTitle => 'Нова дисципліна';

  @override
  String get editDisciplineTitle => 'Редагувати дисципліну';

  @override
  String get noDisciplinesMsg => 'Немає дисциплін';

  @override
  String get addDisciplineMessage => 'Натисніть + щоб додати';

  @override
  String get disciplineNameLabel => 'Назва *';

  @override
  String get disciplineTeacherLabel => 'Викладач';

  @override
  String get addButtonLabel => 'Додати';

  @override
  String get saveButtonLabel => 'Зберегти';

  @override
  String get editButtonLabel => 'Редагувати';

  @override
  String get deleteButtonLabel => 'Видалити';

  @override
  String get cancelButtonLabel => 'Скасувати';

  @override
  String get deletedMessage => 'Дисципліну видалено';

  @override
  String errorMessage(String error) {
    return 'Помилка: $error';
  }

  @override
  String get deleteConfirmTitle => 'Видалити?';

  @override
  String deleteConfirmMessage(String name) {
    return 'Видалити \"$name\"?';
  }

  @override
  String get newEventTitle => 'Нова пара';

  @override
  String get editEventTitle => 'Редагувати пару';

  @override
  String get eventNameLabel => 'Назва предмета *';

  @override
  String get eventCodeLabel => 'Код предмета (наприклад CS-101)';

  @override
  String get eventTypeLabel => 'Тип заняття';

  @override
  String get eventStartTimeLabel => 'Початок';

  @override
  String get eventEndTimeLabel => 'Закінчення';

  @override
  String get eventAuditoriumLabel => 'Аудиторія';

  @override
  String get eventPriorityLabel => 'Пріоритет';

  @override
  String get eventLowPriority => 'Низький';

  @override
  String get eventMediumPriority => 'Середній';

  @override
  String get eventHighPriority => 'Високий';

  @override
  String get eventAddButton => 'Додати пару';

  @override
  String get eventSaveButton => 'Зберегти зміни';

  @override
  String get eventDeleteConfirm => 'Видалити пару?';

  @override
  String get eventDeleteConfirmText => 'Цю дію неможливо скасувати.';

  @override
  String get eventAddedMessage => 'Пару додано';

  @override
  String get eventUpdatedMessage => 'Пару оновлено';

  @override
  String get eventDeletedMessage => 'Пару видалено';

  @override
  String get eventEndTimeError => 'Час закінчення має бути після початку';

  @override
  String get newTaskTitle => 'Нове завдання';

  @override
  String get editTaskTitle => 'Редагувати завдання';

  @override
  String get taskNameLabel => 'Назва завдання *';

  @override
  String get taskSubjectLabel => 'Предмет *';

  @override
  String get taskSubjectHint => 'Виберіть або введіть предмет';

  @override
  String get taskDeadlineLabel => 'Дедлайн';

  @override
  String get taskPriorityLabel => 'Пріоритет';

  @override
  String get taskDescriptionLabel => 'Опис (необов\'язково)';

  @override
  String get taskNotesLabel => 'Нотатки (необов\'язково)';

  @override
  String get taskCompleted => 'Завдання виконано';

  @override
  String get taskCreateButton => 'Створити завдання';

  @override
  String get taskSaveButton => 'Зберегти зміни';

  @override
  String get taskDeleteConfirm => 'Видалити завдання?';

  @override
  String get taskDeleteConfirmText => 'Цю дію неможливо скасувати.';

  @override
  String get taskAddedMessage => 'Завдання створено';

  @override
  String get taskUpdatedMessage => 'Завдання оновлено';

  @override
  String get taskDeletedMessage => 'Завдання видалено';

  @override
  String get goodMorning => 'Доброго ранку';

  @override
  String get goodAfternoon => 'Доброго дня';

  @override
  String get goodEvening => 'Доброго вечора';

  @override
  String get classesToday => 'Пар сьогодні';

  @override
  String get nextClass => 'Наступне заняття';

  @override
  String get upcomingDeadlines => 'Найближчі дедлайни';

  @override
  String get allTasks => 'Всі';

  @override
  String get allTasksCompleted => 'Всі завдання виконано!';

  @override
  String get mondayName => 'Понеділок';

  @override
  String get tuesdayName => 'Вівторок';

  @override
  String get wednesdayName => 'Середа';

  @override
  String get thursdayName => 'Четвер';

  @override
  String get fridayName => 'П\'ятниця';

  @override
  String get saturdayName => 'Субота';

  @override
  String get sundayName => 'Неділя';

  @override
  String get januaryName => 'січня';

  @override
  String get februaryName => 'лютого';

  @override
  String get marchName => 'березня';

  @override
  String get aprilName => 'квітня';

  @override
  String get mayName => 'травня';

  @override
  String get juneName => 'червня';

  @override
  String get julyName => 'липня';

  @override
  String get augustName => 'серпня';

  @override
  String get septemberName => 'вересня';

  @override
  String get octoberName => 'жовтня';

  @override
  String get novemberName => 'листопада';

  @override
  String get decemberName => 'грудня';

  @override
  String get selectSubject => 'Виберіть предмет';
}
