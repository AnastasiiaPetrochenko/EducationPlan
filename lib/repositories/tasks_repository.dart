import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

abstract class TasksRepository {
  // Отримання всіх завдань для поточного користувача в реальному часі
  Stream<List<Task>> getTasksStream(String userId); 
  
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task?> getTaskById(String id);
}

class FirestoreTasksRepository implements TasksRepository {
  final CollectionReference _tasksCollection = 
      FirebaseFirestore.instance.collection('tasks');

  @override
  Stream<List<Task>> getTasksStream(String userId) {
 
    return _tasksCollection
        .where('authorId', isEqualTo: userId)
        .orderBy('deadline', descending: false)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList()
        );
  }

  @override
  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toFirestore());
  }
  
  @override
  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toFirestore());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }
  
  @override
  Future<Task?> getTaskById(String id) async {
    final doc = await _tasksCollection.doc(id).get();
    if (doc.exists) {
      return Task.fromFirestore(doc);
    }
    return null;
  }
}