import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:substancesafe_beta/models/data_model.dart';
import 'package:substancesafe_beta/utils/impact.dart';
import 'package:intl/intl.dart';

class DataDisplayPage extends StatefulWidget {
  final String patientNumber;
  final String dataType;

  const DataDisplayPage({super.key, required this.patientNumber, required this.dataType});

  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  late Future<List<DataModel>> _data;
  late DateTime _selectedDate;
  bool _showAllPoints = true;
  bool _showLineChart = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _data = fetchData(_selectedDate);
  }

  Future<List<DataModel>> fetchData(DateTime date) async {
    switch (widget.dataType) {
      case 'steps':
        return Impact.fetchStepsData('Jpefaq6m58', date: date);
      case 'heart_rate':
        return Impact.fetchHeartRateData('Jpefaq6m58', date: date);
      case 'distance':
        return Impact.fetchDistanceData('Jpefaq6m58', date: date);
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

  List<FlSpot> _processData(List<DataModel> data) {
    if (_showAllPoints) {
      return data.map((dataPoint) => FlSpot(
        dataPoint.time.millisecondsSinceEpoch.toDouble(),
        dataPoint.value.toDouble(),
      )).toList();
    } else {
      // Calculate hourly averages
      Map<int, List<DataModel>> groupedData = {};
      for (var dataPoint in data) {
        int hour = dataPoint.time.hour;
        if (!groupedData.containsKey(hour)) {
          groupedData[hour] = [];
        }
        groupedData[hour]!.add(dataPoint);
      }
      return groupedData.entries.map((entry) {
        double avgValue = entry.value.map((e) => e.value).reduce((a, b) => a + b) / entry.value.length;
        return FlSpot(entry.key.toDouble(), avgValue.toDouble());
      }).toList();
    }
  }

  Widget _buildChart(List<DataModel> data) {
    List<FlSpot> spots = _processData(data);
    return _showLineChart
      ? LineChart(LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
          ],
        ))
      : BarChart(BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          barGroups: spots.map((spot) {
            return BarChartGroupData(x: spot.x.toInt(), barRods: [
              BarChartRodData(
                toY: spot.y, // Muutetaan y to toY
                gradient: LinearGradient(colors: [Colors.blue]), // Muutetaan colors gradientiksi
              ),
            ]);
          }).toList(),
        ));
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show all points'),
              Switch(
                value: _showAllPoints,
                onChanged: (value) {
                  setState(() {
                    _showAllPoints = value;
                  });
                },
              ),
              Text('Show line chart'),
              Switch(
                value: _showLineChart,
                onChanged: (value) {
                  setState(() {
                    _showLineChart = value;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<DataModel>>(
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
                          child: _buildChart(data),
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
          ),
        ],
      ),
    );
  }
}

