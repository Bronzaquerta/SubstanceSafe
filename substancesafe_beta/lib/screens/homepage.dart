import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
      ),
      backgroundColor: Colors.lightBlue[50], // Vaaleampi sininen taustaväri
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  await sp.setBool('auth', false);
                  Navigator.pop(context);
                }, 
                child: Text('Back to Home')
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100], // Yhteenveto-boxin väri
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary of xx days', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10), 
                      Text(
                        'Sleep:', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Heart rate:', // Syke-luokka
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // 
                  }, 
                  child: Text('Current patient information')
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // 
                  },
                  child: Text('Patient history')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


