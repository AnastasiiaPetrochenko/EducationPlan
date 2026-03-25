// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Education Plan';

  @override
  String get tasks => 'Tasks';

  @override
  String get schedule => 'Schedule';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get myTasks => 'My Tasks';

  @override
  String get activeTasks => 'Active tasks';

  @override
  String get completedTasks => 'Completed';

  @override
  String get urgentTasks => 'Urgent';

  @override
  String get noTasks => 'No tasks';

  @override
  String get addTaskHint => 'Press + to add a new task';

  @override
  String get weekSchedule => 'Weekly Schedule';

  @override
  String get noSchedule => 'No classes in schedule';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Sign Out';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get lessonDetails => 'Lesson Details';

  @override
  String get newTask => 'New Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get deleteTask => 'Delete task?';

  @override
  String get deleteTaskConfirm => 'This action cannot be undone.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get deadline => 'Deadline';

  @override
  String get priority => 'Priority';

  @override
  String get subject => 'Subject';

  @override
  String get description => 'Description';

  @override
  String get notes => 'Notes';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusActive => 'Active';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get sortByDeadline => 'By deadline';

  @override
  String get sortByPriority => 'By priority';

  @override
  String get sortBySubject => 'By subject';

  @override
  String get taskCreated => 'Task created';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get errorLoading => 'Loading error';

  @override
  String get tryAgain => 'Try again';

  @override
  String get dashboard => 'Home';

  @override
  String get newLesson => 'New Class';

  @override
  String get editLesson => 'Edit Class';

  @override
  String get disciplines => 'Disciplines';

  @override
  String get myDisciplines => 'My Disciplines';

  @override
  String get manageDisciplines => 'Manage Disciplines';

  @override
  String get newDiscipline => 'New Discipline';

  @override
  String get editDiscipline => 'Edit Discipline';

  @override
  String get noDisciplines => 'No disciplines';

  @override
  String get addDisciplineHint => 'Press + to add';

  @override
  String overdue(int days) {
    return 'Overdue by $days days';
  }

  @override
  String daysLeft(int days) {
    return '$days days left';
  }

  @override
  String get myDisciplinesTitle => 'My Disciplines';

  @override
  String get newDisciplineTitle => 'New Discipline';

  @override
  String get editDisciplineTitle => 'Edit Discipline';

  @override
  String get noDisciplinesMsg => 'No disciplines';

  @override
  String get addDisciplineMessage => 'Tap + to add';

  @override
  String get disciplineNameLabel => 'Name *';

  @override
  String get disciplineTeacherLabel => 'Teacher';

  @override
  String get addButtonLabel => 'Add';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get editButtonLabel => 'Edit';

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get deletedMessage => 'Discipline deleted';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String deleteConfirmMessage(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get newEventTitle => 'New Class';

  @override
  String get editEventTitle => 'Edit Class';

  @override
  String get eventNameLabel => 'Subject name *';

  @override
  String get eventCodeLabel => 'Subject code (e.g. CS-101)';

  @override
  String get eventTypeLabel => 'Class type';

  @override
  String get eventStartTimeLabel => 'Start';

  @override
  String get eventEndTimeLabel => 'End';

  @override
  String get eventAuditoriumLabel => 'Auditorium';

  @override
  String get eventPriorityLabel => 'Priority';

  @override
  String get eventLowPriority => 'Low';

  @override
  String get eventMediumPriority => 'Medium';

  @override
  String get eventHighPriority => 'High';

  @override
  String get eventAddButton => 'Add Class';

  @override
  String get eventSaveButton => 'Save Changes';

  @override
  String get eventDeleteConfirm => 'Delete Class?';

  @override
  String get eventDeleteConfirmText => 'This action cannot be undone.';

  @override
  String get eventAddedMessage => 'Class added';

  @override
  String get eventUpdatedMessage => 'Class updated';

  @override
  String get eventDeletedMessage => 'Class deleted';

  @override
  String get eventEndTimeError => 'End time must be after start time';

  @override
  String get newTaskTitle => 'New Task';

  @override
  String get editTaskTitle => 'Edit Task';

  @override
  String get taskNameLabel => 'Task name *';

  @override
  String get taskSubjectLabel => 'Subject *';

  @override
  String get taskSubjectHint => 'Select or enter subject';

  @override
  String get taskDeadlineLabel => 'Deadline';

  @override
  String get taskPriorityLabel => 'Priority';

  @override
  String get taskDescriptionLabel => 'Description (optional)';

  @override
  String get taskNotesLabel => 'Notes (optional)';

  @override
  String get taskCompleted => 'Task completed';

  @override
  String get taskCreateButton => 'Create Task';

  @override
  String get taskSaveButton => 'Save Changes';

  @override
  String get taskDeleteConfirm => 'Delete task?';

  @override
  String get taskDeleteConfirmText => 'This action cannot be undone.';

  @override
  String get taskAddedMessage => 'Task created';

  @override
  String get taskUpdatedMessage => 'Task updated';

  @override
  String get taskDeletedMessage => 'Task deleted';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get classesToday => 'Classes today';

  @override
  String get nextClass => 'Next class';

  @override
  String get upcomingDeadlines => 'Upcoming deadlines';

  @override
  String get allTasks => 'All';

  @override
  String get allTasksCompleted => 'All tasks completed!';

  @override
  String get mondayName => 'Monday';

  @override
  String get tuesdayName => 'Tuesday';

  @override
  String get wednesdayName => 'Wednesday';

  @override
  String get thursdayName => 'Thursday';

  @override
  String get fridayName => 'Friday';

  @override
  String get saturdayName => 'Saturday';

  @override
  String get sundayName => 'Sunday';

  @override
  String get januaryName => 'January';

  @override
  String get februaryName => 'February';

  @override
  String get marchName => 'March';

  @override
  String get aprilName => 'April';

  @override
  String get mayName => 'May';

  @override
  String get juneName => 'June';

  @override
  String get julyName => 'July';

  @override
  String get augustName => 'August';

  @override
  String get septemberName => 'September';

  @override
  String get octoberName => 'October';

  @override
  String get novemberName => 'November';

  @override
  String get decemberName => 'December';

  @override
  String get selectSubject => 'Select Subject';
}
