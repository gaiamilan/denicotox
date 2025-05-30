import 'package:intl/intl.dart';

class RestingHeartRateData{
  final DateTime time;
  final double value;
  final double error;

RestingHeartRateData({required this.time, required this.value, required this.error});

  RestingHeartRateData.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = json["value"],
      error = json["error"];

  @override
  String toString() {
    return 'RestingHeartRateData(time: $time, value: $value)';
  }//toString
}//Steps
