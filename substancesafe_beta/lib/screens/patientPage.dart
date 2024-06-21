// patientPage.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/patient.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';
import 'package:substancesafe_beta/utils/PatientList.dart';

class PatientPage extends StatefulWidget {
  final String patient_username;
  PatientPage({required this.patient_username});
  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late String selectedPatientNumber;
  late String notes = '';
  bool drinksAlcohol = false;
  bool smokes = false;
  bool doesSports = false;

  @override
  void initState() {
    super.initState();
    // Initialize selectedPatientNumber with the first patient's number
    selectedPatientNumber = patients.isNotEmpty ? patients[0]['number']! : '';
    _loadNotes();
  }

  void _logout(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('isUserLogged');
    Navigator.pop(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> _loadNotes() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final savedNotes = sharedPreferences.getString(selectedPatientNumber) ?? '';
    final savedDrinksAlcohol =
        sharedPreferences.getBool('${selectedPatientNumber}_drinksAlcohol') ??
            false;
    final savedSmokes =
        sharedPreferences.getBool('${selectedPatientNumber}_smokes') ?? false;
    final savedDoesSports =
        sharedPreferences.getBool('${selectedPatientNumber}_doesSports') ??
            false;
    setState(() {
      notes = savedNotes;
      drinksAlcohol = savedDrinksAlcohol;
      smokes = savedSmokes;
      doesSports = savedDoesSports;
    });
  }

  Future<void> _saveNotes() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(selectedPatientNumber, notes);
    await sharedPreferences.setBool(
        '${selectedPatientNumber}_drinksAlcohol', drinksAlcohol);
    await sharedPreferences.setBool('${selectedPatientNumber}_smokes', smokes);
    await sharedPreferences.setBool(
        '${selectedPatientNumber}_doesSports', doesSports);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logout(context),
            ),
            ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete account'),
                onTap: () async {
                  PatientList patients = PatientList([]);
                  List<Patient> oldPatients = await patients.getPatients();
                  String email = widget.patient_username;
                  int indices = -1;
                  for (int i = 0; i < oldPatients.length; i++) {
                    if (oldPatients[i].email == email) {
                      indices = i;
                    }
                  }
                  if (indices != -1) {
                    patients.removePatient(oldPatients[indices]);
                    _logout(context);
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text('Unable to cancel the account')));
                  }
                }),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedPatientNumber,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPatientNumber = newValue!;
                    _loadNotes();
                  });
                },
                items: patients.map<DropdownMenuItem<String>>((patient) {
                  return DropdownMenuItem<String>(
                    value: patient['number'],
                    child: Text(patient['name']!),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Patient',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Notes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
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
                      SizedBox(height: 20),
                      CheckboxListTile(
                        title: Text('Do you drink alcohol?'),
                        value: drinksAlcohol,
                        onChanged: (bool? value) {
                          setState(() {
                            drinksAlcohol = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('Do you smoke?'),
                        value: smokes,
                        onChanged: (bool? value) {
                          setState(() {
                            smokes = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('Do you do sports?'),
                        value: doesSports,
                        onChanged: (bool? value) {
                          setState(() {
                            doesSports = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _saveNotes();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Notes and answers saved successfully')),
                  );
                },
                child: Text('Save Notes and Answers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
