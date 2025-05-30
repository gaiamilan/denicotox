import 'package:flutter/material.dart';
//import 'package:group_project/screens/homePage.dart'; 
import 'package:google_fonts/google_fonts.dart';
//import 'package:group_project/screens/module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:denicotox/screens/loginPage.dart';
import 'package:denicotox/services/impact.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routename = 'ProfilePage'; 

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map data = {};
  final Impact impact = Impact();

  Future<void> dataExtraction() async {
    final sp = await SharedPreferences.getInstance();
    data['nome'] = sp.getString('nome');
    data['sesso'] = sp.getString('sesso');
    data['eta'] = sp.getInt('eta');
    data['nr_sigarette'] = sp.getInt('nr_sigarette');
    data['cig'] = sp.getString('tipo');
    data['motivation'] = sp.getString('motivazione');
    data['attivita'] = sp.getString('attività_fisica');
    setState(() {});
  }

@override
  void initState() {
    super.initState();
    dataExtraction(); // Chiama la funzione al momento giusto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile', 
          style: GoogleFonts.fredoka(
            fontSize: 35,
            color: Colors.black,
          ),
        ),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40
            ),

            CircleAvatar(
              foregroundImage: AssetImage('assets/profile_image.PNG'),
              radius: 80,
            ),

            SizedBox(
              height: 40
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Nome: ${data['nome']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Sesso: ${data['sesso']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

             SizedBox (
              width: 350,
              child: Text(
                'Età: ${data['eta']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Sigarette fumate al giorno: ${data['nr_sigarette']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Di che tipo: ${data['cig']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Perché vuoi smettere di fumare: ${data['motivation']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

            SizedBox (
              width: 350,
              child: Text(
                'Svolgi attività fisica: ${data['attivita']}',
                style:TextStyle( 
                  fontSize: 16
                ), 
              ),
            ),

            SizedBox(
              height: 20
            ),

              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(
                  'Modify',
                  style: TextStyle(
                    color: Colors.black, 
                    decoration: TextDecoration.underline,
                    )
                ),
                onPressed: (){

                },),

              ElevatedButton(
              child: Text('Logout'), 
              onPressed: () async{
                await impact.clearTokens();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false,);
                //Navigator.pop(context);
              }, //metodo onPressed
            ), 
          ]
        ),
        ),
      );
  } } //ProfilePage