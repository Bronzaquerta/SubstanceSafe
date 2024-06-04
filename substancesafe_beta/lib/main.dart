import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';

void main() {
  runApp(MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            final sharedPreferences = snapshot.data as SharedPreferences;
            final isUserLogged =
                sharedPreferences.getBool('isUserLogged') ?? false;

            if (isUserLogged) {
              return HomePage();
            } else {
              return LoginPage();
            }
          } else {
            return Scaffold(
              body: Center(child: Text('Error loading preferences')),
            );
          }
        },
      ),
    );
  } //build
} //MyApp

