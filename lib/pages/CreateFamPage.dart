import 'dart:async';

import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OurCreateGroup extends StatefulWidget {
  @override
  _OurCreateGroupState createState() => _OurCreateGroupState();
}

class _OurCreateGroupState extends State<OurCreateGroup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String groupName;

  submitGroupName() async {
    final form=_formKey.currentState;
    if(form.validate())
    {
      form.save();
      SnackBar snackBar=SnackBar(content: Text("Welcome ,"+ groupName));
      Timer(Duration(seconds: 4),(){
        Navigator.pop(context, groupName);
      });
      final GoogleSignInAccount gCurrentUser=gSignIn.currentUser;
      List<String> members=List();


      members.add(gCurrentUser.id);
      DocumentReference _docRef= await groupsReference.add({
        'name':groupName,
        'leader':gCurrentUser.id,
        'members':members,
        'groupCreated':Timestamp.now()
      });
      await usersReference.document(gCurrentUser.id).updateData({
        'groupId':_docRef.documentID,
        'groupName':groupName
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        key:_scaffoldKey,
        appBar: header(context, strTitle: "Create Fam name " , disappearedBackButton:false),
        body:ListView(

          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top:25),
                      child:Center(
                        child:Text('Set up a username', style:TextStyle(fontSize: 26),),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(17),
                      child:Container(
                          child:Form(
                              key:_formKey,
                              autovalidate: true,
                              child:TextFormField(
                                style:TextStyle(color:Colors.white),
                                validator: (val){
                                  if(val.trim().length<5 || val.isEmpty) {
                                    return "Group Name is very short.";
                                  }
                                  else if(val.trim().length>15){
                                    return "Group Name is very long. ";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onSaved:(val)=> groupName=val,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.white),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Group Name',
                                  labelStyle: TextStyle(fontSize: 16),
                                  hintText: 'must be between 5-15 characters only ',
                                  hintStyle: TextStyle(color:Colors.blueGrey),
                                ),
                              )

                          )
                      )

                  ),
                  GestureDetector(
                      onTap: submitGroupName,
                      child:Container(
                          height:55,
                          width: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end:Alignment.bottomLeft,
                              colors: [Colors.red , Colors.blue],
                            ),
                          ),
                          child:Center(
                              child:Text(
                                  'CREATE->',
                                  style:TextStyle(
                                      color:Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          )
                      )
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}