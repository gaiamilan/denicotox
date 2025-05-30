import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:denicotox/models/heartratedata.dart';
import 'package:denicotox/models/restingheartrate.dart';


/// Local import

///Renders default line series chart
class HRDataPlot extends StatelessWidget {
  ///Creates default line series chart
  const HRDataPlot({super.key, required this.heartRateData, required this.restingHeartRateData});

  final List<HeartRateData> heartRateData;
  final List<RestingHeartRateData> restingHeartRateData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Yesterday HR'),
      primaryXAxis: const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value} HR',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getStepDataSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
      
      
    );
    
  }

  /// The method returns line series to chart.
  List<LineSeries<HeartRateData, DateTime>> _getStepDataSeries() {
    return <LineSeries<HeartRateData, DateTime>>[
      LineSeries<HeartRateData, DateTime>(
          dataSource: heartRateData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'Steps',
          color: Color.fromARGB(255, 255, 3, 3),
          markerSettings: const MarkerSettings(isVisible: false)),
              // Serie linea media
          
    ];
  }//_getStepDataSeries


void mean(){
  int sum = 0;
  for (var heart in heartRateData) {
  sum += heart.value;
}
    double average = heartRateData.isNotEmpty ? sum / heartRateData.length : 0;
print('Media dei valori: $average');
}
}//StepDataPlot