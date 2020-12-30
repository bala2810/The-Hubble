import 'dart:async';

import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;

  submitUsername(){
    final form=_formKey.currentState;
    if(form.validate())
    {
     form.save();
     SnackBar snackBar=SnackBar(content: Text("Welcome ,"+ username));
     Timer(Duration(seconds: 4),(){
       Navigator.pop(context, username);
     });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: header(context, strTitle: "Settings" , disappearedBackButton:true),
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
                            else if(val.trim().length>15){
                              return "Username is very long. ";
                            }
                            else{
                              return null;
                            }
                          },
                          onSaved:(val)=> username=val,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:Colors.white),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 16),
                            hintText: 'must be between 5-15 characters only ',
                            hintStyle: TextStyle(color:Colors.blueGrey),
                          ),
                        )

                      )
                    )

                ),
                GestureDetector(
                  onTap: submitUsername,
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
                        'PROCEED->',
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


