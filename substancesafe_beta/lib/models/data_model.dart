import 'package:intl/intl.dart';

class DataModel {
  final DateTime time;
  final int value;

  DataModel({required this.time, required this.value});

  factory DataModel.fromJson(String date, Map<String, dynamic> json) {
    return DataModel(
      time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value: int.parse(json['value']),
    );
  }

  @override
  String toString() {
    return 'DataModel(time: $time, value: $value)';
  }
}
