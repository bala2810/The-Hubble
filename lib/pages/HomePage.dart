import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/models/group.dart';
import 'package:buddiesgram/pages/CreateAccountPage.dart';
import 'package:buddiesgram/pages/CreateFamPage.dart';
import 'package:buddiesgram/pages/FamPage.dart';
import 'package:buddiesgram/pages/NotificationsPage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/pages/SearchPage.dart';
import 'package:buddiesgram/pages/TimeLinePage.dart';
import 'package:buddiesgram/pages/UploadPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
final GoogleSignIn gSignIn=GoogleSignIn();
final usersReference=Firestore.instance.collection('users');
final DateTime timestamp =DateTime.now();
final StorageReference storageReference = FirebaseStorage.instance.ref().child('Posts Pictures');
final postsReference=Firestore.instance.collection('posts');
final activityFeedReference=Firestore.instance.collection('feed');
final commentsReference=Firestore.instance.collection('comments');
final followersReference=Firestore.instance.collection('followers');
final followingReference=Firestore.instance.collection('following');
final groupsReference=Firestore.instance.collection('groups');
User currentUser;
OurGroup group;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isSignedIn=false;


  PageController pageController;

  int getPageIndex=0;

  void initState(){
    super.initState();

    pageController=PageController();

    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError:(gError){
      print('error message'+ gError);
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print('error message'+ gError);

    });

  }
  controlSignIn(GoogleSignInAccount signInAccount) async {
    if(signInAccount != null)
    {
      await saveUserInfoToFirestore();

      setState(() {
        isSignedIn=true;
      });

    }
    else
    {
      isSignedIn=false;
    }
  }

//saving user info to firestore
  saveUserInfoToFirestore() async{
    final GoogleSignInAccount gCurrentUser=gSignIn.currentUser;
    DocumentSnapshot documentSnapshot=await usersReference.document(gCurrentUser.id).get();

    if(!documentSnapshot.exists){
      final username=await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAccountPage()));


      usersReference.document(gCurrentUser.id).setData({
        "id":gCurrentUser.id,
        "profileName":gCurrentUser.displayName,
        "username":username,
        "groupName":"",
        "url":gCurrentUser.photoUrl,
        "email":gCurrentUser.email,
        "bio":"",
        "timestamp":timestamp,
      });

      documentSnapshot=await usersReference.document(gCurrentUser.id).get();
    }
    currentUser=User.fromDocument(documentSnapshot);
  }
//creating group
  createGroup() async{
    final GoogleSignInAccount gCurrentUser=gSignIn.currentUser;
    List<String> members=List();
    final groupName = await Navigator.push(context, MaterialPageRoute(builder: (context)=>OurCreateGroup()));

    members.add(gCurrentUser.id);
    DocumentReference _docRef= await groupsReference.add({
      'name':groupName,
      'leader':gCurrentUser.id,
      'members':members,
      'groupCreated':Timestamp.now()
      });
      await usersReference.document(gCurrentUser.id).updateData({
        'groupId':_docRef.documentID,
      });
  }
//joining grp
  joinGroup(String groupId) async{
    final GoogleSignInAccount gCurrentUser=gSignIn.currentUser;
    List<String> members = List();

      members.add(gCurrentUser.id);
      await groupsReference.document(groupId).updateData({
        'members':FieldValue.arrayUnion(members)
      });
      await usersReference.document(gCurrentUser.id).updateData({
      'groupId':groupId,
      });

  }


  void dispose(){
    pageController.dispose();
    super.dispose();
  }


  loginUser(){
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex=pageIndex;
    });
  }

  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
    
  }

  Scaffold buildHomeScreen(){

    return Scaffold(
      body : PageView(

        children:<Widget>[
          TimeLinePage(),
          //RaisedButton(onPressed:()=>logoutUser(),label:Text('logout')),
          //RaisedButton.icon(onPressed:()=> logoutUser, icon: Icon(Icons.close), label:Text("log.out")),
          SearchPage(),
          UploadPage(gCurrentUser: currentUser,),
          NotificationsPage(),
          ProfilePage(userProfileId: currentUser.id,),
          FamPage(userProfileId: currentUser.id,),
        ],
        controller:pageController,
        onPageChanged: whenPageChanges,
        physics:NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap:onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.home)),
          BottomNavigationBarItem(icon:Icon(Icons.search)),
          BottomNavigationBarItem(icon:Icon(Icons.add_box_rounded,size:40)),
          BottomNavigationBarItem(icon:Icon(Icons.favorite)),
          BottomNavigationBarItem(icon:Icon(Icons.account_circle)),
          BottomNavigationBarItem(icon:Icon(Icons.group))
        ],

      ),
    );
    //return
  }

  Scaffold buildSignedInScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end:Alignment.bottomLeft,
            colors: [Colors.red ,Colors.black26, Colors.blue],
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hubble",
              style:TextStyle(fontSize: 92,color:Colors.white, fontFamily: "BigShouldersStencilDisplay-Black" )
            ),
            GestureDetector(
              onTap: loginUser,
              child: Container(
                width:270,
                height:65,
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image:AssetImage("assets/images/google_signin_button.png"),
                    fit:BoxFit.cover,


                  )
                ),

              )
            )
          ],
        ),
      ),
    );
  }


  Widget build(BuildContext context){
    if(isSignedIn)
    {
      return buildHomeScreen();
    }
    else
    {
      return buildSignedInScreen();
    }
  }
}
