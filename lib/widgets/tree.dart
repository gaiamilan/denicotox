
import 'package:flutter/material.dart';

class TreeGrowthScreen extends StatelessWidget {
  TreeGrowthScreen({super.key, required this.count, required this.totalSteps});
  final int count;
  final int totalSteps;


  //initialize goals
  final int goal1 = 5;
  final int goal2 = 10;
  final int goal3 = 15;
  final int goal4 = 30;
  final int goal5 = 40;
  final int goal41 = 8000;
  final int goal51 = 16000; 

String getTreeImagePath() {
  if (count >= goal5 && totalSteps >= goal51) {
    // Dopo 40 giorni e 16000 passi
    return 'assets/6.png';
  } else if (count >= goal4 && totalSteps >= goal41) {
    // Dopo 30 giorni e 8000 passi
    return 'assets/5.png';
  } else if (count >= goal3) {
    // Dopo 15 giorni
    return 'assets/4.png';
  } else if (count >= goal2) {
    // Dopo 10 giorni
    return 'assets/3.png';
  } else if (count >= goal1) {
    // Dopo 4 giorni
    return 'assets/2.png';
  } else {
    // Prima dei 4 giorni
    return 'assets/1.png';
  }
}

  @override
  Widget build(BuildContext context) {
    return 
          Column(
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: SizedBox(
                  width: 400,
                  height: 330,
                  child: Image.asset(
                  getTreeImagePath(),
                  key: ValueKey(getTreeImagePath()),
                  width: 300,
                  fit: BoxFit.contain,
                ),)
              ),
              SizedBox(height: 20),
            Text('🌱 $count        👣 $totalSteps', style: TextStyle(fontSize: 30),)
            ],
          );
          
  }
}
