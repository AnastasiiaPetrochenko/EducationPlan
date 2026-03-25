import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui_lab_3/l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../models/lesson.dart';
import '../../providers/tasks_provider.dart';
import '../../providers/task_edit_provider.dart';
import '../../repositories/lessons_repository.dart';
import 'package:intl/intl.dart';

class TaskEditScreen extends StatefulWidget {
  final String? taskId;

  const TaskEditScreen({super.key, this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isEditing = false;

  List<Lesson> _lessons = [];
  String? _selectedCourseId;
  bool _loadingLessons = true;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.taskId != null && widget.taskId!.isNotEmpty;
    _loadLessons();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final editProvider = context.read<TaskEditProvider>();

      if (_isEditing) {
        final task = context.read<TasksProvider>().getTaskById(widget.taskId!);
        if (task != null) {
          editProvider.loadTask(task);
          _titleController.text = task.title;
          _descriptionController.text = task.description ?? '';
          _notesController.text = task.notes ?? '';
          setState(() => _selectedCourseId = task.courseId);
        }
      } else {
        editProvider.reset();
        _titleController.clear();
        _descriptionController.clear();
        _notesController.clear();
        final currentUser = FirebaseAuth.instance.currentUser;
        editProvider.setAuthorId(currentUser?.uid ?? '');
      }
    });
  }

  Future<void> _loadLessons() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final all = await FirestoreLessonsRepository().getLessons();
      setState(() {
        _lessons = all.where((l) => l.authorId == uid).toList();
        _loadingLessons = false;
      });
    } catch (e) {
      setState(() => _loadingLessons = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSubjectPicker(TaskEditProvider provider) {
    final l10n = AppLocalizations.of(context)!;

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
                Text(l10n.selectSubject,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.book_outlined,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(l10n.noDisciplines,
                      style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(l10n.addDisciplineMessage,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                final isSelected = _selectedCourseId == lesson.name;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      lesson.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(lesson.name,
                      style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  subtitle: lesson.teacher.isNotEmpty
                      ? Text(lesson.teacher)
                      : null,
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedCourseId = lesson.name);
                    provider.setCourseId(lesson.name);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editTaskTitle : l10n.newTaskTitle),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _showDeleteDialog,
            ),
        ],
      ),
      body: Consumer<TaskEditProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.taskNameLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.title),
                      ),
                      validator: (_) => provider.validateTitle(),
                      onChanged: provider.setTitle,
                      maxLength: 100,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _loadingLessons
                          ? null
                          : () => _showSubjectPicker(provider),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedCourseId == null
                                ? Colors.grey.shade400
                                : Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.book,
                                color: _selectedCourseId == null
                                    ? Colors.grey.shade600
                                    : Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.taskSubjectLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedCourseId == null
                                          ? Colors.grey.shade600
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  _loadingLessons
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2))
                                      : Text(
                                          _selectedCourseId ??
                                              l10n.selectSubject,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _selectedCourseId == null
                                                ? Colors.grey.shade500
                                                : null,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: Colors.grey.shade600),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: Text(l10n.taskDeadlineLabel),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy HH:mm')
                            .format(provider.deadline),
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _selectDeadline(context, provider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.taskPriorityLabel,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    SegmentedButton<TaskPriority>(
                      segments: [
                        ButtonSegment(
                          value: TaskPriority.low,
                          label: Text(l10n.priorityLow),
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.green),
                        ),
                        ButtonSegment(
                          value: TaskPriority.medium,
                          label: Text(l10n.priorityMedium),
                          icon: const Icon(Icons.remove,
                              color: Colors.orange),
                        ),
                        ButtonSegment(
                          value: TaskPriority.high,
                          label: Text(l10n.priorityHigh),
                          icon: const Icon(Icons.arrow_upward,
                              color: Colors.red),
                        ),
                      ],
                      selected: {provider.priority},
                      onSelectionChanged: (Set<TaskPriority> selection) {
                        provider.setPriority(selection.first);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_isEditing)
                      SwitchListTile(
                        title: Text(l10n.taskCompleted),
                        value: provider.completed,
                        onChanged: provider.setCompleted,
                        secondary: Icon(
                          provider.completed
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: provider.completed
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.taskDescriptionLabel,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      onChanged: provider.setDescription,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.taskNotesLabel,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      onChanged: provider.setNotes,
                    ),
                    const SizedBox(height: 24),
                    if (provider.status == TaskEditStatus.error &&
                        provider.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.errorMessage!,
                                style:
                                    const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: provider.status == TaskEditStatus.saving
                          ? null
                          : () => _saveTask(context, provider),
                      icon: const Icon(Icons.save),
                      label: Text(_isEditing
                          ? l10n.taskSaveButton
                          : l10n.taskCreateButton),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.status == TaskEditStatus.saving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Saving...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDeadline(
      BuildContext context, TaskEditProvider provider) async {
    final date = await showDatePicker(
      context: context,
      initialDate: provider.deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(provider.deadline),
      );

      if (time != null) {
        provider.setDeadline(DateTime(
          date.year, date.month, date.day, time.hour, time.minute,
        ));
      }
    }
  }

  Future<void> _saveTask(
      BuildContext context, TaskEditProvider provider) async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCourseId == null || _selectedCourseId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectSubject),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = _isEditing
        ? await provider.updateTask(widget.taskId!)
        : await provider.createTask();

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? l10n.taskUpdatedMessage
              : l10n.taskAddedMessage),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _showDeleteDialog() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.taskDeleteConfirm),
        content: Text(l10n.taskDeleteConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteButtonLabel),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final provider = context.read<TaskEditProvider>();
      final success = await provider.deleteTask(widget.taskId!);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.taskDeletedMessage),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}