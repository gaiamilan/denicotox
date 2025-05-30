
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
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      startAngle: 180,
                      endAngle: 0,
                      showTicks: false,
                      showLabels: false,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothFlat,
                        thicknessUnit: GaugeSizeUnit.factor,
                        gradient: SweepGradient(
                          colors: <Color>[
                            Colors.purple,
                            Colors.blueAccent,
                            Colors.cyan,
                          ],
                          stops: <double>[0.0, 0.5, 1.0],
                        ),
                      ),
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          value: data,
                          markerType: MarkerType.invertedTriangle,
                          color: const Color.fromARGB(255, 201, 98, 132),
                          markerHeight: 20,
                          markerWidth: 20,
                          enableAnimation: true,
                          markerOffset: -30,
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          angle: 80,
                          positionFactor: 0.0,
                          widget: Text(
                            '${data.toInt()}',
                            style: const TextStyle(
                              fontSize: 80,
                            ),
                          ),
                        ),
                        const GaugeAnnotation(
                          angle: 175,
                          positionFactor: 0.9,
                          widget: Text(
                            '0',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const GaugeAnnotation(
                          angle: 5,
                          positionFactor: 0.9,
                          widget: Text(
                            '100',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        GaugeAnnotation(
                          angle: 90,
                          positionFactor: 0.35,
                          widget: Text(
                            interpretation,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }

  String interpretStressScore(double data) {
    if (data < 20) return "Molto rilassato";
    if (data < 40) return "Rilassato";
    if (data < 70) return "Stressato";
    return "Altamente stressato";
  }
}