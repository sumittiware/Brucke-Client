import 'package:brucke_app/Models/Internships.dart';
import 'package:brucke_app/Models/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedsProvider with ChangeNotifier {
  List<String> _categories = ["All"];
  List<Internship> _allInternships = [];
  List<String> _savedIds = [];
  String _currentCategory = "All";

  List<String> get categories {
    return [..._categories];
  }

  String get currentCategory {
    return _currentCategory;
  }

  List<String> get savedIds {
    return [..._savedIds];
  }

  setCurrentCategory(int index) {
    _currentCategory = _categories[index];
    notifyListeners();
  }

  Internship getById(String id) {
    return _allInternships.firstWhere((element) => element.id == id);
  }

  bool isSaved(String id) {
    return _savedIds.contains(id);
  }

  Future<void> fetchCategories() async {
    final categoriesref = FirebaseFirestore.instance.collection("Categories");
    final data = await categoriesref.get();
    data.docs.forEach((element) {
      _categories.add(element['name']);
    });
    notifyListeners();
  }

  Future<void> fetchInternships() async {
    _allInternships.clear();
    final internshipref = FirebaseFirestore.instance.collection("Internships");
    final data = await internshipref.get();
    data.docs.forEach((element) async {
      final companyResult = await FirebaseFirestore.instance
          .collection("Companies")
          .doc(element.data()["company"])
          .get();
      final company = Company.formJSON(companyResult.id, companyResult.data());
      final newInternship = Internship(
          id: element.id,
          name: element.data()["name"] ?? "",
          category: element.data()["category"] ?? "",
          stipend: element.data()["stipend"] ?? "",
          location: element.data()["location"] ?? "",
          duration: element.data()["duration"] ?? "",
          isActive: element.data()["isActive"] ?? false,
          isInApp: element.data()["isInApp"] ?? false,
          company: company,
          registrationLink: element.data()["registrationLink"] ?? "",
          requiredCredits: element.data()["requiredCredits"] ?? "",
          description: deltaFromJson(element.data()["description"]),
          closeDate: DateTime.parse(element.data()["applicationClosingDate"]),
          startDate: DateTime.parse(element.data()["startingDate"]));
      if (newInternship.isActive) {
        _allInternships.add(newInternship);
      }
    });
    notifyListeners();
  }

  Future<void> fetchSavedInternships() async {
    final prefs = await SharedPreferences.getInstance();
    _savedIds = prefs.getStringList("savedInternship") ?? [];
    notifyListeners();
  }

  Future<void> toogleSavedInternships(String id, bool alreadyExist) async {
    final prefs = await SharedPreferences.getInstance();
    (!alreadyExist) ? _savedIds.add(id) : _savedIds.remove(id);
    prefs.setStringList("savedInternship", _savedIds);
    notifyListeners();
  }

  List<Internship> getSaved() {
    List<Internship> savedInternship = [];
    _allInternships.forEach((internship) {
      if (_savedIds.contains(internship.id)) {
        savedInternship.add(internship);
      }
    });
    return savedInternship;
  }

  List<Internship> getApplied(
      List<Map<String, dynamic>> appliedIds, String filter) {
    List<Internship> applied = [];
    _allInternships.forEach((element) {
      appliedIds.forEach((value) {
        if (value["id"] == element.id) {
          if (value["id"] == element.id && value["status"] == filter) {
            applied.add(element);
          }
        }
      });
    });
    return applied;
  }

  List<Internship> getbyCategory() {
    return (_currentCategory == "All")
        ? _allInternships
        : _allInternships.where((element) {
            return element.category == _currentCategory;
          }).toList();
  }
}
