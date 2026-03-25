import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ui_lab_3/l10n/app_localizations.dart';
import '../../models/lesson.dart';
import '../../repositories/lessons_repository.dart';

class DisciplinesScreen extends StatefulWidget {
  const DisciplinesScreen({super.key});

  @override
  State<DisciplinesScreen> createState() => _DisciplinesScreenState();
}

class _DisciplinesScreenState extends State<DisciplinesScreen> {
  final _repository = FirestoreLessonsRepository();
  List<Lesson> _lessons = [];
  bool _isLoading = true;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() => _isLoading = true);
    try {
      final all = await _repository.getLessons();
      setState(() => _lessons = all
          .where((l) => l.authorId == _uid)
          .toList());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${AppLocalizations.of(context)!.errorMessage}: $e'), 
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteLesson(String id) async {
    try {
      await _repository.deleteLesson(id);
      await _loadLessons();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.deletedMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${AppLocalizations.of(context)!.errorMessage}: $e'), 
              backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showAddEditDialog({Lesson? lesson}) {
    final l10n = AppLocalizations.of(context)!;
    final nameController =
        TextEditingController(text: lesson?.name ?? '');
    final teacherController =
        TextEditingController(text: lesson?.teacher ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson == null ? l10n.newDisciplineTitle : l10n.editDisciplineTitle,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.disciplineNameLabel,
                prefixIcon: const Icon(Icons.book),
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: teacherController,
              decoration: InputDecoration(
                labelText: l10n.disciplineTeacherLabel,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) return;

                  if (lesson == null) {
                    final newLesson = Lesson(
                      id: '',
                      courseId: 0,
                      name: nameController.text.trim(),
                      teacher: teacherController.text.trim(),
                      authorId: _uid,
                    );
                    await _repository.addLesson(newLesson);
                  } else {
                    final updated = lesson.copyWith(
                      name: nameController.text.trim(),
                      teacher: teacherController.text.trim(),
                    );
                    await _repository.updateLesson(updated);
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    _loadLessons();
                  }
                },
                child: Text(lesson == null ? l10n.addButtonLabel : l10n.saveButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myDisciplinesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lessons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(l10n.noDisciplinesMsg,
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Text(l10n.addDisciplineMessage,
                          style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLessons,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: Text(
                              lesson.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(lesson.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          subtitle: lesson.teacher.isNotEmpty
                              ? Text(lesson.teacher)
                              : null,
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(children: [
                                  const Icon(Icons.edit, size: 18),
                                  const SizedBox(width: 8),
                                  Text(l10n.editButtonLabel),
                                ]),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(children: [
                                  const Icon(Icons.delete,
                                      size: 18, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text(l10n.deleteButtonLabel,
                                      style: const TextStyle(color: Colors.red)),
                                ]),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showAddEditDialog(lesson: lesson);
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(l10n.deleteConfirmTitle),
                                    content: Text(
                                        'Видалити "${lesson.name}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text(l10n.cancelButtonLabel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteLesson(lesson.id);
                                        },
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red),
                                        child: Text(l10n.deleteButtonLabel),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}