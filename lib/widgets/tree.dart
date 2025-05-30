
import 'package:flutter/material.dart';

class TreeGrowthScreen extends StatelessWidget {
  const TreeGrowthScreen({super.key, required this.count});
  final int count;
  bool get showLeaf => count >= 2;
  bool get showFlower => count >= 4;

  String getTreeImagePath() {
    print(count);
    if (count < 2) return 'assets/1.png';
    if (count < 4) return 'assets/2.png';
    if (count < 6) return 'assets/3.png';
    if (count < 8) return 'assets/4.png';
    if (count <10) return 'assets/5.png';
    return 'assets/6.png';
  }

  @override
  Widget build(BuildContext context) {
    return 
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Image.asset(
              getTreeImagePath(),
              key: ValueKey(getTreeImagePath()),
              width: 300,
              fit: BoxFit.contain,
            ),
          );

  }
}
