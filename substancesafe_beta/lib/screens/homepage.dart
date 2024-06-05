// homepage.dart
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';
import 'package:substancesafe_beta/screens/patientDetailPage.dart';
import 'package:substancesafe_beta/utils/impact.dart';
import 'package:substancesafe_beta/utils/patient_list.dart'; // Import the patient list

class HomePage extends StatefulWidget {
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

  // Define a function to apply Caesar cipher encryption
  String caesarEncrypt(String text, int shift) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        // Encrypt uppercase letters
        result.write(String.fromCharCode((charCode - 65 + shift) % 26 + 65));
      } else if (charCode >= 97 && charCode <= 122) {
        // Encrypt lowercase letters
        result.write(String.fromCharCode((charCode - 97 + shift) % 26 + 97));
      } else {
        // Keep non-alphabetic characters unchanged
        result.write(text[i]);
      }
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeePage'),
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
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                // Encrypt the patient name using Caesar cipher with a shift of 3
                String encryptedName = caesarEncrypt(patients[index]['name']!, 3);
                return ListTile(
                  title: Text(encryptedName), // Display the encrypted name
                  subtitle: Text('Number: ${patients[index]['number']}'),
                );
              },
            ),
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
                        SnackBar(content: Text("""You didn't authorize""")));
                  return;
                }

                String patientNumber = patientNumberController.text;
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
