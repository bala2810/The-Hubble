import 'dart:async';

import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OurJoinGroup extends StatefulWidget {
  @override
  _OurJoinGroupState createState() => _OurJoinGroupState();
}

class _OurJoinGroupState extends State<OurJoinGroup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String groupId;

  submitGroupId()async{
    final form=_formKey.currentState;
    if(form.validate())
    {
      form.save();
      Timer(Duration(seconds: 4),(){
        Navigator.pop(context, groupId);
      });
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
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        key:_scaffoldKey,
        appBar: header(context, strTitle: "Settings" , disappearedBackButton:false),
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
                                    return "Username is very short.";
                                  }
                                  else if(val.trim().length>40){
                                    return "Username is very long. ";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onSaved:(val)=> groupId=val,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color:Colors.white),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Group id',
                                  labelStyle: TextStyle(fontSize: 16),
                                  hintText: 'enter id ',
                                  hintStyle: TextStyle(color:Colors.blueGrey),
                                ),
                              )

                          )
                      )

                  ),
                  GestureDetector(
                      onTap: submitGroupId,
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
                                  'Join->',
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