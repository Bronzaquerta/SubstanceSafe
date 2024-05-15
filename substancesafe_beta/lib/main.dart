import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
      return FutureBuilder(future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
      if(snapshot.hasData){        
        if(snapshot.data!.getBool('auth')==true){
          return MaterialApp(home: HomePage());
        }
        else{
          return MaterialApp(home: LoginPage(),);
        }        
      }
      else{
        return CircularProgressIndicator();
      }
      } );
      
    
  }
}
