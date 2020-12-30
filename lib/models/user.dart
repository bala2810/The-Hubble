import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String bio;
  final String profilePic;
  final String groupId;
  final String groupName;

  User({
    this.id,
    this.profileName,
    this.username,
    this.url,
    this.email,
    this.bio,
    this.profilePic,
    this.groupId,
    this.groupName,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      username: doc['username'],
      email: doc['email'],
      url: doc['url'],
      profileName: doc['profileName'],
      bio: doc['bio'],
      profilePic: doc['profilePic'],
      groupId: doc['groupId'],
      groupName: doc['groupName'],
    );
  }
}