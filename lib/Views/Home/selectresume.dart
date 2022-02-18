import 'dart:io';
import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectResume extends StatefulWidget {
  @override
  _SelectResumeState createState() => _SelectResumeState();
}

class _SelectResumeState extends State<SelectResume> {
  File resume;
  AuthProvider currentUser;
  bool loading = false;

  Future<void> getResume() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );
    if (file != null) {
      setState(() {
        resume = File(file.paths[0]);
      });
    }
  }

  Future<void> upload() async {
    setState(() {
      loading = true;
    });
    try {
      final url = await uploadResume(resume);
      await currentUser.updateUser({"resumeUrl": url});
      currentUser.appuser.resumeUrl = url;
    } on FirebaseException catch (e) {
      showCustomSnackBar(context, e.message);
    }

    setState(() {
      loading = false;
      resume = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: headingText, size: 40),
        elevation: 4,
        backgroundColor: Colors.white,
        title: Text(
          "Select Resume",
          style: TextStyle(color: headingText, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select Resume to continue"),
            CustomButton(
              title: Text("Check current Resume"),
              onTap: () {
                (currentUser.appuser.resumeUrl == "")
                    ? showCustomSnackBar(context, "Resume not present")
                    : launch(currentUser.appuser.resumeUrl);
              },
              buttonType: ButtonType.outlined,
            ),
            CustomButton(
              title: Text("Change Resume"),
              onTap: () {
                getResume();
              },
              buttonType: ButtonType.outlined,
            ),
            CustomButton(
              title: (loading)
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : Text((resume == null) ? "Proceed" : "Upload"),
              onTap: () async {
                if (resume != null) {
                  await upload();
                }
                Navigator.pop(context, true);
              },
              buttonType: ButtonType.text,
            ),
          ],
        ),
      ),
    );
  }
}
