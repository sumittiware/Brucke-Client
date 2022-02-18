import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/feedScreen.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FeedsProvider feedProvider;
  bool loading = true;
  AuthProvider auth;

  initData() async {
    try {
      auth = Provider.of<AuthProvider>(context, listen: false);
      feedProvider = Provider.of<FeedsProvider>(context, listen: false);
      await auth.fetchUser();
      await feedProvider.fetchCategories();
      await feedProvider.fetchInternships();
      await feedProvider.fetchSavedInternships();
      await getCollegeById(auth.currentUser.college);

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return FeedsScreen();
      }));
    } on FirebaseException catch (err) {
      showCustomSnackBar(context, err.message);
    } catch (err) {
      showCustomSnackBar(context, err.toString());
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(image: AssetImage("assets/icons/logo.png")),
        SizedBox(
          height: 28,
        ),
        SpinKitWave(
          color: buttonBlue,
          size: 50,
        )
      ],
    )));
  }
}
