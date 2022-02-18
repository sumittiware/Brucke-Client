import 'dart:ui';
import 'package:brucke_app/Views/Home/feedScreen.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/Views/Profile/profilescreen.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  final Widget header;
  final CrossAxisAlignment bodyAlignment;
  final List<Widget> body;

  CustomDialogBox({this.header, this.bodyAlignment, this.body});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: header,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: bodyAlignment ?? CrossAxisAlignment.start,
          children: body),
    );
  }
}

Future<void> alreadyApplied(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return CustomDialogBox(
          header: Text("Already applied",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          body: [
            Text(
              "You have already applied for the Internship, You will be notified after result.",
              style: TextStyle(fontSize: 16),
            ),
            CustomButton(
                title: Text("Close"),
                onTap: () {
                  Navigator.pop(context);
                },
                buttonType: ButtonType.text)
          ],
        );
      });
}

Future<void> completeProfileDialog(BuildContext context) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogBox(
          header: Text("Complete Your Profile",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          body: [
            Text(
              "To continue with application complete your profile",
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: CustomButton(
                  title: Text("Cancle"),
                  onTap: () => Navigator.pop(context),
                  buttonType: ButtonType.outlined,
                )),
                Expanded(
                  child: CustomButton(
                    title: Text("Update Profile"),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ProfileScreen();
                      }));
                    },
                    buttonType: ButtonType.text,
                  ),
                ),
              ],
            )
          ],
        );
      });
}

Future<bool> checkAndRemoveCreditDialog(
    BuildContext context, int userCredits, int requiredCredits) async {
  final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogBox(
          header: Text("$requiredCredits Credits"),
          body: [
            Text("Required to apply for this internship."),
            Text(
              "Avaliable Credits : ${userCredits.toString()}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            (userCredits < requiredCredits)
                ? Text("*Your credits not enough")
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: CustomButton(
                  title: Text("Cancle"),
                  onTap: () => Navigator.pop(context, false),
                  buttonType: ButtonType.outlined,
                )),
                (userCredits >= requiredCredits)
                    ? Expanded(
                        child: CustomButton(
                          title: Text("Proceed"),
                          onTap: () => Navigator.pop(context, true),
                          buttonType: ButtonType.text,
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        );
      });
  return result;
}

Future<void> applySucessDialog(BuildContext context) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogBox(
          bodyAlignment: CrossAxisAlignment.center,
          body: [
            Icon(
              Icons.verified_rounded,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Applied Successfully",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "You’ll Recieve a mail confirmation when you get shortlisted for the second round.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            CustomButton(
                padding: EdgeInsets.all(0),
                title: Text("Explore More"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => FeedsScreen()),
                      (Route<dynamic> route) => false);
                },
                buttonType: ButtonType.text)
          ],
        );
      });
}

Future<void> errorDialog(BuildContext context, String message) async {
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogBox(
          bodyAlignment: CrossAxisAlignment.center,
          body: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 80,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "An Error Occured",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 12,
            ),
            CustomButton(
                padding: EdgeInsets.all(0),
                title: Text("Close"),
                onTap: () {
                  Navigator.pop(context);
                },
                buttonType: ButtonType.text)
          ],
        );
      });
}
