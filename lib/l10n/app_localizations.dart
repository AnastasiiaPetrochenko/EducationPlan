import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In uk, this message translates to:
  /// **'Навчальний план'**
  String get appTitle;

  /// No description provided for @tasks.
  ///
  /// In uk, this message translates to:
  /// **'Завдання'**
  String get tasks;

  /// No description provided for @schedule.
  ///
  /// In uk, this message translates to:
  /// **'Розклад'**
  String get schedule;

  /// No description provided for @profile.
  ///
  /// In uk, this message translates to:
  /// **'Профіль'**
  String get profile;

  /// No description provided for @login.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get login;

  /// No description provided for @register.
  ///
  /// In uk, this message translates to:
  /// **'Зареєструватися'**
  String get register;

  /// No description provided for @email.
  ///
  /// In uk, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In uk, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In uk, this message translates to:
  /// **'Забули пароль?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In uk, this message translates to:
  /// **'Немає акаунту?'**
  String get noAccount;

  /// No description provided for @signInWithGoogle.
  ///
  /// In uk, this message translates to:
  /// **'Увійти через Google'**
  String get signInWithGoogle;

  /// No description provided for @myTasks.
  ///
  /// In uk, this message translates to:
  /// **'Мої завдання'**
  String get myTasks;

  /// No description provided for @activeTasks.
  ///
  /// In uk, this message translates to:
  /// **'Активні завдання'**
  String get activeTasks;

  /// No description provided for @completedTasks.
  ///
  /// In uk, this message translates to:
  /// **'Виконані'**
  String get completedTasks;

  /// No description provided for @urgentTasks.
  ///
  /// In uk, this message translates to:
  /// **'Терміново'**
  String get urgentTasks;

  /// No description provided for @noTasks.
  ///
  /// In uk, this message translates to:
  /// **'Немає завдань'**
  String get noTasks;

  /// No description provided for @addTaskHint.
  ///
  /// In uk, this message translates to:
  /// **'Натисніть + щоб додати нове завдання'**
  String get addTaskHint;

  /// No description provided for @weekSchedule.
  ///
  /// In uk, this message translates to:
  /// **'Розклад на тиждень'**
  String get weekSchedule;

  /// No description provided for @noSchedule.
  ///
  /// In uk, this message translates to:
  /// **'Немає пар у розкладі'**
  String get noSchedule;

  /// No description provided for @settings.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get logout;

  /// No description provided for @lightTheme.
  ///
  /// In uk, this message translates to:
  /// **'Світла'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In uk, this message translates to:
  /// **'Темна'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In uk, this message translates to:
  /// **'Системна'**
  String get systemTheme;

  /// No description provided for @language.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In uk, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @taskDetails.
  ///
  /// In uk, this message translates to:
  /// **'Деталі завдання'**
  String get taskDetails;

  /// No description provided for @lessonDetails.
  ///
  /// In uk, this message translates to:
  /// **'Деталі заняття'**
  String get lessonDetails;

  /// No description provided for @newTask.
  ///
  /// In uk, this message translates to:
  /// **'Нове завдання'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати завдання'**
  String get editTask;

  /// No description provided for @deleteTask.
  ///
  /// In uk, this message translates to:
  /// **'Видалити завдання'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Цю дію неможливо скасувати.'**
  String get deleteTaskConfirm;

  /// No description provided for @save.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get delete;

  /// No description provided for @priorityHigh.
  ///
  /// In uk, this message translates to:
  /// **'Високий'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In uk, this message translates to:
  /// **'Середній'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In uk, this message translates to:
  /// **'Низький'**
  String get priorityLow;

  /// No description provided for @deadline.
  ///
  /// In uk, this message translates to:
  /// **'Дедлайн'**
  String get deadline;

  /// No description provided for @priority.
  ///
  /// In uk, this message translates to:
  /// **'Пріоритет'**
  String get priority;

  /// No description provided for @subject.
  ///
  /// In uk, this message translates to:
  /// **'Предмет'**
  String get subject;

  /// No description provided for @description.
  ///
  /// In uk, this message translates to:
  /// **'Опис'**
  String get description;

  /// No description provided for @notes.
  ///
  /// In uk, this message translates to:
  /// **'Нотатки'**
  String get notes;

  /// No description provided for @statusCompleted.
  ///
  /// In uk, this message translates to:
  /// **'Виконано'**
  String get statusCompleted;

  /// No description provided for @statusActive.
  ///
  /// In uk, this message translates to:
  /// **'Активне'**
  String get statusActive;

  /// No description provided for @filterAll.
  ///
  /// In uk, this message translates to:
  /// **'Всі'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In uk, this message translates to:
  /// **'Активні'**
  String get filterActive;

  /// No description provided for @filterCompleted.
  ///
  /// In uk, this message translates to:
  /// **'Виконані'**
  String get filterCompleted;

  /// No description provided for @sortByDeadline.
  ///
  /// In uk, this message translates to:
  /// **'За дедлайном'**
  String get sortByDeadline;

  /// No description provided for @sortByPriority.
  ///
  /// In uk, this message translates to:
  /// **'За пріоритетом'**
  String get sortByPriority;

  /// No description provided for @sortBySubject.
  ///
  /// In uk, this message translates to:
  /// **'За предметом'**
  String get sortBySubject;

  /// No description provided for @taskCreated.
  ///
  /// In uk, this message translates to:
  /// **'Завдання створено'**
  String get taskCreated;

  /// No description provided for @taskUpdated.
  ///
  /// In uk, this message translates to:
  /// **'Завдання оновлено'**
  String get taskUpdated;

  /// No description provided for @taskDeleted.
  ///
  /// In uk, this message translates to:
  /// **'Завдання видалено'**
  String get taskDeleted;

  /// No description provided for @errorLoading.
  ///
  /// In uk, this message translates to:
  /// **'Помилка завантаження'**
  String get errorLoading;

  /// No description provided for @tryAgain.
  ///
  /// In uk, this message translates to:
  /// **'Спробувати знову'**
  String get tryAgain;

  /// No description provided for @dashboard.
  ///
  /// In uk, this message translates to:
  /// **'Головна'**
  String get dashboard;

  /// No description provided for @newLesson.
  ///
  /// In uk, this message translates to:
  /// **'Нова пара'**
  String get newLesson;

  /// No description provided for @editLesson.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати пару'**
  String get editLesson;

  /// No description provided for @disciplines.
  ///
  /// In uk, this message translates to:
  /// **'Дисципліни'**
  String get disciplines;

  /// No description provided for @myDisciplines.
  ///
  /// In uk, this message translates to:
  /// **'Мої дисципліни'**
  String get myDisciplines;

  /// No description provided for @manageDisciplines.
  ///
  /// In uk, this message translates to:
  /// **'Керування дисциплінами'**
  String get manageDisciplines;

  /// No description provided for @newDiscipline.
  ///
  /// In uk, this message translates to:
  /// **'Нова дисципліна'**
  String get newDiscipline;

  /// No description provided for @editDiscipline.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати дисципліну'**
  String get editDiscipline;

  /// No description provided for @noDisciplines.
  ///
  /// In uk, this message translates to:
  /// **'Немає дисциплін'**
  String get noDisciplines;

  /// No description provided for @addDisciplineHint.
  ///
  /// In uk, this message translates to:
  /// **'Натисніть + щоб додати'**
  String get addDisciplineHint;

  /// No description provided for @overdue.
  ///
  /// In uk, this message translates to:
  /// **'Прострочено на {days} дн.'**
  String overdue(int days);

  /// No description provided for @daysLeft.
  ///
  /// In uk, this message translates to:
  /// **'Залишилось {days} дн.'**
  String daysLeft(int days);

  /// No description provided for @myDisciplinesTitle.
  ///
  /// In uk, this message translates to:
  /// **'Мої дисципліни'**
  String get myDisciplinesTitle;

  /// No description provided for @newDisciplineTitle.
  ///
  /// In uk, this message translates to:
  /// **'Нова дисципліна'**
  String get newDisciplineTitle;

  /// No description provided for @editDisciplineTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати дисципліну'**
  String get editDisciplineTitle;

  /// No description provided for @noDisciplinesMsg.
  ///
  /// In uk, this message translates to:
  /// **'Немає дисциплін'**
  String get noDisciplinesMsg;

  /// No description provided for @addDisciplineMessage.
  ///
  /// In uk, this message translates to:
  /// **'Натисніть + щоб додати'**
  String get addDisciplineMessage;

  /// No description provided for @disciplineNameLabel.
  ///
  /// In uk, this message translates to:
  /// **'Назва *'**
  String get disciplineNameLabel;

  /// No description provided for @disciplineTeacherLabel.
  ///
  /// In uk, this message translates to:
  /// **'Викладач'**
  String get disciplineTeacherLabel;

  /// No description provided for @addButtonLabel.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get addButtonLabel;

  /// No description provided for @saveButtonLabel.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get saveButtonLabel;

  /// No description provided for @editButtonLabel.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get editButtonLabel;

  /// No description provided for @deleteButtonLabel.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get deleteButtonLabel;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancelButtonLabel;

  /// No description provided for @deletedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Дисципліну видалено'**
  String get deletedMessage;

  /// No description provided for @errorMessage.
  ///
  /// In uk, this message translates to:
  /// **'Помилка: {error}'**
  String errorMessage(String error);

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In uk, this message translates to:
  /// **'Видалити \"{name}\"?'**
  String deleteConfirmMessage(String name);

  /// No description provided for @newEventTitle.
  ///
  /// In uk, this message translates to:
  /// **'Нова пара'**
  String get newEventTitle;

  /// No description provided for @editEventTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати пару'**
  String get editEventTitle;

  /// No description provided for @eventNameLabel.
  ///
  /// In uk, this message translates to:
  /// **'Назва предмета *'**
  String get eventNameLabel;

  /// No description provided for @eventCodeLabel.
  ///
  /// In uk, this message translates to:
  /// **'Код предмета (наприклад CS-101)'**
  String get eventCodeLabel;

  /// No description provided for @eventTypeLabel.
  ///
  /// In uk, this message translates to:
  /// **'Тип заняття'**
  String get eventTypeLabel;

  /// No description provided for @eventStartTimeLabel.
  ///
  /// In uk, this message translates to:
  /// **'Початок'**
  String get eventStartTimeLabel;

  /// No description provided for @eventEndTimeLabel.
  ///
  /// In uk, this message translates to:
  /// **'Закінчення'**
  String get eventEndTimeLabel;

  /// No description provided for @eventAuditoriumLabel.
  ///
  /// In uk, this message translates to:
  /// **'Аудиторія'**
  String get eventAuditoriumLabel;

  /// No description provided for @eventPriorityLabel.
  ///
  /// In uk, this message translates to:
  /// **'Пріоритет'**
  String get eventPriorityLabel;

  /// No description provided for @eventLowPriority.
  ///
  /// In uk, this message translates to:
  /// **'Низький'**
  String get eventLowPriority;

  /// No description provided for @eventMediumPriority.
  ///
  /// In uk, this message translates to:
  /// **'Середній'**
  String get eventMediumPriority;

  /// No description provided for @eventHighPriority.
  ///
  /// In uk, this message translates to:
  /// **'Високий'**
  String get eventHighPriority;

  /// No description provided for @eventAddButton.
  ///
  /// In uk, this message translates to:
  /// **'Додати пару'**
  String get eventAddButton;

  /// No description provided for @eventSaveButton.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти зміни'**
  String get eventSaveButton;

  /// No description provided for @eventDeleteConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Видалити пару?'**
  String get eventDeleteConfirm;

  /// No description provided for @eventDeleteConfirmText.
  ///
  /// In uk, this message translates to:
  /// **'Цю дію неможливо скасувати.'**
  String get eventDeleteConfirmText;

  /// No description provided for @eventAddedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Пару додано'**
  String get eventAddedMessage;

  /// No description provided for @eventUpdatedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Пару оновлено'**
  String get eventUpdatedMessage;

  /// No description provided for @eventDeletedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Пару видалено'**
  String get eventDeletedMessage;

  /// No description provided for @eventEndTimeError.
  ///
  /// In uk, this message translates to:
  /// **'Час закінчення має бути після початку'**
  String get eventEndTimeError;

  /// No description provided for @newTaskTitle.
  ///
  /// In uk, this message translates to:
  /// **'Нове завдання'**
  String get newTaskTitle;

  /// No description provided for @editTaskTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати завдання'**
  String get editTaskTitle;

  /// No description provided for @taskNameLabel.
  ///
  /// In uk, this message translates to:
  /// **'Назва завдання *'**
  String get taskNameLabel;

  /// No description provided for @taskSubjectLabel.
  ///
  /// In uk, this message translates to:
  /// **'Предмет *'**
  String get taskSubjectLabel;

  /// No description provided for @taskSubjectHint.
  ///
  /// In uk, this message translates to:
  /// **'Виберіть або введіть предмет'**
  String get taskSubjectHint;

  /// No description provided for @taskDeadlineLabel.
  ///
  /// In uk, this message translates to:
  /// **'Дедлайн'**
  String get taskDeadlineLabel;

  /// No description provided for @taskPriorityLabel.
  ///
  /// In uk, this message translates to:
  /// **'Пріоритет'**
  String get taskPriorityLabel;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In uk, this message translates to:
  /// **'Опис (необов\'язково)'**
  String get taskDescriptionLabel;

  /// No description provided for @taskNotesLabel.
  ///
  /// In uk, this message translates to:
  /// **'Нотатки (необов\'язково)'**
  String get taskNotesLabel;

  /// No description provided for @taskCompleted.
  ///
  /// In uk, this message translates to:
  /// **'Завдання виконано'**
  String get taskCompleted;

  /// No description provided for @taskCreateButton.
  ///
  /// In uk, this message translates to:
  /// **'Створити завдання'**
  String get taskCreateButton;

  /// No description provided for @taskSaveButton.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти зміни'**
  String get taskSaveButton;

  /// No description provided for @taskDeleteConfirm.
  ///
  /// In uk, this message translates to:
  /// **'Видалити завдання?'**
  String get taskDeleteConfirm;

  /// No description provided for @taskDeleteConfirmText.
  ///
  /// In uk, this message translates to:
  /// **'Цю дію неможливо скасувати.'**
  String get taskDeleteConfirmText;

  /// No description provided for @taskAddedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Завдання створено'**
  String get taskAddedMessage;

  /// No description provided for @taskUpdatedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Завдання оновлено'**
  String get taskUpdatedMessage;

  /// No description provided for @taskDeletedMessage.
  ///
  /// In uk, this message translates to:
  /// **'Завдання видалено'**
  String get taskDeletedMessage;

  /// No description provided for @goodMorning.
  ///
  /// In uk, this message translates to:
  /// **'Доброго ранку'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In uk, this message translates to:
  /// **'Доброго дня'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In uk, this message translates to:
  /// **'Доброго вечора'**
  String get goodEvening;

  /// No description provided for @classesToday.
  ///
  /// In uk, this message translates to:
  /// **'Пар сьогодні'**
  String get classesToday;

  /// No description provided for @nextClass.
  ///
  /// In uk, this message translates to:
  /// **'Наступне заняття'**
  String get nextClass;

  /// No description provided for @upcomingDeadlines.
  ///
  /// In uk, this message translates to:
  /// **'Найближчі дедлайни'**
  String get upcomingDeadlines;

  /// No description provided for @allTasks.
  ///
  /// In uk, this message translates to:
  /// **'Всі'**
  String get allTasks;

  /// No description provided for @allTasksCompleted.
  ///
  /// In uk, this message translates to:
  /// **'Всі завдання виконано!'**
  String get allTasksCompleted;

  /// No description provided for @mondayName.
  ///
  /// In uk, this message translates to:
  /// **'Понеділок'**
  String get mondayName;

  /// No description provided for @tuesdayName.
  ///
  /// In uk, this message translates to:
  /// **'Вівторок'**
  String get tuesdayName;

  /// No description provided for @wednesdayName.
  ///
  /// In uk, this message translates to:
  /// **'Середа'**
  String get wednesdayName;

  /// No description provided for @thursdayName.
  ///
  /// In uk, this message translates to:
  /// **'Четвер'**
  String get thursdayName;

  /// No description provided for @fridayName.
  ///
  /// In uk, this message translates to:
  /// **'П\'ятниця'**
  String get fridayName;

  /// No description provided for @saturdayName.
  ///
  /// In uk, this message translates to:
  /// **'Субота'**
  String get saturdayName;

  /// No description provided for @sundayName.
  ///
  /// In uk, this message translates to:
  /// **'Неділя'**
  String get sundayName;

  /// No description provided for @januaryName.
  ///
  /// In uk, this message translates to:
  /// **'січня'**
  String get januaryName;

  /// No description provided for @februaryName.
  ///
  /// In uk, this message translates to:
  /// **'лютого'**
  String get februaryName;

  /// No description provided for @marchName.
  ///
  /// In uk, this message translates to:
  /// **'березня'**
  String get marchName;

  /// No description provided for @aprilName.
  ///
  /// In uk, this message translates to:
  /// **'квітня'**
  String get aprilName;

  /// No description provided for @mayName.
  ///
  /// In uk, this message translates to:
  /// **'травня'**
  String get mayName;

  /// No description provided for @juneName.
  ///
  /// In uk, this message translates to:
  /// **'червня'**
  String get juneName;

  /// No description provided for @julyName.
  ///
  /// In uk, this message translates to:
  /// **'липня'**
  String get julyName;

  /// No description provided for @augustName.
  ///
  /// In uk, this message translates to:
  /// **'серпня'**
  String get augustName;

  /// No description provided for @septemberName.
  ///
  /// In uk, this message translates to:
  /// **'вересня'**
  String get septemberName;

  /// No description provided for @octoberName.
  ///
  /// In uk, this message translates to:
  /// **'жовтня'**
  String get octoberName;

  /// No description provided for @novemberName.
  ///
  /// In uk, this message translates to:
  /// **'листопада'**
  String get novemberName;

  /// No description provided for @decemberName.
  ///
  /// In uk, this message translates to:
  /// **'грудня'**
  String get decemberName;

  /// No description provided for @selectSubject.
  ///
  /// In uk, this message translates to:
  /// **'Виберіть предмет'**
  String get selectSubject;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
