import 'package:flutter/material.dart';
import 'package:denicotox/screens/loginPage.dart';
import 'package:denicotox/screens/homePage.dart';
import 'package:denicotox/services/impact.dart';
import 'package:denicotox/providers/data_provider.dart';
import 'package:provider/provider.dart';

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
                SizedBox(
              width: 1000,
              height: 100,
              child: Image.asset('assets/Denicotox.png'),
            ),

                SizedBox(
                  height: 30
                ),

                SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/logo.png'),
            ),
                ]
        )));
  }

  //Method for navigation SplashPage -> ExposurePage
  Future<void> _toHomePage(BuildContext context) async {
      final provider = Provider.of<DataProvider>(context, listen: false);
      DateTime currentDate = DateTime.now().subtract(Duration(days: 7));
      await provider.getDataOfDay(currentDate);
  

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) =>  Homepage()));
  } 

  // Method for navigation SplashPage -> LoginPage
  void _toLoginPage(BuildContext context) async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  } 

  // Method for checking if the user has still valid tokens
  // If yes, navigate to ExposurePage, if not, navigate to LoginPage
  void _checkLogin(BuildContext context) async {
    final impactInstance = Impact();
    final result = await impactInstance.refreshTokens();
    print('Result of refreshTokens: $result');
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  } //_checkLogin

}