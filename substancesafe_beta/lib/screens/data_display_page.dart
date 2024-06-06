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
  bool isHR=false;
  @override
  void initState() {
    super.initState();
    _data = fetchData(widget.patientNumber, widget.dataType);
    if(widget.dataType == 'heart_rate'){isHR=true;}
  }

  Future<List<DataModel>> fetchData(
      String patientNumber, String dataType) async {
    switch (dataType) {
      case 'steps':
        return Impact.fetchStepsData('Jpefaq6m58');
      case 'heart_rate':
        return Impact.fetchHeartRateData('Jpefaq6m58');
      case 'distance':
        return Impact.fetchDistanceData('Jpefaq6m58');
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
            Map<int, double> aggregatedData = aggregateDataByHour(data, isHR);

    List<FlSpot> spots = aggregatedData.entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
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
                          spots: spots,
                          isCurved: false,
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


 Map<int, double> aggregateDataByHour(List<DataModel> data, HR) {
    
    if(HR){
      Map<int, List<double>> hourlyData = {};

    // Group data by hour
    for (var point in data) {
      int hour = point.time.hour;
      if (hourlyData.containsKey(hour)) {
        hourlyData[hour]!.add(point.value.toDouble());
      } else {
        hourlyData[hour] = [point.value.toDouble()];
      }
    }

    // Calculate the mean for each hour
    Map<int, double> hourlyMeanData = {};
    hourlyData.forEach((hour, values) {
      if (values.isNotEmpty) {
        double mean = values.reduce((a, b) => a + b) / values.length;
        hourlyMeanData[hour] = mean;
      }
    });

    return hourlyMeanData;
  }
    
    else{
      Map<int, double> hourlyData = {};
    for (var point in data) {
      int hour = point.time.hour;
      if (hourlyData.containsKey(hour)) {
        hourlyData[hour] = hourlyData[hour]! + point.value;
      } else {
        hourlyData[hour] = point.value.toDouble();
      }
    }
    return hourlyData;
    }
  }
  