import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/schedule_provider.dart';
import '../schedule/event_edit_screen.dart';

class LessonDetailScreen extends StatelessWidget {
  final String eventId;

  const LessonDetailScreen({super.key, required this.eventId});

  String _formatTime(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Понеділок';
      case 2: return 'Вівторок';
      case 3: return 'Середа';
      case 4: return 'Четвер';
      case 5: return 'П\'ятниця';
      case 6: return 'Субота';
      case 7: return 'Неділя';
      default: return '';
    }
  }

  String _getEventTypeText(EventType type) {
    switch (type) {
      case EventType.lecture:      return 'Лекція';
      case EventType.practical:    return 'Практика';
      case EventType.lab:          return 'Лабораторна';
      case EventType.consultation: return 'Консультація';
      case EventType.exam:         return 'Екзамен';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final event = provider.getEventById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Заняття не знайдено')),
        body: const Center(child: Text('Це заняття не існує')),
      );
    }

    final String courseName = event.name.isNotEmpty
        ? event.name
        : event.courseId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі заняття'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditScreen(eventId: eventId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Шапка
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // День тижня
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getDayName(event.startTime.weekday),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Назва предмета
                  Text(
                    courseName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // courseId як підзаголовок (якщо є name)
                  if (event.name.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.courseId,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${_formatTime(event.startTime)} — ${_formatTime(event.endTime)}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    context,
                    icon: Icons.event_note,
                    title: 'Тип заняття',
                    content: _getEventTypeText(event.type),
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    icon: Icons.room,
                    title: 'Аудиторія',
                    content: event.auditorium.isEmpty
                        ? 'Не вказано'
                        : event.auditorium,
                    iconColor: Colors.orange,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Швидкі дії',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildActionButton(
                        context,
                        icon: Icons.notifications,
                        label: 'Нагадування',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Нагадування встановлено'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        context,
                        icon: Icons.share,
                        label: 'Поділитись',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Не реалізована'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}