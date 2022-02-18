import 'package:brucke_app/Styles/colors.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;
  EmptyList({this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 70,
            color: borderBlue,
          ),
          Text(
            message,
            style: TextStyle(color: headingText, fontSize: 17),
          )
        ],
      ),
    );
  }
}
