import 'package:cloud_firestore/cloud_firestore.dart';

enum EventType { lecture, practical, lab, consultation, exam }

class Event {
  final String id;
  final String courseId;
  final String name;
  final EventType type;
  final DateTime startTime;
  final DateTime endTime;
  final String auditorium;
  final String authorId;
  final int priority;

  Event({
    required this.id,
    required this.courseId,
    this.name = '',
    required this.type,
    required this.startTime,
    required this.endTime,
    this.auditorium = '',
    required this.authorId,
    this.priority = 1,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw StateError('Missing data for Event document with ID: ${doc.id}');
    }

    DateTime parseTime(dynamic timestamp) {
      if (timestamp is Timestamp) return timestamp.toDate();
      return DateTime.now();
    }

    EventType typeEnum = EventType.lecture;
    if (data['type'] != null && data['type'].toString().isNotEmpty) {
      typeEnum = EventType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => EventType.lecture,
      );
    }

    return Event(
      id: doc.id,
      courseId: data['courseId']?.toString() ?? '',
      name: data['name'] ?? '',
      type: typeEnum,
      startTime: parseTime(data['start']),
      endTime: parseTime(data['end']),
      auditorium: data['auditorium'] ?? '',
      authorId: data['authorId'] ?? '',
      priority: (data['priority'] is int) ? data['priority'] : 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'name': name,
      'type': type.toString().split('.').last,
      'start': Timestamp.fromDate(startTime),
      'end': Timestamp.fromDate(endTime),
      'auditorium': auditorium,
      'authorId': authorId,
      'priority': priority,
    };
  }

  Event copyWith({
    String? id,
    String? courseId,
    String? name,
    EventType? type,
    DateTime? startTime,
    DateTime? endTime,
    String? auditorium,
    String? authorId,
    int? priority,
  }) {
    return Event(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      auditorium: auditorium ?? this.auditorium,
      authorId: authorId ?? this.authorId,
      priority: priority ?? this.priority,
    );
  }
}