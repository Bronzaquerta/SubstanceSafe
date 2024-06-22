import 'package:flutter/material.dart';
import 'package:substancesafe_beta/models/doctor.dart';
import 'package:substancesafe_beta/models/patient.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';
import 'package:substancesafe_beta/screens/patientPage.dart';
import 'package:substancesafe_beta/utils/DoctorList.dart';
import 'package:substancesafe_beta/utils/PatientList.dart';

class NewAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Account',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreateAccountPage(),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';
  bool doc = false;
  final DoctorList _preferences = DoctorList([]);
  final PatientList _patients = PatientList([]);

  void _logout(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _submit() async {
    //potrebbe essere rindondante questa parte, creo una lista di dottori e poi creo un doctorList con tutti i dottori ma quando
    //faccio add in doctorlist al suo interno creo una lista di dottori nuova che popolo con i dottori già presenti a cui poi aggungo
    //il nuovo medico e salvo la nuova lista al posto di quella vecchia. per cui non sembra avere senso dare già una lista piena di dottori al metodo add
    //dato che si occupa lui di rimpolparla al suo interno.
    List<Doctor> loadedDoctors = await _preferences.getDoctors();
    DoctorList doctor_list = DoctorList(loadedDoctors);
    List<Patient> loadedPatients = await _patients.getPatients();
    PatientList patient_list = PatientList(loadedPatients);
    if (doc) {
      doctor_list.add(Doctor(email: _email, name: _name, password: _password));
    } else {
      patient_list.add(Patient(
          email: _email,
          name: _name,
          password: _password,
          hasDrank: false,
          doesSport: false,
          isSmoker: false));
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Account created for $_name')));
  }

  final List<String> _options = [
    'Doctor',
    'Patient',
  ];
  // Variable to hold the selected option
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Name field
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty || value == '') {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              //Email field
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || value == '') {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              //Password field
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: 20),
              Column(
                children: _options.map((option) {
                  return ListTile(
                    title: Text(option),
                    leading: Radio<String>(
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Perform an action with the selected option

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_selectedOption != null) {
                      if (_selectedOption == 'Doctor' &&
                          _name != '' &&
                          _email != '' &&
                          _password != '') {
                        doc = true;
                        _submit();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    doctor_username: _email,
                                  )),
                        );
                      } else if (_selectedOption == 'Patient' &&
                          _name != '' &&
                          _email != '' &&
                          _password != '') {
                        doc = false;
                        _submit();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientPage(
                                    patient_username: _email,
                                  )),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text('Please select a role')),
                        );
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill out the form completely before submitting')),
                      );
                  }
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
