import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/appliedInternships.dart';
import 'package:brucke_app/Views/Home/feedScreen.dart';
import 'package:brucke_app/Views/Home/savedInternships.dart';
import 'package:brucke_app/Views/Profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Screens { feeds, profile, saved, applied }

Screens currentScreen = Screens.feeds;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: mediaquery.padding.top,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(Icons.close)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 26,
                  child: Image.asset("assets/icons/logosmall.png"),
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Bruke Admin",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: headingText))
              ],
            ),
          ),
          _drawerTile(Icons.work_outline_rounded, "Internships", FeedsScreen(),
              Screens.feeds),
          _drawerTile(Icons.account_circle_outlined, "My Profile",
              ProfileScreen(), Screens.profile),
          _drawerTile(Icons.verified_outlined, "Applied Internships",
              AppliedInternship(), Screens.applied),
          _drawerTile(Icons.bookmark_border_rounded, "Saved Internships",
              SavedInternshipScreen(), Screens.saved),
        ],
      ),
    );
  }

  Widget _drawerTile(
      IconData icondata, String title, Widget page, Screens screenname) {
    return GestureDetector(
      onTap: () {
        currentScreen = screenname;
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return page;
        }));
      },
      child: Container(
        color: (currentScreen == screenname) ? tileBg : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    icondata,
                    color: grey,
                    size: 22,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 22),
              width: double.infinity,
              height: 0.5,
              color: grey,
            )
          ],
        ),
      ),
    );
  }
}
