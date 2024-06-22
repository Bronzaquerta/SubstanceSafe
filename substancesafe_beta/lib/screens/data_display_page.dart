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
  late DateTime _selectedDate;
  bool _showAllPoints = true;
  bool _showLineChart = true;

  bool _showAverageLine = false;  // New state variable for average line
  String get patientUsername => 'Jpefaq6m58';


  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().subtract(Duration(days: 1));
    _data = fetchData(_selectedDate);
  }

  Future<List<DataModel>> fetchData(DateTime date) async {
    switch (widget.dataType) {
      case 'steps':
        return Impact.fetchStepsData(patientUsername, date: date);
      case 'heart_rate':
        return Impact.fetchHeartRateData(patientUsername, date: date);
      case 'distance':
        return Impact.fetchDistanceData(patientUsername, date: date);
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

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      _data = fetchData(_selectedDate);
    });
  }

  List<FlSpot> _processData(List<DataModel> data) {
    if (_showAllPoints) {
      return data.map((dataPoint) => FlSpot(
        dataPoint.time.millisecondsSinceEpoch.toDouble(),
        dataPoint.value.toDouble(),
      )).toList();
    } else {
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

  double _calculateAverage(List<DataModel> data) {
    double sum = data.map((e) => e.value).reduce((a, b) => a + b).toDouble();
    return sum / data.length;
  }

  Widget _buildChart(List<DataModel> data) {
  List<FlSpot> spots = _processData(data);
  double average = _calculateAverage(data);

  return _showLineChart
      ? LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 3600 * 1000,  // Asetetaan väli yhden tunnin välein
                  getTitlesWidget: (value, meta) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    String formattedDate = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        formattedDate,
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
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
              if (_showAverageLine)
                LineChartBarData(
                  spots: spots.map((spot) => FlSpot(spot.x, average)).toList(),
                  isCurved: false,
                  color: Colors.red,
                  barWidth: 2,
                ),
            ],
          ),
        )
      : BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 3600 * 1000,  // Asetetaan väli yhden tunnin välein
                  getTitlesWidget: (value, meta) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    String formattedDate = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 8.0,
                      child: Text(
                        formattedDate,
                        style: TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: spots.map((spot) {
              return BarChartGroupData(
                x: spot.x.toInt(),
                barRods: [
                  BarChartRodData(
                    toY: spot.y,
                    gradient: LinearGradient(colors: [Colors.blue]),
                  ),
                ],
              );
            }).toList(),
          ),
        );
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
              TextButton(onPressed: () => _changeDate(-1), child: Text('-')),
              Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
              TextButton(onPressed: () => _changeDate(1), child: Text('+')),
            ],
          ),
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
              Text('Show average line'),
              Switch(
                value: _showAverageLine,
                onChanged: (value) {
                  setState(() {
                    _showAverageLine = value;
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
                  double average = _calculateAverage(data);
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildChart(data),
                        ),
                      ),
                      Text('Average: ${average.toStringAsFixed(2)}'),
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
