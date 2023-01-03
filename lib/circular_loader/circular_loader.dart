import 'package:flutter/material.dart';

class CircularLoader {
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Container(
                color: Colors.transparent,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          ),
        );
      },
    );
  }
}