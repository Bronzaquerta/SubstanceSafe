import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:substancesafe_beta/models/data_model.dart';
import 'package:substancesafe_beta/utils/impact.dart';

class DataDisplayPage extends StatefulWidget {
  final String patientNumber;
  final String dataType;

  const DataDisplayPage({super.key, required this.patientNumber, required this.dataType});

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  late Future<List<DataModel>> _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData(widget.patientNumber, widget.dataType);
  }

  Future<List<DataModel>> fetchData(
      String patientNumber, String dataType) async {
    switch (dataType) {
      case 'steps':
        return Impact.fetchStepsData(patientNumber);
      case 'heart_rate':
        return Impact.fetchHeartRateData(patientNumber);
      case 'distance':
        return Impact.fetchDistanceData(patientNumber);
      default:
        throw Exception('Unknown data type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.dataType} data for Patient ${widget.patientNumber}'),
      ),
      body: FutureBuilder<List<DataModel>>(
        future: _data,
        builder: (context, snapshot) {
          print('Snapshot data: ${snapshot.data}');
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
                                    dataPoint.time.millisecondsSinceEpoch
                                        .toDouble(),
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
