import 'package:cloud_firestore/cloud_firestore.dart';

class OurGroup{
  final String Gid;
  final String name;
  final String leader;
  List<String> members;
  final Timestamp groupCreated;
  final String GBio;
  final String groupPic;



  OurGroup({
    this.Gid,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
    this.GBio,
    this.groupPic
  });


  factory OurGroup.fromDocument(DocumentSnapshot doc) {
    return OurGroup(
      members: doc['members'],
      Gid: doc['groupId'],
      name: doc['groupName'],
      GBio:doc['GBio'],
      groupPic:doc['groupPic']

    );
  }
}

