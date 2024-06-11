import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:substancesafe_beta/models/data_model.dart';
import 'package:substancesafe_beta/utils/impact.dart';
import 'package:intl/intl.dart';

class DataDisplayPage extends StatefulWidget {
  final String patientNumber;
  final String dataType;

  const DataDisplayPage({Key? key, required this.patientNumber, required this.dataType}) : super(key: key);

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  late Future<List<DataModel>> _data;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _data = fetchData(_selectedDate);
  }

  Future<List<DataModel>> fetchData(DateTime date) async {
    switch (widget.dataType) {
      case 'steps':
        return Impact.fetchStepsData(widget.patientNumber, date: date);
      case 'heart_rate':
        return Impact.fetchHeartRateData(widget.patientNumber, date: date);
      case 'distance':
        return Impact.fetchDistanceData(widget.patientNumber, date: date);
      default:
        throw Exception('Unknown data type');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _data = fetchData(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dataType} data for Patient ${widget.patientNumber}'),
        actions: [
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: FutureBuilder<List<DataModel>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              .map((dataPoint) => FlSpot(
                                    dataPoint.time.millisecondsSinceEpoch.toDouble(),
                                    dataPoint.value.toDouble(),
                                  ))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ListTile(
                        title: Text('Time: ${item.time}'),
                        subtitle: Text('${widget.dataType}: ${item.value}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
