import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id; 
  final String name;
  final String email;
  final String? avatarUrl;
  final String? timeZone;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.timeZone,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      timeZone: data['timeZone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'timeZone': timeZone,
    };
  }
}