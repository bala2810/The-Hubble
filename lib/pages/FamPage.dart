import 'package:buddiesgram/models/group.dart';
import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/EditFamPage.dart';
import 'package:buddiesgram/pages/EditProfilePage.dart';

import 'package:buddiesgram/pages/HomePage.dart';

import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/PostTileWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class FamPage extends StatefulWidget {


  final String userProfileId;
  FamPage({this.userProfileId  });
  @override
  _FamPageState createState() => _FamPageState();
}

class _FamPageState extends State<FamPage> {
  final String currentOnlineUserId=currentUser.id;
  bool loading=false;
  int countPost=0;
  List<Post> postsList = [];
  String postOrientation='grid';
  int countTotalFollowers=0;
  int countTotalFollowing=0;
  bool following=false;
  OurGroup group;
  int leaders;



  void initState(){
    getAllMembers();
    getAllProfilePosts();
    getAllFollowers();
    getAllFollowing();
    checkIfAlreadyFollowing();
  }
  getAllFollowers()async{
    QuerySnapshot querySnapshot=await followersReference.document(widget.userProfileId)
        .collection('userFollowers').getDocuments();
    setState(() {
      countTotalFollowers=querySnapshot.documents.length;
    });

  }

  getAllFollowing()async{
    QuerySnapshot querySnapshot=await followingReference.document(widget.userProfileId)
        .collection('userFollowing').getDocuments();
    setState(() {
      countTotalFollowing=querySnapshot.documents.length;
    });
  }

  checkIfAlreadyFollowing()async{
    DocumentSnapshot documentSnapshot=await followersReference
        .document(widget.userProfileId).collection('userFollowers')
        .document(currentOnlineUserId).get();
    setState(() {
      following=documentSnapshot.exists;
    });
  }


  createProfileTopView()
  {

    return FutureBuilder(
        future:usersReference.document(widget.userProfileId).get(),
        builder:(context,dataSnapshot){
          if(!dataSnapshot.hasData){
            return circularProgress();
          }
          User user= User.fromDocument(dataSnapshot.data);
          OurGroup group=OurGroup.fromDocument(dataSnapshot.data);

          return Padding(
              padding: EdgeInsets.all(17),
              child:Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(

                        height:180,
                        width: 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),

                          image: DecorationImage(
                            
                            image: CachedNetworkImageProvider(user.url),
                          ),

                        ),
                      ),

                      Container(

                          child:Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  createColumns('members', leaders),
                                  createColumns("posts",countPost),
                                  createColumns("followers",countTotalFollowers),
                                  createColumns("following",countTotalFollowing),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  createButton(),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('$leaders',style: TextStyle(color: Colors.white),)
                                ],
                              )

                            ],
                          )
                      )

                    ],
                  ),



                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top:13),
                    child: Text(
                        group.name,style:TextStyle(fontSize: 17,color:Colors.white,fontWeight: FontWeight.bold)

                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top:3),
                    child: Text(
                        user.bio,style:TextStyle(fontSize: 14,color:Colors.white70)

                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage:CachedNetworkImageProvider(user.url) ,
                      ),
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage:CachedNetworkImageProvider(user.url) ,
                      ),

                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage:CachedNetworkImageProvider(user.url) ,
                      ),
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage:CachedNetworkImageProvider(user.url) ,
                      ),
                      CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage:CachedNetworkImageProvider(user.url) ,
                      ),



                    ],
                  ),


                ],

              )
          );
        }
    );
  }
  Column createColumns(String title,int count ){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize:20,color:Colors.white,fontWeight: FontWeight.bold),

        ),
        Container(
            margin:EdgeInsets.only(top:5),
            child:Text(
              title,
              style:TextStyle(fontSize: 16,color:Colors.blueGrey,fontWeight: FontWeight.w400),

            )

        )
      ],
    );

  }
  createButton(){
    bool ownProfile=currentOnlineUserId==widget.userProfileId;
    if(ownProfile){
      return createButtonTitleAndFunction(title:'Edit Your Fam',performFunction:editUserProfile,);
    }
    else if(following){
      return createButtonTitleAndFunction(title:"Unfollow",performFunction:controlUnfollowUser,);
    }
    else if(!following){
      return createButtonTitleAndFunction(title:"Follow",performFunction:controlFollowUser,);
    }
  }

  controlUnfollowUser(){
    setState(() {
      following=false;
    });
    followersReference.document(widget.userProfileId)
        .collection('userFollowers')
        .document(currentOnlineUserId)
        .get()
        .then((document){
      if(document.exists)
      {
        document.reference.delete();
      }
    });
    followingReference.document(currentOnlineUserId)
        .collection('userFollowing')
        .document(widget.userProfileId)
        .get()
        .then((document){
      if(document.exists)
      {
        document.reference.delete();
      }
    });
    activityFeedReference.document(widget.userProfileId).collection('feedItems')
        .document(currentOnlineUserId).get().then((document){
      if(document.exists){document.reference.delete();}
    });


  }


  controlFollowUser(){
    setState(() {
      following=true;
    });
    followersReference.document(widget.userProfileId).collection('userFollowers')
        .document(currentOnlineUserId)
        .setData({});

    followingReference.document(currentOnlineUserId).collection('userFollowing')
        .document(widget.userProfileId)
        .setData({});

    activityFeedReference.document(widget.userProfileId).collection('feedItems')
        .document(currentOnlineUserId)
        .setData({
      'type':'follow',
      'ownerId':widget.userProfileId,
      'username':currentUser.username,
      'timestamp':DateTime.now(),
      'userProfileImg':currentUser.url,
      'userId':currentOnlineUserId,
    });
  }


  Container createButtonTitleAndFunction({String title,Function performFunction}){
    return Container(
        padding:EdgeInsets.only(top:3),
        child:FlatButton(
            onPressed:performFunction,
            child:Container(
              width: 245,
              height: 26,
              child:Text(title, style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:following? Colors.black:Colors.blue,
                  border:Border.all(color:Colors.grey),
                  borderRadius: BorderRadius.circular(7)
              ),
            )
        )
    );

  }

  editUserProfile()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditFamPage(currentOnlineUserId:currentOnlineUserId)));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "FamPage"),
        body:ListView(
          children: <Widget>[
            createProfileTopView(),
            Divider(),
            createListAndGridPostOrientation(),
            Divider(height: 0,),
            displayProfilePost(),
          ],
        )
    );
  }
  displayProfilePost()
  {
    if(loading)
    {
      return circularProgress();
    }
    else if (postsList.isEmpty)
    {
      return Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.photo_library, color:Colors.grey, size: 200,),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('No post',style: TextStyle(color:Colors.grey,fontSize: 40,fontWeight: FontWeight.bold), ),
              ),

            ],
          )
      );
    }
    else if (postOrientation=='grid'){
      List<GridTile> gridTilesList=[];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    }
    else if (postOrientation=='list'){
      return Column(
        children: postsList,
      );
    }
  }
  getAllMembers()async{
    setState(() {
      loading=true;
    });
    QuerySnapshot query= await groupsReference.document('groups').collection('name').getDocuments();
    print (query);
    setState(() {
      leaders=query.documents.length ;
    });
  }
  getAllProfilePosts()async{
    setState(() {
      loading=true;
    });
    QuerySnapshot querySnapshot=await postsReference.document(widget.userProfileId).collection('usersPosts').orderBy('timestamp',descending: true).getDocuments();
    setState(() {
      loading=false;
      countPost=querySnapshot.documents.length;
      postsList=querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });
  }
  createListAndGridPostOrientation(){
    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        IconButton(
          onPressed: ()=> setOrientation('grid'),
          icon:Icon(Icons.grid_on),
          color: postOrientation=='grid'? Theme.of(context).primaryColor:Colors.grey,
        ),
        IconButton(
          onPressed: ()=> setOrientation('list'),
          icon:Icon(Icons.list),
          color: postOrientation=='list'? Theme.of(context).primaryColor:Colors.grey,
        )
      ],
    );
  }
  setOrientation(String Orientation){
    setState(() {
      this.postOrientation=Orientation;
    });
  }
}
