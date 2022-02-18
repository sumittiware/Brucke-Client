import 'dart:io';
import 'package:brucke_app/Models/appuser.dart';
import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/drawer.dart';
import 'package:brucke_app/common/pdfViewer.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthProvider auth;
  AppUser appuser;
  bool loading = true;
  bool edited = false;
  bool submitting = false;
  bool editFields = false;
  File resume;
  String resumeUrl = "";
  double loadPercent = 0;
  bool firstTime = true;

  final _tileKey = GlobalKey();

  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _emailController = TextEditingController();
  final _branchController = TextEditingController();
  final _yearController = TextEditingController();

  Future<void> getResume() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ],
    );
    if (file != null) {
      setState(() {
        resume = File(file.paths[0]);
      });
    }
  }

  _saveData() async {
    setState(() {
      submitting = true;
    });
    try {
      final resumeUrl =
          (resume != null) ? await uploadResume(resume) : appuser.resumeUrl;
      final newUser = AppUser(
        uid: appuser.uid,
        name: _nameController.text,
        mailId: _emailController.text,
        college: _collegeController.text,
        branch: _branchController.text,
        categories: appuser.categories,
        yearofgraduation: _yearController.text,
        resumeUrl: resumeUrl,
        currentCredits: appuser.currentCredits,
        appliedInternships: appuser.appliedInternships,
        isComplete: true,
      );
      auth.setUser(newUser);
      showCustomSnackBar(context, "Profile Updated!!");
    } catch (err) {
      showCustomSnackBar(context, err.toString());
    }
    setState(() {
      submitting = false;
    });
  }

  vaildForm() {
    return (_nameController.text != "" &&
            _collegeController.text != "" &&
            _branchController.text != "" &&
            _yearController.text != "")
        ? true
        : false;
  }

  initControllers() {
    if (!firstTime) {
      return;
    }
    _nameController.text = appuser.name;
    _collegeController.text = appuser.college;
    _emailController.text = appuser.mailId;
    _branchController.text = appuser.branch;
    _yearController.text = appuser.yearofgraduation;
    resumeUrl = appuser.resumeUrl;
    setState(() {
      setState(() {
        loading = false;
        firstTime = false;
      });
    });
  }

  @override
  void dispose() {
    _branchController.dispose();
    _collegeController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    final feeds = Provider.of<FeedsProvider>(context);
    appuser = auth.currentUser;
    initControllers();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: headingText, size: 40),
        elevation: 4,
        backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: TextStyle(color: headingText, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      drawer: AppDrawer(),
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: CircularProgressIndicator(
                                strokeWidth: 10,
                                backgroundColor: buttonBlue,
                                color: lightBlue,
                                value: 1 - appuser.currentCredits / 30,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  appuser.currentCredits.toString(),
                                  style: TextStyle(
                                      color: headingText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                Text("credits")
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: lightBlue,
                              border: Border.all(color: borderBlue),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              "Credits have been deducted when you apply for an internship.\nCredits are re-issued every month to apply for internships.")),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Details",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  editFields = !editFields;
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.edit,
                                color: (!editFields) ? textColor : Colors.blue,
                              ))
                        ],
                      ),
                      Form(
                          child: Column(
                        children: [
                          _buildTextField(_nameController, "Name"),
                          _buildTextField(_collegeController, "College",
                              readonly: true),
                          _buildTextField(_emailController, "Email",
                              readonly: true),
                          _buildTextField(_branchController, "Major (Branch)"),
                          _buildTextField(
                              _yearController, "Year of Graduation"),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey)),
                            child: ExpansionTile(
                              title: Text((appuser.categories == null)
                                  ? "Select Tags (max 3)"
                                  : appuser.categories.join(", ")),
                              children: List.generate(
                                  feeds.categories.length,
                                  (index) => GestureDetector(
                                        onTap: () {
                                          if (appuser.categories.length == 3 &&
                                              !(appuser.categories.contains(
                                                  feeds.categories[index]))) {
                                            showCustomSnackBar(context,
                                                "3 categories already selected");
                                            return;
                                          }
                                          (appuser.categories.contains(
                                                  feeds.categories[index]))
                                              ? appuser.categories.remove(
                                                  feeds.categories[index])
                                              : appuser.categories
                                                  .add(feeds.categories[index]);
                                          setState(() {});
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: (appuser.categories
                                                      .contains(feeds
                                                          .categories[index])
                                                  ? buttonBlue
                                                  : Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              feeds.categories[index],
                                              style: TextStyle(
                                                  color: (appuser.categories
                                                          .contains(
                                                              feeds.categories[
                                                                  index])
                                                      ? Colors.white
                                                      : textBlack)),
                                            )),
                                      )),
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),
                          // _buildTextField(_tagsController, "Tags (max 3)"),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (resume != null)
                                      ? () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PDFViewerPage(file: resume);
                                          }));
                                        }
                                      : (resumeUrl != "")
                                          ? () => launch(resumeUrl)
                                          : null,
                                  child: Text(
                                    (resume == null)
                                        ? (resumeUrl == "")
                                            ? "Upload resume"
                                            : "Change resume"
                                        : resume.path.split("/").last,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: getResume,
                                    icon: Icon(
                                      Icons.upload_file,
                                      color: textColor,
                                    ))
                              ],
                            ),
                          ),
                          CustomButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 0),
                              title: (submitting)
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text("Save"),
                              onTap: (vaildForm())
                                  ? _saveData
                                  : () {
                                      showCustomSnackBar(context,
                                          "Please add all the details properly");
                                    },
                              buttonType: ButtonType.text),
                        ],
                      ))
                    ]),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readonly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: (readonly) ? true : !editFields,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
