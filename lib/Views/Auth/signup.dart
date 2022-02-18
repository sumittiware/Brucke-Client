import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Auth/signin.dart';
import 'package:brucke_app/Views/Auth/verifyEmail.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/loadingScreen.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String selectedCollege = collegeMap.keys.first;
  bool loading = false;
  AuthProvider auth;

  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  signUp() {
    setState(() {
      loading = true;
    });
    auth
        .signUp(_nameController.text, selectedCollege, _emailController.text,
            _passwordController.text)
        .then((user) async {
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return (user.emailVerified) ? LoadingScreen() : VerifyEmailScreen();
      }));
    }).catchError((err) {
      setState(() {
        loading = false;
      });
      showCustomSnackBar(context, err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "👋 Welcome",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: headingText),
                  ),
                ),
                _buildTextField(_nameController, "Name"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        iconSize: 30,
                        isExpanded: true,
                        underline: Container(),
                        focusColor: Colors.white,
                        value: selectedCollege,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.grey,
                        items: collegeMap.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            selectedCollege = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                _buildTextField(_emailController, "College Email"),
                _buildTextField(_passwordController, "Password",
                    passwordField: true),
                CustomButton(
                    title: (loading)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Register"),
                    onTap: signUp,
                    buttonType: ButtonType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already registered?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return SignInScreen();
                          }));
                        },
                        child:
                            Text("Login", style: TextStyle(color: buttonBlue)))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool passwordField = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        obscureText: passwordField,
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
