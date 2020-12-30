import 'package:buddiesgram/models/group.dart';
import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

class EditProfilePage extends StatefulWidget {
  final String currentGroupName;
  final String currentOnlineUserId;
  EditProfilePage({
    this.currentOnlineUserId,
    this.currentGroupName
});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  TextEditingController groupNameTextEditingController=TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  OurGroup group;
  bool _bioValid = true;
  bool _profileNameValid = true;



  void initState(){
    super.initState();

    getAndDisplayUserInfo();
  }
  getAndDisplayUserInfo()async{
    setState(() {
      loading=true;
    });
    DocumentSnapshot documentSnapshot=await usersReference.document(widget.currentOnlineUserId).get();
    user=User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text=user.profileName;
    bioTextEditingController.text=user.bio;


    setState(() {
      loading=false;
    });

  }





  updateUserData() {
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 || profileNameTextEditingController.text.isEmpty ? _profileNameValid = false : _profileNameValid = true;

      bioTextEditingController.text.trim().length > 110 ? _bioValid = false : _bioValid = true;
    });

    if(_bioValid && _profileNameValid){
      usersReference.document(widget.currentOnlineUserId).updateData({
        'profileName':profileNameTextEditingController.text,
        'bio':bioTextEditingController.text,

      });

      SnackBar successSnackBar = SnackBar(content: Text('Profile has Been successfully update.'));
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldGlobalKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Edit profile', style: TextStyle(color: Colors.white),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.done, color: Colors.white, size: 25,),
              onPressed: () => Navigator.pop(context),),
          ],
        ),
        body: loading ? circularProgress() : ListView(
          children: <Widget>[
            Container(
                child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 7),
                          child: CircleAvatar(radius: 52, backgroundImage: CachedNetworkImageProvider(user.url),)
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(children: <Widget>[
                          createProfileNameTextFormField(),
                          createBioTextFormField(),
                        ],),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 29, left: 50, right: 50),
                          child: RaisedButton(
                              onPressed: updateUserData,
                              child: Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                          child: RaisedButton(
                              color: Colors.redAccent,
                              onPressed: logoutUser,
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )
                          )
                      )
                    ]
                )
            )
          ],
        )

    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<ScaffoldState>>(
        '_scaffoldGlobalKey', _scaffoldGlobalKey));
  }

  logoutUser()async{
    await gSignIn.signOut();
    Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
  }

  Column createProfileNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            'Profile Name', style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
            hintText: "Enter profile name here...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _profileNameValid ? null : 'Profile name is very short',

          ),
        )
      ],
    );
  }


  Column createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            'Bio', style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: bioTextEditingController,
          decoration: InputDecoration(
            hintText: "Express about yourself...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _bioValid ? null : 'Bio is too long',

          ),
        )
      ],
    );
  }
}