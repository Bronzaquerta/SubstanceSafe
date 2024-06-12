// patientDetailPage.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/data_display_page.dart';

class PatientDetailPage extends StatefulWidget {
  final String patientNumber;

  PatientDetailPage({required this.patientNumber});

  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  late TextEditingController notesController;
  late String notes;
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
    final sharedPreferences = await SharedPreferences.getInstance();
    final savedNotes = sharedPreferences.getString(widget.patientNumber) ?? '';
    final savedDrinksAlcohol = sharedPreferences.getBool('${widget.patientNumber}_drinksAlcohol') ?? false;
    final savedSmokes = sharedPreferences.getBool('${widget.patientNumber}_smokes') ?? false;
    final savedDoesSports = sharedPreferences.getBool('${widget.patientNumber}_doesSports') ?? false;
    setState(() {
      notes = savedNotes;
      notesController.text = savedNotes;
      drinksAlcohol = savedDrinksAlcohol;
      smokes = savedSmokes;
      doesSports = savedDoesSports;
    });
  }

  Future<void> _saveNotes(String notes) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(widget.patientNumber, notes); // Save notes with key as patientNumber
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
                      patientNumber: widget.patientNumber,
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
                      patientNumber: widget.patientNumber,
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
                      patientNumber: widget.patientNumber,
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
                    controller: notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String notes = notesController.text;
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
