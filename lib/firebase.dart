import 'dart:io';

import 'package:brucke_app/Models/appuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Map<String, String> collegeMap = {};
Map<String, String> currentCollege = {};

Future<Map<String, String>> getColleges() async {
  collegeMap.clear();
  List<String> name = [];
  List<String> ext = [];
  final collegeref =
      await FirebaseFirestore.instance.collection("Institutes").get();
  final collegeData = collegeref.docs;
  print(collegeData.toString());
  collegeData.forEach((element) {
    name.add(element["name"]);
    ext.add(element["mailExt"]);
  });
  collegeMap = Map.fromIterables(name, ext);
  return collegeMap;
}

Future<void> getCollegeById(String name) async {
  try {
    final collegeref = await FirebaseFirestore.instance
        .collection("Institutes")
        .where("name", isEqualTo: name)
        .get();
    currentCollege = {"name": "", "image": ""};
    collegeref.docs.forEach((element) {
      currentCollege = {
        "name": element.data()["name"],
        "image": element.data()["imageUrl"]
      };
    });
  } catch (err) {
    print("Error" + err.toString());
  }
}

Future<String> uploadResume(File resume) async {
  final storageRef = FirebaseStorage.instance
      .ref("Resume/${FirebaseAuth.instance.currentUser.uid}.pdf");
  try {
    await storageRef.putFile(resume);
    final resumeUrl = await storageRef.getDownloadURL();
    return resumeUrl;
  } on FirebaseException catch (e) {
    throw e.message;
  } catch (e) {
    throw e.toString();
  }
}

Future<void> applyForInternship(String internhipId, AppUser user) async {
  try {
    final internshipref = FirebaseFirestore.instance
        .collection("Internships")
        .doc(internhipId)
        .collection("AppliedStudents")
        .doc(user.uid);
    await internshipref.set({
      "name": user.name,
      "id": user.uid,
      "college": user.college,
      "email": user.mailId,
      "resume_link": user.resumeUrl
    });
  } on FirebaseException catch (err) {
    throw err.message;
  } catch (err) {
    throw err.toString();
  }
}
