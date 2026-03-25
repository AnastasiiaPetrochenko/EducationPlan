import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/tasks_provider.dart';
import '../tasks/task_edit_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksProvider>().getTaskById(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Завдання не знайдено')),
        body: const Center(child: Text('Це завдання не існує')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Деталі завдання'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditScreen(taskId: taskId),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getPriorityColor(task.priority),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Checkbox(
                        value: task.completed,
                        onChanged: (_) => context
                            .read<TasksProvider>()
                            .toggleTaskCompleted(taskId),
                        shape: const CircleBorder(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildChip(
                    context,
                    label: task.completed ? 'Виконано' : 'Активне',
                    color: task.completed ? Colors.green : Colors.orange,
                    icon: task.completed
                        ? Icons.check_circle
                        : Icons.pending_actions,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    context,
                    title: 'Предмет',
                    icon: Icons.book,
                    content: task.courseId,
                  ),
                  const SizedBox(height: 16),

                  _buildInfoSection(
                    context,
                    title: 'Дедлайн',
                    icon: Icons.calendar_today,
                    content: _formatDate(task.deadline),
                    trailing: _buildDeadlineChip(context, task.deadline),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoSection(
                    context,
                    title: 'Пріоритет',
                    icon: Icons.flag,
                    content: _getPriorityText(task.priority),
                    trailing: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  if (task.description != null) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Опис',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],

                  if (task.notes != null) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      'Нотатки',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Text(
                        task.notes!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Функція поширення незабаром'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Поділитись'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context
                              .read<TasksProvider>()
                              .toggleTaskCompleted(taskId),
                          icon: Icon(task.completed
                              ? Icons.restart_alt
                              : Icons.check),
                          label: Text(
                              task.completed ? 'Відновити' : 'Виконати'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: task.completed
                                ? Colors.orange
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
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

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
    Widget? trailing,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 12),
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineChip(BuildContext context, DateTime deadline) {
    final daysUntil = deadline.difference(DateTime.now()).inDays;
    final isOverdue = daysUntil < 0;
    final isUrgent = daysUntil >= 0 && daysUntil <= 3;

    String text;
    Color color;

    if (isOverdue) {
      text = 'Прострочено на ${-daysUntil} дн.';
      color = Colors.red;
    } else if (isUrgent) {
      text = 'Залишилось $daysUntil дн.';
      color = Colors.orange;
    } else {
      text = 'Залишилось $daysUntil дн.';
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:   return Colors.red;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.low:    return Colors.green;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:   return 'Високий';
      case TaskPriority.medium: return 'Середній';
      case TaskPriority.low:    return 'Низький';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'січня', 'лютого', 'березня', 'квітня', 'травня', 'червня',
      'липня', 'серпня', 'вересня', 'жовтня', 'листопада', 'грудня'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}