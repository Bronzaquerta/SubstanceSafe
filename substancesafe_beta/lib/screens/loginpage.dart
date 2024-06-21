import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/models/doctor.dart';
import 'package:substancesafe_beta/models/patient.dart';
import 'package:substancesafe_beta/screens/new_account_page.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/patientPage.dart';
import 'package:substancesafe_beta/utils/DoctorList.dart' as doctor;
import 'package:substancesafe_beta/utils/PatientList.dart' as patient;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  final doctor.DoctorList _preferences = doctor.DoctorList([]);
  List<Doctor> doctors = [];
  final patient.PatientList _patients = patient.PatientList([]);
  List<Patient> patients = [];
  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storedUsername = sharedPreferences.getString('username');
    final storedPassword = sharedPreferences.getString('password');
    final storedRememberMe = sharedPreferences.getBool('rememberMe') ?? false;
    List<Doctor> loadedDoctors = await _preferences.getDoctors();
    setState(() {
      doctors = loadedDoctors;
    });
    if (storedRememberMe) {
      setState(() {
        userController.text = storedUsername ?? '';
        passwordController.text = storedPassword ?? '';
        rememberMe = storedRememberMe;
      });
    }
  }

  Future<void> _storeCredentials(String username, String password) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('username', username);
    await sharedPreferences.setString('password', password);
    await sharedPreferences.setBool('rememberMe', rememberMe);
  }

  Future<void> _login() async {
    List patientsEmails = await _patients.getEmails();
    List patient_passwords = await _patients.getPasswords();

    List docEmails = await _preferences.getEmails();
    List doc_passwords = await _preferences.getPasswords();
    if (patientsEmails.contains(userController.text) &&
        patient_passwords.contains(passwordController.text)) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setBool('isUserLogged', true);

      if (rememberMe) {
        await _storeCredentials(userController.text, passwordController.text);
      } else {
        await sharedPreferences.remove('username');
        await sharedPreferences.remove('password');
        await sharedPreferences.remove('rememberMe');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PatientPage(patient_username: userController.text)),
      );
    } else {
      if (docEmails.contains(userController.text) &&
          doc_passwords.contains(passwordController.text)) {
        final sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setBool('isUserLogged', true);

        if (rememberMe) {
          await _storeCredentials(userController.text, passwordController.text);
        } else {
          await sharedPreferences.remove('username');
          await sharedPreferences.remove('password');
          await sharedPreferences.remove('rememberMe');
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomePage(
                    doctor_username: userController.text,
                  )),
        );
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Wrong email/password')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text('Remember Me'),
              ],
            ),
            Container(
              height: 50,
              width: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => NewAccountPage()),
                  );
                },
                child: const Text(
                  'New? Create an account',
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}