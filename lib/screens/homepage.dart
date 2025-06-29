
import 'dart:math';

import 'package:denicotox/screens/info.dart';
import 'package:denicotox/screens/treedom.dart';
import 'package:denicotox/widgets/totalstep.dart';
import 'package:denicotox/widgets/tree.dart';
import 'package:flutter/material.dart';
import 'package:denicotox/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:denicotox/screens/profilePage.dart';
import 'package:denicotox/screens/cigarettePage.dart';
import 'package:shared_preferences/shared_preferences.dart';  
import 'package:denicotox/screens/historypage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:denicotox/widgets/stress_graph.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Box<int> counterBox; //DATABASE

  // This widget is the root of your application.
  Map data = {};

  Future<void> dataExtraction() async {
    final sp = await SharedPreferences.getInstance();
    final nome = sp.getString('nome');
    setState(() {
      data['nome'] = nome;
    });
  }

@override
  void initState() {
    super.initState();
    dataExtraction(); // Chiama la funzione al momento giusto
    counterBox = Hive.box<int>('counter'); 

  }
//RESET COUNTER OF DATABASE
void _resetCounter() {
  counterBox.put('counter', 0);
  setState(() {});
}

Future<void> selezionaIndiceUnico() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> current = prefs.getStringList('evidenziati_indices') ?? [];
  // Converti a set di interi per semplificare il confronto
  Set<int> usati = current.map(int.parse).toSet();
  if (usati.length >= 10) {
    print('All indices used.');
    return;
  }
  int randomIndex;
  do {
    randomIndex = Random().nextInt(10);
  } while (usati.contains(randomIndex));

  // Aggiungi il nuovo indice
  usati.add(randomIndex);
  await prefs.setStringList(
    'evidenziati_indices',
    usati.map((e) => e.toString()).toList(),
  );
}

Future<void> selezionaIndiceUnicoTreedom() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> current = prefs.getStringList('evidenziati_indices_treedom') ?? [];
  // Converti a set di interi per semplificare il confronto
  Set<int> usati = current.map(int.parse).toSet();
  if (usati.length >= 10) {
    print('All indices used.');
    return;
  }
  int randomIndex;
  do {
    randomIndex = Random().nextInt(10);
  } while (usati.contains(randomIndex));

  // Aggiungi il nuovo indice
  usati.add(randomIndex);
  await prefs.setStringList(
    'evidenziati_indices_treedom',
    usati.map((e) => e.toString()).toList(),
  );
}


void check( count, totalSteps ) async {
  if (count >= 40 && totalSteps >= 15000) {
    await Future.delayed(Duration(seconds: 1));
 selezionaIndiceUnicoTreedom();
    showDialog(
      context: context,
      builder: (BuildContext context)  {
        return AlertDialog(
          title: Text("🎉 Congratulations! 🎉 \n You've reached a milestone! 🥳\n You've unlocked a Treedom tree!", 
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          content: Image(image: AssetImage('assets/treedom.png'), width: 300, height: 100),
          actions: [
            TextButton(
              onPressed: () {
              Navigator.of(context).pop(); // Chiude il popup
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    await Future.delayed(Duration(seconds: 4));
    _resetCounter(); 
     Provider.of<DataProvider>(context, listen: false).update();

  }

  else if (count == 15) {
    selezionaIndiceUnico(); 
    showDialog(
      context: context,
      builder: (BuildContext context)  {
        return AlertDialog(
          title: Text("🎉 Congratulations! 🎉 \n You've reached a milestone! 🥳\n You've unlocked a voucher!", 
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          content: Image(image: AssetImage('assets/voucher0.png')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiude il popup
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
    Provider.of<DataProvider>(context, listen: false).update();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Hello ${data['nome'] } !', style: TextStyle(fontSize: 30)),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 70, 167, 73),
                const Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 1.0],
            ),
          ),
        ),
            actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, size: 30, color: const Color.fromARGB(255, 125, 123, 123)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionsPage()));
            },
          ),], 
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, ///
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(167, 80, 177, 83
                ),
              ),
              child: Text('Menu', style: TextStyle(color: Colors.black, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {                   
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
},
            ),
  
            ListTile(
              title: const Text('Vouchers'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));

              },
            ),
            ListTile(
              title: const Text('Treedom'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TreedomPage()));

              },
            ),
            ListTile(
              title: const Text('Clinical chart'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TreedomPage()));

              },
            ),
             SizedBox(height: 40), 

            ElevatedButton(onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
               prefs.setStringList('evidenziati_indices', []);
              prefs.setStringList('evidenziati_indices_treedom', []);
              prefs.setBool('register_done', false);
            },
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder() ,
            ),
             child: Text('Debug', style: TextStyle(color: Colors.green) )),


            SizedBox(height: 210), 
            SizedBox(
              height: 100,
              width: 40,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('By logging in, you confirm that you have accepted the Privacy Policy and consent to the processing of your personal data in accordance with Articles 6 and 7 of the GDPR.', 
                style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
            ),
          ],
        ),
      ),
   
      body: Consumer<DataProvider>(
        builder: (context, data, child)  {
           int totalStepsofDay = calculateTotalSteps(data.stepData);
           int count = counterBox.get('counter', defaultValue: 0)!; //DATABASE 
          //final count = counterBox.get('counter')!;            
          return Center(
            child: 
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
               TreeGrowthScreen(count: count, totalSteps: totalStepsofDay),

                SizedBox(height: 30),
                StressGraph(heartRateData: data.heartRateData, restingHeartRateData: data.restingHeartRateData),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      _resetCounter() ;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CigarettePage()));},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // <-- Circle shape
                      padding: EdgeInsets.all(15), // <-- Button padding
                    ),
                    child:
                     Icon(Icons.smoking_rooms_rounded , size: 50, color: const Color.fromARGB(255, 62, 61, 61), ),
                  ),
                   
                   SizedBox(width: 180,height: 10),
          
                    ElevatedButton(onPressed:()async { 
                      final star = Provider.of<DataProvider>(context, listen: false);

                      star.addStar(1);
                    int current = counterBox.get('counter', defaultValue: 0) ?? 0;
                     counterBox.put('counter', current+1); //aggiorno database    
                      int checkcount = counterBox.get('counter', defaultValue: 0) ?? 0; //aggiorno il contatore
                     check(checkcount, totalStepsofDay); //check if reset is needed               
                     },
                    
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // <-- Circle shape
                      padding: EdgeInsets.all(15), // <-- Button padding
                    ),
                    child: Icon(FontAwesomeIcons.leaf, size: 50, color:  const Color.fromARGB(255, 61, 170, 53)),
                    ),
                  ],
                ),
               SizedBox(width: 100, height: 50),
          
                ],
                
              )
              
          
          );
        },
      ),
    );
  
}}