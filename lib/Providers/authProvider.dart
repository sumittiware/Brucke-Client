import 'package:brucke_app/Models/appuser.dart';
import 'package:brucke_app/firebase.dart';
import 'package:brucke_app/sheetsconfig/sheets_api.dart';
import 'package:brucke_app/sheetsconfig/userfields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  AppUser appuser;

  // returns the current user
  AppUser get currentUser {
    return appuser;
  }

  // isAuthenticated
  bool isAuthenticated() {
    return (FirebaseAuth.instance.currentUser == null) ? false : true;
  }

  Future<User> signUp(
      String name, String college, String mailId, String password) async {
    String ext = collegeMap[college];
    if (!mailId.contains(ext)) {
      throw "Enter college mailId only!!";
    }
    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mailId.trim(), password: password.trim());
      // after creating store data to firestore
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(userCredential.user.uid)
          .set({"name": name, "mailId": mailId, "college": college});
      // store the user data to google sheet
      appuser = AppUser(
        name: name,
        college: college,
        mailId: mailId,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message;
    }
  }

  // signin method
  Future<User> signIn(String mailId, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: mailId.trim(), password: password.trim());
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else {
        throw "Error occured!!";
      }
    }
  }

  // signOut
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // set User
  Future<void> setUser(AppUser user) async {
    final useref =
        FirebaseFirestore.instance.collection("Students").doc(user.uid);
    try {
      await useref.set({
        "uid": user.uid,
        "name": user.name,
        "college": user.college,
        "branch": user.branch,
        "mailId": user.mailId,
        "yograduation": user.yearofgraduation,
        "categories": user.categories,
        "appliedInternship": user.appliedInternships,
        "resumeUrl": user.resumeUrl,
        "credit": user.currentCredits,
        "isComplete": user.isComplete,
      });
      appuser = user;
      notifyListeners();
    } on FirebaseException catch (err) {
      throw err.message;
    } catch (err) {
      throw err.toString();
    }
  }

  // update User
  Future<void> updateUser(Map<String, dynamic> updatedData, {String id}) async {
    final useref =
        FirebaseFirestore.instance.collection("Students").doc(currentUser.uid);
    try {
      await useref.update(updatedData);
      await useref
          .collection("appliedInternship")
          .doc(id)
          .set({"status": "applied"});
    } on FirebaseException catch (err) {
      throw err.message;
    } catch (err) {
      throw err.toString();
    }
  }

  // fetch user
  Future<void> fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final useref =
        await FirebaseFirestore.instance.collection("Students").doc(uid).get();
    final userData = useref.data();
    final appliedref = await FirebaseFirestore.instance
        .collection("Students")
        .doc(uid)
        .collection("appliedInternship")
        .get();
    List<Map<String, dynamic>> appliedInternships = [];
    appliedref.docs.forEach((element) {
      appliedInternships
          .add({"id": element.id, "status": element.data()["status"]});
    });
    appuser = AppUser(
        uid: useref.id,
        name: userData["name"] ?? "",
        college: userData["college"] ?? "",
        branch: userData["branch"] ?? "",
        mailId: userData["mailId"] ?? "",
        categories: userData["categories"] ?? [],
        currentCredits: userData["credit"] ?? 30,
        yearofgraduation: userData["yograduation"] ?? "",
        resumeUrl: userData["resumeUrl"] ?? "",
        appliedInternships: appliedInternships,
        isComplete: userData["isComplete"] ?? false);
    notifyListeners();
  }

  // check weather already applied or not
  bool isApplied(String id) {
    int index =
        appuser.appliedInternships.indexWhere((element) => element['id'] == id);
    return index != -1;
  }
}
