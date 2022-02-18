import 'dart:io';
import 'package:brucke_app/Models/Internships.dart';
import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Views/Home/selectresume.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/Views/Home/widget/dialogs.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/config/fromatdate.dart';
import 'package:brucke_app/config/urlauncher.dart';
import 'package:brucke_app/firebase.dart';
import 'package:brucke_app/sheetsconfig/sheets_api.dart';
import 'package:brucke_app/sheetsconfig/userfields.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:brucke_app/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class InternshipDetail extends StatefulWidget {
  final String internshipId;
  InternshipDetail({this.internshipId});
  @override
  _InternshipDetailState createState() => _InternshipDetailState();
}

class _InternshipDetailState extends State<InternshipDetail> {
  bool loading = false;
  quill.QuillController _controller;
  final scrollController = ScrollController();
  final editorFocus = FocusNode();
  AuthProvider authdata;
  Internship currentInternship;
  File resume;

  _applyForInternship() async {
    setState(() {
      loading = true;
    });
    try {
      if (authdata.isApplied(widget.internshipId)) {
        await alreadyApplied(context);
        return;
      }
      if (!authdata.currentUser.isComplete) {
        await completeProfileDialog(context);
        return;
      }
      final result = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return SelectResume();
      }));
      if (!result) {
        return;
      }
      final proceed = await checkAndRemoveCreditDialog(
          context,
          authdata.currentUser.currentCredits,
          currentInternship.requiredCredits);
      if (!proceed) {
        return;
      }
      // first apply for the internship then move forward
      await applyForInternship(widget.internshipId, authdata.currentUser);
      authdata.appuser.appliedInternships
          .add({"id": widget.internshipId, "status": "applied"});
      authdata.appuser.currentCredits -= currentInternship.requiredCredits;

      await authdata.updateUser({
        "credit": authdata.appuser.currentCredits,
        "resumeUrl": authdata.appuser.resumeUrl,
      }, id: widget.internshipId);
      await SheetsApi.addUserToInternship(widget.internshipId, {
        UserFields.id: await SheetsApi.getRowCount() + 1,
        UserFields.uid: authdata.appuser.uid,
        UserFields.name: authdata.appuser.name,
        UserFields.email: authdata.appuser.mailId,
        UserFields.college: authdata.appuser.college
      });
      applySucessDialog(context);
    } on FirebaseException catch (err) {
      setState(() {
        loading = false;
      });
      errorDialog(context, err.message);
    } catch (err) {
      setState(() {
        loading = false;
      });
      errorDialog(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = Provider.of<FeedsProvider>(context);
    authdata = Provider.of<AuthProvider>(context);
    currentInternship = feedProvider.getById(widget.internshipId);
    _controller = quill.QuillController(
        selection: TextSelection.collapsed(offset: 1),
        document: Document.fromDelta(currentInternship.description));
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: headingText, size: 40),
        elevation: 4,
        backgroundColor: Colors.white,
        title: Text(
          "Internships Details",
          style: TextStyle(color: headingText, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentInternship.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: textBlack),
                            ),
                            Text(
                              currentInternship.company.name,
                              style: TextStyle(fontSize: 16, color: textGrey),
                            ),
                          ],
                        ),
                        Image(
                            image: NetworkImage(
                                currentInternship.company.imageUrl),
                            height: 70,
                            width: 70)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildMethod(Icons.location_on_outlined, "Location",
                      currentInternship.location),
                  _buildMethod(Icons.money_outlined, "Stipend",
                      "₹ ${currentInternship.stipend}"),
                  _buildMethod(Icons.calendar_today_outlined, "Duration",
                      currentInternship.duration),
                  _buildMethod(Icons.hourglass_empty_outlined, "Apply By",
                      getFormatedDate(currentInternship.closeDate)),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                            title: Text("Apply"),
                            onTap: (currentInternship.isInApp)
                                ? () => _applyForInternship()
                                : () =>
                                    openURl(currentInternship.registrationLink)
                                        .catchError((msg) {
                                      showCustomSnackBar(context, msg);
                                    }),
                            buttonType: ButtonType.text),
                      ),
                      Expanded(
                        child: CustomButton(
                            title: Text((!feedProvider.savedIds
                                    .contains(widget.internshipId))
                                ? "Save"
                                : "Remove"),
                            onTap: () {
                              feedProvider.toogleSavedInternships(
                                  widget.internshipId,
                                  feedProvider.savedIds
                                      .contains(widget.internshipId));
                              showCustomSnackBar(
                                  context,
                                  (!feedProvider.savedIds
                                          .contains(widget.internshipId))
                                      ? "Internship added to saved"
                                      : "Intership removed from saved");
                            },
                            buttonType: ButtonType.text),
                      ),
                    ],
                  ),
                  if (currentInternship.isInApp)
                    quill.QuillEditor(
                      focusNode: editorFocus,
                      expands: false,
                      padding: EdgeInsets.all(8),
                      scrollController: scrollController,
                      scrollable: true,
                      autoFocus: true,
                      showCursor: false,
                      controller: _controller,
                      readOnly: true, // true for view only mode
                    ),
                  if (currentInternship.isInApp)
                    CustomButton(
                        title: Text("Apply Now"),
                        onTap: _applyForInternship,
                        buttonType: ButtonType.text)
                ],
              ),
            ),
          ),
          if (loading)
            Positioned.fill(
                child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                        child: SpinKitWave(
                      color: buttonBlue,
                      size: 50,
                    ))))
        ],
      ),
    );
  }

  Widget _buildMethod(IconData icon, String tag, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(children: [
            Icon(
              icon,
              color: textGrey,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              tag,
              style: TextStyle(color: textGrey, fontSize: 14),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(color: textBlack),
            )
          ]),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade400,
          )
        ],
      ),
    );
  }
}
