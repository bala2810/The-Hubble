import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding:EdgeInsets.only(top:12),
    child:CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),)

  );


  //return Text("circular progress");
}

linearProgress() {
  return Container(
      alignment: Alignment.center,
      padding:EdgeInsets.only(top:12),
      child:LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),)

  );//return Text("linear progress");
}
