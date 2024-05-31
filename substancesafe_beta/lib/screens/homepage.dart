import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substance_safe_squad/screens/loginpage.dart';
import 'package:substance_safe_squad/screens/patientDetailPage.dart';
import 'package:substance_safe_squad/utils/impact.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController patientNumberController = TextEditingController();

  final List<Map<String, String>> patients = [
    {'name': 'Oguzhan Telli', 'number': '1'},
    {'name': 'Thomas Jahreis', 'number': '2'},
    {'name': 'Linda', 'number': '3'},
    {'name': 'Giacomo Cappon', 'number': '4'},
    // Add more patients here
  ];

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
                  return ListTile(
                    title: Text(patients[index]['name']!),
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
                        SnackBar(content: Text('You didn\'t authorize')));
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
              child: Text('Go'),
            ),
          ],
        ),
      ),
    );
  }
}
