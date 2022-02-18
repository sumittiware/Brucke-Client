import 'package:brucke_app/Models/Internships.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/internshipcard.dart';
import 'package:brucke_app/common/drawer.dart';
import 'package:brucke_app/common/emptylist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedInternshipScreen extends StatefulWidget {
  @override
  _SavedInternshipScreenState createState() => _SavedInternshipScreenState();
}

class _SavedInternshipScreenState extends State<SavedInternshipScreen> {
  @override
  Widget build(BuildContext context) {
    final feedprovider = Provider.of<FeedsProvider>(context);
    List<Internship> savedInternship = feedprovider.getSaved() ?? [];
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: headingText, size: 40),
        elevation: 4,
        backgroundColor: Colors.white,
        title: Text(
          "Saved Internships",
          style: TextStyle(color: headingText, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(),
      body: (savedInternship.length == 0)
          ? EmptyList(
              message: "No Internship Saved",
            )
          : ListView(
              children: List.generate(savedInternship.length, (index) {
                return InternshipCard(
                  id: savedInternship[index].id,
                );
              }),
            ),
    );
  }
}
