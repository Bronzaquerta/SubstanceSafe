import 'package:flutter/material.dart';
import 'package:substancesafe_beta/screens/data_display_page.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientNumber;

  PatientDetailPage({required this.patientNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient $patientNumber'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplayPage(
                      patientNumber: patientNumber,
                      dataType: 'steps',
                    ),
                  ),
                );
              },
              child: Text('Steps Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplayPage(
                      patientNumber: patientNumber,
                      dataType: 'heart_rate',
                    ),
                  ),
                );
              },
              child: Text('Heart Rate Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplayPage(
                      patientNumber: patientNumber,
                      dataType: 'distance',
                    ),
                  ),
                );
              },
              child: Text('Distance Data'),
            ),
          ],
        ),
      ),
    );
  }
}
