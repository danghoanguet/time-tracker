import 'package:flutter/cupertino.dart';

class UserProfile {
  UserProfile({
    @required this.name,
    @required this.photoUrl,
    @required this.id,
  });

  final String name;
  final String id;
  final String photoUrl;

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;
    final String name = data['name'];
    final String photoUrl = data['photoUrl'];

    return UserProfile(name: name, photoUrl: photoUrl, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'id': id,
    };
  }
}
