import 'package:brucke_app/Models/Internships.dart';
import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/internshipcard.dart';
import 'package:brucke_app/common/drawer.dart';
import 'package:brucke_app/common/emptylist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppliedInternship extends StatefulWidget {
  @override
  _AppliedInternshipState createState() => _AppliedInternshipState();
}

class _AppliedInternshipState extends State<AppliedInternship> {
  String value = "applied";
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;
    final feedProvider = Provider.of<FeedsProvider>(context);
    List<Internship> appliedInternships =
        feedProvider.getApplied(currentUser.appliedInternships, value);
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        iconTheme: IconThemeData(color: headingText, size: 40),
        backgroundColor: Colors.white,
        title: Text(
          "Applied Internships",
          style: TextStyle(color: headingText, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tab(title: "Applied", tabvalue: "applied"),
                _tab(title: "Accepted", tabvalue: "accepted"),
                _tab(title: "Rejected", tabvalue: "rejected"),
              ],
            ),
            preferredSize: Size(double.infinity, 50)),
      ),
      drawer: AppDrawer(),
      body: (appliedInternships.length != 0)
          ? SingleChildScrollView(
              child: Column(
                  children: List.generate(
                      appliedInternships.length,
                      (index) => InternshipCard(
                            id: appliedInternships[index].id,
                          ))),
            )
          : EmptyList(
              message: "No Internship Applied",
            ),
    );
  }

  Widget _tab({String title, String tabvalue}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            value = tabvalue;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: BoxDecoration(
              border: Border(
                  bottom: (value == tabvalue)
                      ? BorderSide(color: buttonBlue, width: 2)
                      : BorderSide.none)),
          child: Align(
              alignment: Alignment.center,
              child: Text(title,
                  style: TextStyle(
                    color: (value == tabvalue ? buttonBlue : textBlack),
                  ))),
        ));
  }
}
