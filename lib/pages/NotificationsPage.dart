import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/PostScreenPage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Activity"),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot)
          {
            if(!dataSnapshot.hasData){return circularProgress();}
            return ListView(children: dataSnapshot.data,);
          }
        ),
      ),
    );
  }

  retrieveNotifications() async{
    QuerySnapshot querySnapshot=await activityFeedReference.document(currentUser.id).collection('feedItems').orderBy('timestamp', descending: true).limit(60).getDocuments();

    List<NotificationsItem> notificationsItems=[];
    querySnapshot.documents.forEach((document) {
      notificationsItems.add(NotificationsItem.fromDocument(document));
    });
    return notificationsItems;
  }
}

class NotificationsItem extends StatelessWidget {

  final String username;
  final String type;
  final String commentDate;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  NotificationsItem({
    this.username,
    this.url,
    this.timestamp,
    this.postId,
    this.commentDate,
    this.userId,
    this.type,
    this.userProfileImg
});
  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot){
    return NotificationsItem(
      username: documentSnapshot['username'],
      type: documentSnapshot['type'],
      commentDate: documentSnapshot['commentDate'],
      postId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      userProfileImg: documentSnapshot['userProfileImg'],
      url: documentSnapshot['url'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  Widget mediaPreview;
  String notificationItemText;

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color:Colors.white,
        child: ListTile(
          title: GestureDetector(
            onTap: ()=> displayUserProfile(context,userProfileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black),
                children:[
                  TextSpan(text:username,style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan( text: ' $notificationItemText'),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(tAgo.format(timestamp.toDate()),overflow: TextOverflow.ellipsis,),
          trailing: mediaPreview,
        ),

      ),
    );


  }
  configureMediaPreview(BuildContext context){
    if(type=='comment'|| type=='like'){
      mediaPreview=GestureDetector(
        onTap:()=> displayFullPost(context),
        child: Container(
          height:50,
          width: 50,
          child: AspectRatio(
              aspectRatio: 16/9,
              child:Container(
                decoration: BoxDecoration(
                  image:DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(url)),
                ),
              )
          ),
        ),
      );
    }
    else{
      mediaPreview=Text('');
    }
    if(type=='like'){
      notificationItemText='liked your photo';
    }

    else if(type=='comment'){
      notificationItemText='commented on your photo';
    }

    else if(type=='follow'){
      notificationItemText='started following you.';
    }
    else{
      notificationItemText='unknown type : $type';
    }
  }
  displayFullPost(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreenPage(postId: postId,userId: userId,)));
  }
  displayUserProfile(BuildContext context,{String userProfileId}){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(userProfileId: userProfileId,)));
  }
}
