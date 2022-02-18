import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/internshipcard.dart';
import 'package:brucke_app/common/drawer.dart';
import 'package:brucke_app/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key key}) : super(key: key);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: headingText, size: 60),
          elevation: 4,
          backgroundColor: Colors.white,
          title: Text(
            "Internships",
            style: TextStyle(
                fontSize: 20, color: headingText, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 120,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentCollege["image"]),
                            radius: 26,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: Text(
                            currentCollege["name"],
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: collegeName),
                          ))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                          feedProvider.categories.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  feedProvider.setCurrentCategory(index);
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 18),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom:
                                                (feedProvider.currentCategory ==
                                                        feedProvider
                                                            .categories[index])
                                                    ? BorderSide(
                                                        color: Colors.blue,
                                                        width: 2)
                                                    : BorderSide.none)),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${feedProvider.categories[index]}",
                                          style: TextStyle(
                                              color: (feedProvider
                                                          .currentCategory ==
                                                      feedProvider
                                                          .categories[index])
                                                  ? Colors.blue
                                                  : Colors.black),
                                        ))),
                              )),
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size(double.infinity, 120),
          ),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Color(0xffebf4ff),
                child: ListView(
                  children: List.generate(feedProvider.getbyCategory().length,
                      (index) {
                    return InternshipCard(
                      id: feedProvider.getbyCategory()[index].id,
                    );
                  }),
                ),
              ),
            )
          ],
        ));
  }
}
