import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson.dart';

abstract class LessonsRepository {
  Future<List<Lesson>> getLessons();
  Future<Lesson?> getLessonById(String id);
  
  Future<Lesson?> getLessonByCourseId(int courseId); 
  
  Future<void> addLesson(Lesson lesson);
  Future<void> updateLesson(Lesson lesson);
  Future<void> deleteLesson(String id);
  Stream<List<Lesson>> lessonsStream();
}

class FirestoreLessonsRepository implements LessonsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'lessons';

  @override
  Future<List<Lesson>> getLessons() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Помилка завантаження предметів: $e');
    }
  }

  @override
  Future<Lesson?> getLessonById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();
      if (doc.exists) {
        return Lesson.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Помилка завантаження предмета: $e');
    }
  }

  @override
  Future<Lesson?> getLessonByCourseId(int courseId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return Lesson.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Помилка пошуку предмета: $e');
    }
  }

  @override
  Future<void> addLesson(Lesson lesson) async {
    try {
      await _firestore.collection(_collectionName).add(lesson.toFirestore());
    } catch (e) {
      throw Exception('Помилка додавання предмета: $e');
    }
  }

  @override
  Future<void> updateLesson(Lesson lesson) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(lesson.id)
          .update(lesson.toFirestore());
    } catch (e) {
      throw Exception('Помилка оновлення предмета: $e');
    }
  }

  @override
  Future<void> deleteLesson(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Помилка видалення предмета: $e');
    }
  }

  @override
  Stream<List<Lesson>> lessonsStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList(),
        );
  }
}