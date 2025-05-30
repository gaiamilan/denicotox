
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
  late Box<int> totalStepsBox; //DATABASE

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
    totalStepsBox = Hive.box<int>('totalsteps'); //DATABASE
  }
//RESET COUNTER OF DATABASE
void _resetCounter() {
  counterBox.put('counter', 0);
  setState(() {});
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
              title: const Text('History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));

              },
            ),
          ],
        ),
      ),
   
      body: Consumer<DataProvider>(
        builder: (context, data, child) {
           int totalSteps = calculateTotalSteps(data.stepData);
           /*
          int currentSteps = counterBox.get('counter', defaultValue: 0) ?? 0;
            counterBox.put('counter', currentSteps+totalStepsofDay); //aggiorno database  
          int totalSteps = totalStepsBox.get('totalsteps', defaultValue: 0) ?? 0; //DATABASE
          */
           int count = counterBox.get('counter', defaultValue: 0) ?? 0; //DATABASE 
          //final count = counterBox.get('counter')!;            
          return Center(
            child: 
               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
               TreeGrowthScreen(count: count, totalSteps: totalSteps),
               Text('🌱 $count        👣 $totalSteps', style: TextStyle(fontSize: 30),),
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
  }


}






