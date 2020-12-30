import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/pages/ProfilePage.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage>
{
  TextEditingController searchTextEditingController=TextEditingController();
  Future<QuerySnapshot>futureSearchResults;

  emptyTheTextFormField(){
    searchTextEditingController.clear();
  }

  controlSearching( String str){
    Future<QuerySnapshot> allUsers=usersReference.where('profileName', isGreaterThanOrEqualTo: str).getDocuments();
    setState(() {
      futureSearchResults=allUsers;
    });

  }

  AppBar searchPageHeader(){
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style: TextStyle(fontSize: 18,color:Colors.white),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText:'Search',
          hintStyle: TextStyle(color:Colors.blueGrey),
          enabledBorder:UnderlineInputBorder(
            borderSide:BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color:Colors.white),
          ),
          filled:true,
          prefixIcon: Icon(Icons.person_pin,color:Colors.blueGrey,size: 30,),
          suffixIcon: IconButton(icon: Icon(Icons.clear, color:Colors.white,),onPressed: emptyTheTextFormField,)

        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  Container displayNoSearchResultScreen(){
    final Orientation orientation=MediaQuery.of(context).orientation;
    return Container(
      child:Center(
        child:ListView(
          shrinkWrap: true,
          children:<Widget>[
            Icon(Icons.person_outline,color:Colors.blueGrey,size: 200),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(color:Colors.white,fontWeight: FontWeight.w500,fontSize: 65),

            )
          ]
        )
      )
    );
  }
  displayUsersFoundScreen(){
    return FutureBuilder(
      future:futureSearchResults,
      builder:(context,dataSnapshot){
        if(!dataSnapshot.hasData)
        {
          return circularProgress();
        }
        List<UserResult> searchUsersResult=[];
        dataSnapshot.data.documents.forEach((document)
        {
          User eachUser=User.fromDocument(document);
          UserResult userResult=UserResult(eachUser);
          searchUsersResult.add(userResult);

        });
        return ListView(children:searchUsersResult);
      },
    );
  }

  bool get wantKeepAlive=>true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: searchPageHeader(),
      body:futureSearchResults==null ? displayNoSearchResultScreen(): displayUsersFoundScreen(),

    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child:Container(
        color:Colors.blueGrey,
        child:Column(
          children:<Widget>[
            GestureDetector(
              onTap:()=>displayUserProfile(context, userProfileId:eachUser.id),
              child:ListTile(
                leading:CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(eachUser.url),),
                title: Text(eachUser.profileName,style: TextStyle(
                  color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold,
                ),),
                subtitle: Text(eachUser.username,style:TextStyle(
                  color:Colors.black,fontSize: 13,
                ),),
              )
            )
          ]
        )

      )
    );
  }

  displayUserProfile(BuildContext context,{String userProfileId})
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(userProfileId: userProfileId,)));

  }


}