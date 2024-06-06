import 'package:flutter/material.dart';
import 'package:substancesafe_beta/screens/data_display_page.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientNumber;

  const PatientDetailPage({super.key, required this.patientNumber});

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
              child: const Text('Steps Data'),
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
              child: const Text('Heart Rate Data'),
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
              child: const Text('Distance Data'),
            ),
          ],
        ),
      ),
    );
  }
}
