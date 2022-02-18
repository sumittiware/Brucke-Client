import 'dart:async';

import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Auth/signup.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/loadingScreen.dart';
import 'package:brucke_app/sheetsconfig/sheets_api.dart';
import 'package:brucke_app/sheetsconfig/userfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool resend = false;
  int time = 59;
  Timer otpTimer;
  User user;

  handleEmailVerification() {
    // otpTimer.cancel();
    setState(() {
      resend = false;
    });
    user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      checkEmailVerified();
      if (time == 0) {
        setState(() {
          timer.cancel();
          resend = true;
        });
      } else {
        setState(() {
          time--;
        });
      }
    });
  }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser;
    final appuser = Provider.of<AuthProvider>(context, listen: false).appuser;
    await user.reload();
    if (user.emailVerified) {
      SheetsApi.addUserToApp({
        UserFields.id: await SheetsApi.getRowCount() + 1,
        UserFields.uid: FirebaseAuth.instance.currentUser.uid ?? "",
        UserFields.name: appuser.name ?? "",
        UserFields.email: appuser.mailId ?? "",
        UserFields.college: appuser.college ?? ""
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return LoadingScreen();
      }));
    }
  }

  @override
  void initState() {
    handleEmailVerification();
    super.initState();
  }

  @override
  void dispose() {
    otpTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "😄 Awesome, Thanks!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: headingText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      text: TextSpan(
                          text: "Verify email address with the link send to ",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                        TextSpan(
                          text: FirebaseAuth.instance.currentUser.email,
                          style: TextStyle(color: headingText, fontSize: 20),
                        )
                      ])),
                ),
                CustomButton(
                    title: Text("Verify email"),
                    onTap: () {
                      OpenMailApp.openMailApp();
                    },
                    buttonType: ButtonType.text),
                CustomButton(
                    title: Text("Change email"),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return SignUpScreen();
                      }));
                    },
                    buttonType: ButtonType.text),
                (!resend)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                                "Didn't recive email? Resend in ${time}s")),
                      )
                    : Center(
                        child: TextButton(
                            onPressed: () {
                              handleEmailVerification();
                            },
                            child: Text("Resend Email")))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
