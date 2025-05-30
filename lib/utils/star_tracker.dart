import 'package:flutter/material.dart'; 


class StarTracker extends StatelessWidget {
  const StarTracker({super.key, this.count});
  final int? count;
  final int maxCount = 7;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxCount, (index) {
              return Icon(
              index < count! ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 50
    );
  }),
        ),
    );

  }

}