import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final int courseId;
  final String name;
  final String teacher;
  final String? color;
  final String? semester;
  final String? description;
  final String? teacherContact;
  final String authorId;

  Lesson({
    required this.id,
    required this.courseId,
    required this.name,
    required this.teacher,
    this.color,
    this.semester,
    this.description,
    this.teacherContact,
    this.authorId = '',
  });

  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lesson(
      id: doc.id,
      courseId: (data['courseId'] is int)
          ? data['courseId']
          : int.tryParse(data['courseId']?.toString() ?? '0') ?? 0,
      name: data['name'] ?? '',
      teacher: data['teacher'] ?? '',
      color: data['color'],
      semester: data['semester'],
      description: data['description'],
      teacherContact: data['teacherContact'],
      authorId: data['authorId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'name': name,
      'teacher': teacher,
      'color': color,
      'semester': semester,
      'description': description,
      'teacherContact': teacherContact,
      'authorId': authorId,
    };
  }

  Lesson copyWith({
    String? id,
    int? courseId,
    String? name,
    String? teacher,
    String? color,
    String? semester,
    String? description,
    String? teacherContact,
    String? authorId,
  }) {
    return Lesson(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      color: color ?? this.color,
      semester: semester ?? this.semester,
      description: description ?? this.description,
      teacherContact: teacherContact ?? this.teacherContact,
      authorId: authorId ?? this.authorId,
    );
  }
}