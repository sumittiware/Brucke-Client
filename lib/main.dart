import 'package:brucke_app/Providers/authProvider.dart';
import 'package:brucke_app/Providers/feedsProvider.dart';
import 'package:brucke_app/Styles/colors.dart';
import 'package:brucke_app/Views/Auth/signin.dart';
import 'package:brucke_app/Views/Auth/verifyEmail.dart';
import 'package:brucke_app/common/loadingScreen.dart';
import 'package:brucke_app/common/splashscreen.dart';
import 'package:brucke_app/sheetsconfig/sheets_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetsApi.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: FeedsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Brucke',
        theme: ThemeData(
            fontFamily: "Poppins",
            primaryColor: buttonBlue,
            appBarTheme: AppBarTheme(
              color: Colors.white,
              titleTextStyle:
                  TextStyle(color: headingText, fontWeight: FontWeight.bold),
              elevation: 4,
              iconTheme: IconThemeData(color: headingText, size: 40),
            )),
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              // return InternshipDetail();
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? SplashScreen()
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, usersnapshot) {
                        if (usersnapshot.connectionState ==
                            ConnectionState.active) {
                          if (usersnapshot.hasData) {
                            return (FirebaseAuth
                                    .instance.currentUser.emailVerified)
                                ? LoadingScreen()
                                : VerifyEmailScreen();
                          }
                          return SignInScreen();
                        }
                        return SplashScreen();
                      });
            }),
      ),
    );
  }
}
