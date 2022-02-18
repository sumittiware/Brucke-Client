import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_mail_app/open_mail_app.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final String email;
  ForgetPasswordScreen({this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: headingText),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                    text: TextSpan(
                        text: "Password reset link will be send to ",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        children: [
                      TextSpan(
                        text: email.trim(),
                        style: TextStyle(color: headingText, fontSize: 20),
                      )
                    ])),
              ),
              CustomButton(
                  title: Text("Send email"),
                  onTap: () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.toString().trim())
                        .then((_) {
                      OpenMailApp.openMailApp().then((_) {
                        Navigator.pop(context);
                      });
                    }).catchError((err) {
                      showCustomSnackBar(context, err.toString());
                    });
                  },
                  buttonType: ButtonType.text)
            ],
          ),
        ),
      ),
    );
  }
}
