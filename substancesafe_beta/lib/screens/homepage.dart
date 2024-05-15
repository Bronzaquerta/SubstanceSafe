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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text('Work in progress'),
           ElevatedButton(onPressed: ()  async {
            final sp= await SharedPreferences.getInstance();
            await sp.setBool('auth', false);
            Navigator.pop(context);}, child: Text('Back to Home'))
          ],
        ),
      ),
    );
  } //build

} //HomePage
