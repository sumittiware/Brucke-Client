import 'package:flutter/material.dart';

showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    margin: EdgeInsets.all(8),
    backgroundColor: Colors.black54,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    duration: Duration(seconds: 5),
  ));
}
