import 'package:careAsOne/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CircularLoaderWithMessage{
  void showAlert(BuildContext context) {
    showDialog(
        context: context,

        barrierDismissible: false,
        builder: (context) => AlertDialog(
backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(

            color: Colors.transparent,
            height: 50,
            width: 50,
            child:
                Container(color: Colors.transparent,
                    height:50,child: Center(child: Image.asset("assets/images/sent_msg.gif"))),
          ),
        ));
  }
}