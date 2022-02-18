import 'package:brucke_app/Styles/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: RotatedBox(
              quarterTurns: 2,
              child: ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  height: deviceSize.height * 0.4,
                  width: deviceSize.width,
                  decoration: BoxDecoration(color: splashClipColor),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Image(image: AssetImage("assets/icons/logo.png")),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
