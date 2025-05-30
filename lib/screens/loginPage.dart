import 'package:denicotox/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:denicotox/screens/homepage.dart'; 
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/screens/module.dart'; 

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  static const routename = 'LoginPage'; 
  
  // Controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final Impact impact = Impact();

  // Save the credentials in shared preferences
  void _saveCredentials() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('username', userController.text);
    sp.setString('password', passwordController.text);
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'DENICOTOX', 
          style: GoogleFonts.fredoka(
            fontSize: 35,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
              radius: 80,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: false,
                controller: userController, 
                decoration: InputDecoration(
                  border: OutlineInputBorder(), 
                  labelText: 'Username', 
                  hintText: 'Enter your username'
                ), 
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: TextField(
                obscureText: true,
                controller: passwordController, 
                decoration: InputDecoration(
                  border: OutlineInputBorder(), 
                  labelText: 'Password', 
                  hintText: 'Enter password'
                ), 
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Login'), 
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                final result = await impact.getAndStoreTokens(
                  userController.text, 
                  passwordController.text
                );
                if (result == 200) {
                  _saveCredentials();
                  final registerDone = sp.getBool('register_done');
                  if (registerDone == null || registerDone == false) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar() 
                      ..showSnackBar(SnackBar(
                        content: Text('You are not registered'), 
                        duration: Duration(seconds: 2),
                      ));
                  } else {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => Homepage())
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar() 
                    ..showSnackBar(SnackBar(
                      content: Text('Wrong credentials'), 
                      duration: Duration(seconds: 2),
                    ));
                }
              },
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 350,
              child: Text(
                'Not registered yet?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.black, 
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => Module())
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
