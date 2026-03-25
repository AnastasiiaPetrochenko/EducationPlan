import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { 
  high,   
  medium, 
  low     
}

class Task {
  final String id;
  final String title;
  final String courseId; 
  final DateTime deadline;
  final TaskPriority priority;
  final bool completed;
  final String? description;
  final String? notes;
  final String authorId; 
  final List<String>? attachmentUrls;

  Task({
    required this.id,
    required this.title,
    required this.courseId, 
    required this.deadline,
    required this.priority,
    this.completed = false,
    this.description,
    this.notes,
    required this.authorId,
    this.attachmentUrls,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    DateTime deadlineDate = (data['deadline'] as Timestamp?)?.toDate() ?? DateTime.now();
    
    TaskPriority priorityEnum;
    if (data['priority'] is int) {
      switch (data['priority']) {
        case 3:
          priorityEnum = TaskPriority.high;
          break;
        case 2:
          priorityEnum = TaskPriority.medium;
          break;
        case 1:
          priorityEnum = TaskPriority.low;
          break;
        default:
          priorityEnum = TaskPriority.medium;
      }
    } else {
      priorityEnum = TaskPriority.values.firstWhere(
        (e) => e.toString().split('.').last == data['priority'],
        orElse: () => TaskPriority.medium,
      );
    }

    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      courseId: data['subjectId'] ?? data['courseId'] ?? '',
      deadline: deadlineDate,
      priority: priorityEnum,
      completed: data['completed'] ?? false,
      description: data['description'],
      notes: data['notes'],
      authorId: data['authorId'] ?? '',
      attachmentUrls: (data['attachmentUrls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
  int priorityValue;
  switch (priority) {
    case TaskPriority.high:   priorityValue = 3; break;
    case TaskPriority.medium: priorityValue = 2; break;
    case TaskPriority.low:    priorityValue = 1; break;
  }

  return {
    'title': title,
    'courseId': courseId,
    'deadline': Timestamp.fromDate(deadline),
    'priority': priorityValue,
    'completed': completed,
    'description': description,
    'notes': notes,
    'authorId': authorId,
    'attachmentUrls': attachmentUrls,
  };
}
  
  Task copyWith({
    String? id,
    String? title,
    String? courseId,
    DateTime? deadline,
    TaskPriority? priority,
    bool? completed,
    String? description,
    String? notes,
    String? authorId,
    List<String>? attachmentUrls,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      courseId: courseId ?? this.courseId,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      authorId: authorId ?? this.authorId,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
    );
  }
}