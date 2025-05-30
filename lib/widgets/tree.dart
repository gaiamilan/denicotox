
import 'package:flutter/material.dart';

class TreeGrowthScreen extends StatelessWidget {
  const TreeGrowthScreen({super.key, required this.count, required this.totalSteps});
  final int count;
  final int totalSteps;

  String getTreeImagePath() {
if (count < 4) return 'assets/1.png';
    if (count < 10) return 'assets/2.png';
    if (count < 15) return 'assets/3.png';
    if (count < 30 || totalSteps > 10000) return 'assets/4.png';
    if (count < 40 || totalSteps > 40000) return 'assets/5.png';
    return 'assets/6.png';
  }

  @override
  Widget build(BuildContext context) {
    return 
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: SizedBox(
              width: 350,
              height: 350,
              child: Image.asset(
              getTreeImagePath(),
              key: ValueKey(getTreeImagePath()),
              width: 300,
              fit: BoxFit.contain,
            ),)
          );
  }
}
