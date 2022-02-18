import 'package:brucke_app/Styles/colors.dart';
import 'package:flutter/material.dart';

enum ButtonType { outlined, text }
enum ButtomShape { rounded, sharp }

class CustomButton extends StatelessWidget {
  final Widget title;
  final Function onTap;
  final ButtonType buttonType;
  final double width;
  final EdgeInsets padding;

  CustomButton(
      {@required this.title,
      @required this.onTap,
      @required this.buttonType,
      this.padding,
      this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Padding(
        padding: padding ?? EdgeInsets.all(8),
        child: OutlinedButton(
          onPressed: onTap,
          child: title,
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(16),
              side: BorderSide(color: buttonBlue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              primary:
                  (buttonType == ButtonType.text) ? Colors.white : buttonBlue,
              backgroundColor:
                  (buttonType == ButtonType.text) ? buttonBlue : Colors.white),
        ),
      ),
    );
  }
}
