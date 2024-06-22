
// patientDetailPage.dart

import 'package:flutter/material.dart';
import 'package:substancesafe_beta/screens/data_display_page.dart';
import 'package:substancesafe_beta/utils/PatientList.dart';

class PatientDetailPage extends StatefulWidget {
  final int patientNumber;

  PatientDetailPage({required this.patientNumber});

  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  late TextEditingController notesController;
  String notes = '';
  bool drinksAlcohol = false;
  bool smokes = false;
  bool doesSports = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final savedNotes = await PatientList([]).getNotes(widget.patientNumber);

    List<bool> savedDatas =
        await PatientList([]).retriveDatas(widget.patientNumber);
    setState(() {
      notes = savedNotes;
      drinksAlcohol = savedDatas[0];
      smokes = savedDatas[2];
      doesSports = savedDatas[1];
    });
  }

  Future<void> _saveNotes(String notes) async {

    PatientList([]).updateNotes(widget.patientNumber, notes);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient ${widget.patientNumber}'),
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
                      patientNumber: widget.patientNumber.toString(),
                      dataType: 'steps',
                    ),
                  ),
                );
              },
              child: Text('Get Steps Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplayPage(
                      patientNumber: widget.patientNumber.toString(),
                      dataType: 'heart_rate',
                    ),
                  ),
                );
              },
              child: Text('Get Heart Rate Data'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDisplayPage(
                      patientNumber: widget.patientNumber.toString(),
                      dataType: 'distance',
                    ),
                  ),
                );
              },
              child: Text('Get Distance Data'),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      notes = value;
                    },
                    controller: TextEditingController(text: notes),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveNotes(notes);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notes saved successfully')),
                      );
                    },
                    child: Text('Save Notes'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Patient Answers:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    title: Text('Do you drink alcohol?'),
                    value: drinksAlcohol,
                    onChanged: null,
                  ),
                  CheckboxListTile(
                    title: Text('Do you smoke?'),
                    value: smokes,
                    onChanged: null,
                  ),
                  CheckboxListTile(
                    title: Text('Do you do sports?'),
                    value: doesSports,
                    onChanged: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
