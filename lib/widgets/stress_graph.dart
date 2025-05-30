
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:denicotox/widgets/stress.dart';
import 'package:denicotox/models/heartratedata.dart';
import 'package:denicotox/models/restingheartrate.dart';


/// Local import

///Renders default line series chart
class StressGraph extends StatelessWidget {
  ///Creates default line series chart
  const StressGraph({super.key, required this.heartRateData, required this.restingHeartRateData});

  final List<HeartRateData> heartRateData;
  final List<RestingHeartRateData> restingHeartRateData;


  @override
  Widget build(BuildContext context) {
    final data = stress(heartRateData, restingHeartRateData);
    final String interpretation = interpretStressScore(data);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         
          SfLinearGauge(
  minimum: 0.0,
  maximum: 100.0,
  showTicks: false,
  showLabels: false,
  animateAxis: true,
  axisTrackStyle: LinearAxisTrackStyle(
    thickness: 20,
    edgeStyle: LinearEdgeStyle.bothCurve, // angoli arrotondati
    color: Colors.grey.shade300, // sfondo più soft
    borderColor: Colors.transparent,
  ),
  barPointers: [
    LinearBarPointer(
      value: data,
      thickness: 20,
      edgeStyle: LinearEdgeStyle.bothCurve,
      animationDuration: 800,
      color: getStressColor(data), // colore dinamico in base al valore
    )
  ],
),
const SizedBox(height: 10),
 Text(
            'Stress level: ${data.toInt()}, $interpretation',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
Color getStressColor(double value) {
  if (value < 20) return const Color.fromARGB(255, 178, 224, 126); // verde chiaro
  if (value < 40) return const Color.fromARGB(255, 245, 238, 100); // giallo
  if (value < 70) return const Color(0xFFFFA000); // arancione
  return const Color.fromARGB(255, 213, 77, 77);                 // rosso
}
  String interpretStressScore(double data) {
    if (data < 20) return "molto rilassato";
    if (data < 40) return "rilassato";
    if (data < 70) return "stressato";
    return "altamente stressato!";
  }
}
