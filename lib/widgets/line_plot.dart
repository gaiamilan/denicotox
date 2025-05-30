import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:denicotox/models/stepdata.dart';

/// Local import

///Renders default line series chart
class StepDataPlot extends StatelessWidget {
  ///Creates default line series chart
  const StepDataPlot({super.key, required this.stepData});

  final List<StepData> stepData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Yesterday steps'),
      primaryXAxis: const DateTimeAxis(majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value} steps',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getStepDataSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<StepData, DateTime>> _getStepDataSeries() {
    mean();
    return <LineSeries<StepData, DateTime>>[
      LineSeries<StepData, DateTime>(
          dataSource: stepData,
          xValueMapper: (data, _) => data.time,
          yValueMapper: (data, _) => data.value,
          name: 'Steps',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }//_getStepDataSeries


void mean(){
  int sum = 0;
  for (var step in stepData) {
  sum += step.value;
}
    double average = stepData.isNotEmpty ? sum / stepData.length : 0;
print('Media dei valori: $average');
}
}//StepDataPlot