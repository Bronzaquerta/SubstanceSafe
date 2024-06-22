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
  late int selectedPatientNumber;
  String notes = '';
  bool drinksAlcohol = false;
  bool smokes = false;
  bool doesSports = false;

  @override
  void initState() {
    super.initState();

    selectedPatientNumber = 0;
    initializePage();
  }

  void initializePage() async {
    PatientList patients = PatientList([]);
    List<Patient> oldPatients = await patients.getPatients();

    for (int i = 0; i < oldPatients.length; i++) {
      if (oldPatients[i].email == widget.patient_username) {
        selectedPatientNumber = i;
      }
    }

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
    final savedNotes = await PatientList([]).getNotes(selectedPatientNumber);

    List<bool> savedDatas =
        await PatientList([]).retriveDatas(selectedPatientNumber);
    setState(() {
      notes = savedNotes;
      drinksAlcohol = savedDatas[0];
      smokes = savedDatas[2];
      doesSports = savedDatas[1];
    });
  }

  Future<void> _saveNotes() async {
    PatientList([])
        .updatedDatas(selectedPatientNumber, drinksAlcohol, doesSports, smokes);
    PatientList([]).updateNotes(selectedPatientNumber, notes);
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
