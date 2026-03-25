import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ui_lab_3/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ui_lab_3/providers/theme_provider.dart';
import 'package:ui_lab_3/providers/locale_provider.dart';
import '../../providers/tasks_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../models/task.dart';
import '../../models/event.dart';
import '../tasks/task_detail_screen.dart';
import '../tasks/task_edit_screen.dart';
import '../schedule/lesson_detail_screen.dart';
import '../schedule/event_edit_screen.dart';
import '../disciplines/disciplines_screen.dart';
import '../../repositories/auth_repository.dart';
import '../auth/login_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider?>()?.loadSchedule();
    });
  }
  void _showNotificationsPanel(BuildContext context, TasksProvider tasksProvider) {
    final urgentTasks = tasksProvider.tasks
        .where((t) =>
            !t.completed &&
            t.deadline.difference(DateTime.now()).inDays <= 3)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Найближчі дедлайни',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (urgentTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 48, color: Colors.green.shade400),
                  const SizedBox(height: 8),
                  const Text('Немає термінових завдань!',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: urgentTasks.length,
              itemBuilder: (context, index) {
                final task = urgentTasks[index];
                final daysLeft =
                    task.deadline.difference(DateTime.now()).inDays;
                final isOverdue = daysLeft < 0;

                Color color = Colors.green;
                if (isOverdue) color = Colors.red;
                else if (daysLeft <= 1) color = Colors.red;
                else if (daysLeft <= 3) color = Colors.orange;

                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.assignment, color: color, size: 20),
                  ),
                  title: Text(task.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(task.courseId,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isOverdue
                          ? 'Прострочено'
                          : daysLeft == 0
                              ? 'Сьогодні'
                              : '$daysLeft дн.',
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
    final List<Widget> _pages = [
      const DashboardPage(),
      const TasksPage(),
      const SchedulePage(),
      const ProfilePage(),
    ];

    @override
    Widget build(BuildContext context) {
      final l10n = AppLocalizations.of(context)!;

      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          elevation: 0,
          actions: [
    Consumer<TasksProvider>(
      builder: (context, tasksProvider, child) {
        final urgentCount = tasksProvider.tasks
            .where((t) =>
                !t.completed &&
                t.deadline.difference(DateTime.now()).inDays <= 3)
            .length;

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _showNotificationsPanel(context, tasksProvider),
            ),
            if (urgentCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    urgentCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.task_outlined),
            selectedIcon: const Icon(Icons.task),
            label: l10n.tasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: l10n.schedule,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget? _buildFab(BuildContext context) {
    if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TaskEditScreen(taskId: null)),
        ),
        child: const Icon(Icons.add),
      );
    }

    if (_selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EventEditScreen()),
        ),
        child: const Icon(Icons.add),
      );
    }

    return null;
  }
}

// ============================================================================
// DASHBOARD PAGE
// ============================================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  String _formatTime(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final months = [
      l10n.januaryName, l10n.februaryName, l10n.marchName, l10n.aprilName,
      l10n.mayName, l10n.juneName, l10n.julyName, l10n.augustName,
      l10n.septemberName, l10n.octoberName, l10n.novemberName, l10n.decemberName
    ];
    final days = [
      l10n.mondayName, l10n.tuesdayName, l10n.wednesdayName, l10n.thursdayName,
      l10n.fridayName, l10n.saturdayName, l10n.sundayName
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authRepository = FirebaseAuthRepository();
    final user = authRepository.getCurrentUser();
    final firstName = user?.displayName?.split(' ').first ?? '';

    return Consumer2<TasksProvider, ScheduleProvider>(
      builder: (context, tasksProvider, scheduleProvider, child) {
        final upcomingTasks = tasksProvider.tasks
            .where((t) => !t.completed)
            .take(3)
            .toList();

        final today = DateTime.now();
        final todayEvents = scheduleProvider.events.where((e) {
          return e.startTime.year == today.year &&
              e.startTime.month == today.month &&
              e.startTime.day == today.day;
        }).toList();

        final nextEvents = scheduleProvider.events
            .where((e) => e.startTime.isAfter(today))
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        return RefreshIndicator(
          onRefresh: () async => scheduleProvider.loadSchedule(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting(l10n)}${firstName.isNotEmpty ? ', $firstName!' : '!'}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(today, l10n),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      user?.displayName?.substring(0, 1) ?? 'A',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(context,
                        icon: Icons.pending_actions,
                        label: l10n.activeTasks,
                        value: tasksProvider.activeTasks.toString(),
                        color: Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(context,
                        icon: Icons.warning_amber,
                        label: l10n.urgentTasks,
                        value: tasksProvider.urgentTasks.toString(),
                        color: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(context,
                        icon: Icons.calendar_today,
                        label: l10n.classesToday,
                        value: todayEvents.length.toString(),
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (nextEvents.isNotEmpty) ...[
                Text(l10n.nextClass,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildNextEventCard(context, nextEvents.first),
                const SizedBox(height: 24),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.upcomingDeadlines,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(l10n.allTasks),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (upcomingTasks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 48, color: Colors.green.shade400),
                          const SizedBox(height: 8),
                          Text(l10n.allTasksCompleted,
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...upcomingTasks.map((t) => _buildDeadlineCard(context, t)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon,
      required String label,
      required String value,
      required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildNextEventCard(BuildContext context, Event event) {
    final courseName = event.name.isNotEmpty ? event.name : event.courseId;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.school,
                  color: Theme.of(context).colorScheme.onPrimary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(courseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.access_time,
                        size: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                        '${_formatTime(event.startTime)} — ${_formatTime(event.endTime)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.7),
                            fontSize: 13)),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.room,
                        size: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimaryContainer
                            .withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                        event.auditorium.isNotEmpty ? event.auditorium : '—',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withValues(alpha: 0.7),
                            fontSize: 13)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineCard(BuildContext context, Task task) {
    Color priorityColor = Colors.grey;
    if (task.priority == TaskPriority.high) priorityColor = Colors.red;
    if (task.priority == TaskPriority.medium) priorityColor = Colors.orange;
    if (task.priority == TaskPriority.low) priorityColor = Colors.green;

    final daysLeft = task.deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysLeft < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
              color: priorityColor, borderRadius: BorderRadius.circular(2)),
        ),
        title: Text(task.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(task.courseId,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (isOverdue ? Colors.red : priorityColor)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isOverdue
                ? 'Overdue'
                : daysLeft == 0
                    ? 'Today'
                    : '$daysLeft d',
            style: TextStyle(
                color: isOverdue ? Colors.red : priorityColor,
                fontWeight: FontWeight.w600,
                fontSize: 12),
          ),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskDetailScreen(taskId: task.id))),
      ),
    );
  }
}

// ============================================================================
// TASKS PAGE
// ============================================================================

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool _showCalendar = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<TasksProvider>(
      builder: (context, provider, child) {
        if (provider.status == TasksStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.status == TasksStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.errorMessage ?? l10n.errorLoading,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        }

        List<Task> tasks;
        if (_showCalendar && _selectedDay != null) {
          tasks = provider.tasks.where((t) {
            return t.deadline.year == _selectedDay!.year &&
                t.deadline.month == _selectedDay!.month &&
                t.deadline.day == _selectedDay!.day;
          }).toList();
        } else {
          tasks = provider.tasks;
        }

        Map<DateTime, List<Task>> tasksByDay = {};
        for (final task in provider.tasks) {
          final day = DateTime(
              task.deadline.year, task.deadline.month, task.deadline.day);
          tasksByDay[day] = [...(tasksByDay[day] ?? []), task];
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.myTasks,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: Icon(_showCalendar
                        ? Icons.view_list
                        : Icons.calendar_month),
                    tooltip: _showCalendar ? 'List' : 'Calendar',
                    onPressed: () {
                      setState(() {
                        _showCalendar = !_showCalendar;
                        if (!_showCalendar) _selectedDay = null;
                      });
                    },
                  ),
                  PopupMenuButton<TaskFilter>(
                    icon: const Icon(Icons.filter_list),
                    onSelected: provider.setFilter,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: TaskFilter.all,
                          child: Text(l10n.filterAll)),
                      PopupMenuItem(
                          value: TaskFilter.active,
                          child: Text(l10n.filterActive)),
                      PopupMenuItem(
                          value: TaskFilter.completed,
                          child: Text(l10n.filterCompleted)),
                    ],
                  ),
                  PopupMenuButton<TaskSort>(
                    icon: const Icon(Icons.sort),
                    onSelected: provider.setSort,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: TaskSort.deadline,
                          child: Text(l10n.sortByDeadline)),
                      PopupMenuItem(
                          value: TaskSort.priority,
                          child: Text(l10n.sortByPriority)),
                      PopupMenuItem(
                          value: TaskSort.subject,
                          child: Text(l10n.sortBySubject)),
                    ],
                  ),
                ],
              ),
            ),
            if (_showCalendar)
              Card(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TableCalendar<Task>(
                  firstDay:
                      DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(_selectedDay, day),
                  eventLoader: (day) {
                    final key = DateTime(day.year, day.month, day.day);
                    return tasksByDay[key] ?? [];
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  locale: Localizations.localeOf(context).languageCode,
                ),
              ),
            if (!_showCalendar)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Card(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(context,
                            icon: Icons.pending_actions,
                            label: l10n.activeTasks,
                            count: provider.activeTasks.toString(),
                            color: Colors.orange),
                        _buildStatItem(context,
                            icon: Icons.check_circle,
                            label: l10n.completedTasks,
                            count: provider.completedTasks.toString(),
                            color: Colors.green),
                        _buildStatItem(context,
                            icon: Icons.warning,
                            label: l10n.urgentTasks,
                            count: provider.urgentTasks.toString(),
                            color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showCalendar && _selectedDay != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'Deadlines: ${_selectedDay!.day}.${_selectedDay!.month}.${_selectedDay!.year}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                    const Spacer(),
                    if (tasks.isEmpty)
                      Text('none',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.task_alt,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              _showCalendar && _selectedDay != null
                                  ? 'No tasks for this day'
                                  : l10n.noTasks,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600),
                            ),
                            if (!_showCalendar) ...[
                              const SizedBox(height: 8),
                              Text(l10n.addTaskHint,
                                  style: TextStyle(
                                      color: Colors.grey.shade500)),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) =>
                          TaskCard(task: tasks[index]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context,
      {required IconData icon,
      required String label,
      required String count,
      required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(count,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold, color: color)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ============================================================================
// TASK CARD
// ============================================================================

class TaskCard extends StatefulWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Color priorityColor = Colors.grey;
    if (widget.task.priority == TaskPriority.high) priorityColor = Colors.red;
    if (widget.task.priority == TaskPriority.medium)
      priorityColor = Colors.orange;
    if (widget.task.priority == TaskPriority.low) priorityColor = Colors.green;

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Checkbox(
            value: widget.task.completed,
            onChanged: (_) => context
                .read<TasksProvider>()
                .toggleTaskCompleted(widget.task.id),
            shape: const CircleBorder(),
          ),
          title: Text(widget.task.title,
              style: TextStyle(
                decoration: widget.task.completed
                    ? TextDecoration.lineThrough
                    : null,
                fontWeight: FontWeight.w600,
              )),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.book_outlined,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(widget.task.courseId,
                    style: TextStyle(color: Colors.grey.shade600)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.calendar_today, size: 14, color: priorityColor),
                const SizedBox(width: 4),
                Text(
                  '${l10n.deadline}: ${widget.task.deadline.day}.${widget.task.deadline.month}.${widget.task.deadline.year}',
                  style: TextStyle(
                      color: priorityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ]),
            ],
          ),
          trailing: Container(
            width: 8,
            height: 50,
            decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: BorderRadius.circular(4)),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TaskDetailScreen(taskId: widget.task.id))),
        ),
      ),
    );
  }
}

// ============================================================================
// SCHEDULE PAGE
// ============================================================================

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ScheduleProvider>(
      builder: (context, provider, child) {
        if (provider.status == ScheduleStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.status == ScheduleStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadSchedule(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tryAgain),
                ),
              ],
            ),
          );
        }

        final events = provider.events;

        return RefreshIndicator(
          onRefresh: () => provider.loadSchedule(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.weekSchedule,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (events.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(l10n.noSchedule,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                )
              else
                ...events.map((event) => LessonCard(event: event)),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// LESSON CARD
// ============================================================================

class LessonCard extends StatefulWidget {
  final Event event;

  const LessonCard({super.key, required this.event});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  String _getDayName(int weekday) {
    final isUk = Localizations.localeOf(context).languageCode == 'uk';
    const ukDays = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', 'П\'ятниця', 'Субота', 'Неділя'];
    const enDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final days = isUk ? ukDays : enDays;
    return weekday >= 1 && weekday <= 7 ? days[weekday - 1] : '';
  }

  String _getEventTypeText(EventType type) {
    final isUk = Localizations.localeOf(context).languageCode == 'uk';
    if (isUk) {
      switch (type) {
        case EventType.lecture:      return 'Лекція';
        case EventType.practical:    return 'Практика';
        case EventType.lab:          return 'Лабораторна';
        case EventType.consultation: return 'Консультація';
        case EventType.exam:         return 'Екзамен';
      }
    } else {
      switch (type) {
        case EventType.lecture:      return 'Lecture';
        case EventType.practical:    return 'Practical';
        case EventType.lab:          return 'Lab';
        case EventType.consultation: return 'Consultation';
        case EventType.exam:         return 'Exam';
      }
    }
  }

  String _formatTime(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final dayName = _getDayName(widget.event.startTime.weekday);
    final eventType = _getEventTypeText(widget.event.type);

    Color priorityColor;
    switch (widget.event.priority) {
      case 3:  priorityColor = Colors.red; break;
      case 2:  priorityColor = Colors.orange; break;
      default: priorityColor = Colors.green;
    }

    final courseName = widget.event.name.isNotEmpty
        ? widget.event.name
        : widget.event.courseId;

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LessonDetailScreen(eventId: widget.event.id))),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 8, color: priorityColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: priorityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(dayName,
                                  style: TextStyle(
                                      color: priorityColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(eventType,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ),
                            const Spacer(),
                            Icon(Icons.access_time,
                                size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTime(widget.event.startTime)} - ${_formatTime(widget.event.endTime)}',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(courseName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(children: [
                          Icon(Icons.room,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                              widget.event.auditorium.isNotEmpty
                                  ? widget.event.auditorium
                                  : '—',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE PAGE
// ============================================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final authRepository = FirebaseAuthRepository();
    final user = authRepository.getCurrentUser();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user?.displayName?.substring(0, 1) ?? 'A',
                    style: TextStyle(
                        fontSize: 40,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
                const SizedBox(height: 16),
                Text(user?.displayName ?? 'User Name',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user?.email ?? 'user@example.com',
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.book,
                  color: Theme.of(context).colorScheme.primary),
            ),
            title: Text(l10n.myDisciplines,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(l10n.manageDisciplines),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DisciplinesScreen()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settings,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(l10n.theme,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                        value: ThemeMode.light,
                        label: Text(l10n.lightTheme),
                        icon: const Icon(Icons.wb_sunny)),
                    ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text(l10n.darkTheme),
                        icon: const Icon(Icons.brightness_2)),
                    ButtonSegment(
                        value: ThemeMode.system,
                        label: Text(l10n.systemTheme),
                        icon: const Icon(Icons.settings_system_daydream)),
                  ],
                  selected: {themeProvider.themeMode},
                  onSelectionChanged: (s) => themeProvider.setTheme(s.first),
                ),
                const SizedBox(height: 20),
                Text(l10n.language,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Center(
                  child: SegmentedButton<Locale>(
                    segments: const [
                      ButtonSegment(
                          value: Locale('uk'),
                          label: Text('🇺🇦 Українська')),
                      ButtonSegment(
                          value: Locale('en'),
                          label: Text('🇬🇧 English')),
                    ],
                    selected: {localeProvider.locale},
                    onSelectionChanged: (s) =>
                        localeProvider.setLocale(s.first),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            await authRepository.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: Text(l10n.logout),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
        ),
      ],
    );
  }
}