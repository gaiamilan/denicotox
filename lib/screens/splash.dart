import 'package:flutter/material.dart';
import 'package:denicotox/screens/loginPage.dart';
import 'package:denicotox/screens/homePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:denicotox/services/impact.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DENICOTOX', 
                  style: GoogleFonts.fredoka(
                    fontSize: 45,
                    color: Colors.black,
                  )
                ),

                SizedBox(
                  height: 40
                ),

                CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.png'),
                  radius: 90,
                  backgroundColor: Colors.transparent,
                ),
                ]
        )));
  }

  //Method for navigation SplashPage -> ExposurePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>  Homepage()));
  } 

  // Method for navigation SplashPage -> LoginPage
  void _toLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  } 

  // Method for checking if the user has still valid tokens
  // If yes, navigate to ExposurePage, if not, navigate to LoginPage
  void _checkLogin(BuildContext context) async {
    final impactInstance = Impact();
    final result = await impactInstance.refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  } //_checkLogin

}