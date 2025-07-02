import 'package:denicotox/services/impact.dart';
import 'package:flutter/material.dart';
import 'package:denicotox/screens/homepage.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/screens/module.dart'; 
import 'package:denicotox/providers/data_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routename = 'LoginPage'; 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final Impact impact = Impact();
  bool isLoading = false;

  void _saveCredentials() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('username', userController.text);
    sp.setString('password', passwordController.text);
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });

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
        final provider = Provider.of<DataProvider>(context, listen: false);
        DateTime currentDate = DateTime.now().subtract(Duration(days: 7));
        await provider.getDataOfDay(currentDate);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: SizedBox(
          width: 1000,
          height: 100,
          child: Image.asset('assets/Denicotox.png'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/logo.png'),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 350,
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter your username',
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
                  hintText: 'Enter password',
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text('Login'),
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
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                final register = await sp.getBool('register_done');
                if (register == null || register == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Module()),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('You are already registered'),
                      duration: Duration(seconds: 2),
                    ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}



















