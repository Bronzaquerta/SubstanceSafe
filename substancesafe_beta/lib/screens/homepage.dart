import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/doctor.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';
import 'package:substancesafe_beta/screens/patientDetailPage.dart';
import 'package:substancesafe_beta/utils/DoctorList.dart';
import 'package:substancesafe_beta/utils/impact.dart';
import 'package:substancesafe_beta/utils/PatientList.dart';

class HomePage extends StatefulWidget {
  final String doctor_username;
  HomePage({required this.doctor_username});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController patientNumberController = TextEditingController();

  void _logout(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('isUserLogged');
    Navigator.pop(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<int?> _authorize() async {
    return Impact.authorize();
  }

  String caesarEncrypt(String text, int shift) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        result.write(String.fromCharCode((charCode - 65 + shift) % 26 + 65));
      } else if (charCode >= 97 && charCode <= 122) {
        result.write(String.fromCharCode((charCode - 97 + shift) % 26 + 97));
      } else {
        result.write(text[i]);
      }
    }
    return result.toString();
  }

  List<String> patientNames = [];
  List<String> patientNumbers = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeList() async {
    PatientList patientList = PatientList([]);
    patientNames = await patientList.getNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
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
                  DoctorList doctors = DoctorList([]);
                  List<Doctor> oldDoctors = await doctors.getDoctors();
                  String email = widget.doctor_username;
                  int indices = -1;
                  for (int i = 0; i < oldDoctors.length; i++) {
                    if (oldDoctors[i].email == email) {
                      indices = i;
                    }
                  }
                  if (indices != -1) {
                    doctors.removeDoctor(oldDoctors[indices]);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await _authorize();
                final message =
                    result == 200 ? 'Request successful' : 'Request failed';
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              },
              child: Text('Authorize the app'),
            ),
            ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                await sp.remove('access');
                await sp.remove('refresh');
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(content: Text('Tokens have been deleted')));
              },
              child: Text('Unauthorize the app'),
            ),
            SizedBox(height: 20),
            Text(
              'Patient List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                  future: initializeList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (patientNames.isNotEmpty) {
                      return ListView.builder(
                        itemCount: patientNames.length,
                        itemBuilder: (context, index) {
                          String encryptedName =
                              caesarEncrypt(patientNames[index], 3);
                          return ListTile(
                            title: Text(encryptedName),
                            subtitle: Text('Number: $index'),
                          );
                        },
                      );
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: Text('No patients to show'),
                        ),
                      );
                    }
                  }),
            ),
            TextField(
              controller: patientNumberController,
              decoration: InputDecoration(
                labelText: 'Enter patient number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                final access = sp.getString('access');
                if (access == null || JwtDecoder.isExpired(access)) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('You didn\'t authorize')));
                  return;
                }


                String patientNumber = patientNumberController.text;
                int? patientNumberInt = int.tryParse(patientNumber);

                if (patientNumberInt == null || patientNumberInt < 0 || patientNumberInt >= patientNames.length) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text('Please enter a valid patient number')));
                  return;
                }


                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PatientDetailPage(patientNumber: patientNumber),
                  ),
                );
              },
              child: Text('Go Patient Page'),
            ),
          ],
        ),
      ),
    );
  }
}
