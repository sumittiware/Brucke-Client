import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Auth/forgetpassword.dart';
import 'package:brucke_app/Views/Auth/signup.dart';
import 'package:brucke_app/Views/Auth/verifyEmail.dart';
import 'package:brucke_app/Views/Home/widget/buttons.dart';
import 'package:brucke_app/common/loadingScreen.dart';
import 'package:brucke_app/common/showmessage.dart';
import 'package:brucke_app/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;
  AuthProvider auth;

  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    getColleges();
    super.initState();
  }

  signIn() {
    setState(() {
      loading = true;
    });
    auth.signIn(_emailController.text, _passwordController.text).then((result) {
      setState(() {
        loading = false;
      });
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return (result.emailVerified) ? LoadingScreen() : VerifyEmailScreen();
      }));
      showCustomSnackBar(context, "Sign In Successfull!");
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
                    "👋 Welcome Back",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: headingText),
                  ),
                ),
                _buildTextField(_emailController, "Email Id"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTextField(_passwordController, "Password",
                        passwordField: true),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ForgetPasswordScreen(
                              email: _emailController.text,
                            );
                          }));
                        },
                        child: Text("Forget Password?",
                            style: TextStyle(color: buttonBlue)))
                  ],
                ),
                CustomButton(
                    title: (loading)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Login"),
                    onTap: () {
                      signIn();
                    },
                    buttonType: ButtonType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New User?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return SignUpScreen();
                          }));
                        },
                        child: Text("Register",
                            style: TextStyle(color: buttonBlue)))
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
