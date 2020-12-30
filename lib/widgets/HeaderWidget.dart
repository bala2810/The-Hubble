import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false , String strTitle , disappearedBackButton=false})
{
  return AppBar(
    iconTheme: IconThemeData(
      color:Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false: true,
    title:Text(
      isAppTitle ? "Hubble" :strTitle,
      style:TextStyle(
        color:Colors.white,
        fontFamily: isAppTitle ? "BigShouldersStencilDisplay-Black" : "BigShouldersStencilDisplay-Black",
        fontSize: isAppTitle ? 45:22,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );

}
