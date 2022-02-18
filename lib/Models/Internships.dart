import 'package:brucke_app/Models/company.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Internship {
  String id;
  String name;
  String category;
  Company company;
  Delta description;
  String duration;
  String location;
  String stipend;
  String registrationLink;
  int requiredCredits;
  DateTime startDate;
  DateTime closeDate;
  bool isInApp;
  bool isActive;

  Internship({this.id,
      this.name,
      this.category,
      this.location,
      this.duration,
      this.stipend,
      this.company,
      this.description,
      this.isActive,
      this.isInApp,
      this.requiredCredits,
      this.closeDate,
      this.startDate,
      this.registrationLink});
}

Delta deltaFromJson(var jsonData) {
  var body = Delta();
  jsonData.forEach((element) {
    body.insert(element['insert'], element['attributes']);
  });
  return body;
}
