import 'package:flutter/material.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
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
            return const Scaffold(
              body: Center(child: Text('Error loading preferences')),
            );
          }
        },
      ),
    );
  } //build
} //MyApp

