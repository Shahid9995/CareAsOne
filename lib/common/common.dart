import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({String? msg, Color? backgroundColor}) {
  Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor);
}
void showCustomToast({String? msg,BuildContext? context}){
  FToast fToast;
  fToast = FToast();
  fToast.init(context!);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.red[100],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error,color: Colors.red,),

        Container(
          width: 270,
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
            child: Text("$msg",maxLines: null,overflow: TextOverflow.fade,)),
      ],
    ),
  );


  fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 5));

}