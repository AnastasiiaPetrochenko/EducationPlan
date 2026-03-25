import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ui_lab_3/l10n/app_localizations.dart';
import '../../models/event.dart';
import '../../models/lesson.dart';
import '../../providers/schedule_provider.dart';
import '../../repositories/lessons_repository.dart';

class EventEditScreen extends StatefulWidget {
  final String? eventId;

  const EventEditScreen({super.key, this.eventId});

  @override
  State<EventEditScreen> createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auditoriumController = TextEditingController();

  EventType _type = EventType.lecture;
  int _priority = 1;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 3));

  bool _isEditing = false;
  bool _isSaving = false;

  List<Lesson> _lessons = [];
  String? _selectedName;
  bool _loadingLessons = true;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.eventId != null && widget.eventId!.isNotEmpty;
    _loadLessons();

    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final event = context
            .read<ScheduleProvider>()
            .getEventById(widget.eventId!);
        if (event != null) {
          _auditoriumController.text = event.auditorium;
          setState(() {
            _selectedName = event.name.isNotEmpty ? event.name : null;
            _type = event.type;
            _priority = event.priority;
            _startTime = event.startTime;
            _endTime = event.endTime;
          });
        }
      });
    }
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
    _auditoriumController.dispose();
    super.dispose();
  }

  AppLocalizations _getL10n() => AppLocalizations.of(context)!;

  String _getTypeName(EventType type) {
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

  void _showSubjectPicker() {
    final l10n = _getL10n();

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
            child: Text(l10n.selectSubject,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
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
                  Text(l10n.addDisciplineHint,
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
                final isSelected = _selectedName == lesson.name;
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
                    setState(() => _selectedName = lesson.name);
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

  Future<void> _pickDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
    );
    if (time == null) return;

    final dt =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      if (isStart) {
        _startTime = dt;
        if (_endTime.isBefore(_startTime)) {
          _endTime = _startTime.add(const Duration(hours: 1, minutes: 35));
        }
      } else {
        _endTime = dt;
      }
    });
  }

  Future<void> _save() async {
    final l10n = _getL10n();

    if (!_formKey.currentState!.validate()) return;

    if (_selectedName == null || _selectedName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectSubject),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_endTime.isBefore(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.eventEndTimeError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final provider = context.read<ScheduleProvider>();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      final event = Event(
        id: widget.eventId ?? '',
        name: _selectedName!,
        courseId: _selectedName!,
        type: _type,
        startTime: _startTime,
        endTime: _endTime,
        auditorium: _auditoriumController.text.trim(),
        priority: _priority,
        authorId: uid,
      );

      if (_isEditing) {
        await provider.updateEvent(event);
      } else {
        await provider.addEvent(event);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? l10n.eventUpdatedMessage : l10n.eventAddedMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = _getL10n();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.eventDeleteConfirm),
        content: Text(l10n.eventDeleteConfirmText),
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

    if (confirmed != true || !mounted) return;

    try {
      await context.read<ScheduleProvider>().deleteEvent(widget.eventId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.eventDeletedMessage),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _getL10n();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editEventTitle : l10n.newEventTitle),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _delete,
            ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                InkWell(
                  onTap: _loadingLessons ? null : _showSubjectPicker,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedName == null
                            ? Colors.grey.shade400
                            : Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.book,
                            color: _selectedName == null
                                ? Colors.grey.shade600
                                : Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.eventNameLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _selectedName == null
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
                                      _selectedName ?? l10n.selectSubject,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _selectedName == null
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
                Text(l10n.eventTypeLabel,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: EventType.values.map((type) {
                    return ChoiceChip(
                      label: Text(_getTypeName(type)),
                      selected: _type == type,
                      onSelected: (_) => setState(() => _type = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(l10n.eventStartTimeLabel),
                  subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(_startTime)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _pickDateTime(isStart: true),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.stop_circle_outlined),
                  title: Text(l10n.eventEndTimeLabel),
                  subtitle: Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(_endTime)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _pickDateTime(isStart: false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _auditoriumController,
                  decoration: InputDecoration(
                    labelText: l10n.eventAuditoriumLabel,
                    prefixIcon: const Icon(Icons.room),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.eventPriorityLabel,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment(
                      value: 1,
                      label: Text(l10n.eventLowPriority),
                      icon: const Icon(Icons.arrow_downward,
                          color: Colors.green),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text(l10n.eventMediumPriority),
                      icon: const Icon(Icons.remove,
                          color: Colors.orange),
                    ),
                    ButtonSegment(
                      value: 3,
                      label: Text(l10n.eventHighPriority),
                      icon: const Icon(Icons.arrow_upward,
                          color: Colors.red),
                    ),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (s) =>
                      setState(() => _priority = s.first),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: const Icon(Icons.save),
                  label: Text(_isEditing
                      ? l10n.eventSaveButton
                      : l10n.eventAddButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving)
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
      ),
    );
  }
}