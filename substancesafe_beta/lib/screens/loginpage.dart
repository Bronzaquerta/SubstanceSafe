import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/homepage.dart';

class LoginPage extends StatefulWidget{
  static const Username= 'Doctor';
  static const Password= 'D0c7oR';
  LoginPage({Key? key}) : super(key: key);
  State<LoginPage> createState() => LoginPageState();
  
}
class LoginPageState extends State<LoginPage> {
  static const routename = 'Login Page';
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LoginPageState.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 375,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter username'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 375,
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
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async{
                    

                    if (usernameController.text == LoginPage.Username &&
                        passwordController.text == LoginPage.Password) {
                          final sp= await SharedPreferences.getInstance();
                    await sp.setBool('auth', true);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong credentials'),
                        duration: const Duration(seconds: 2),),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}//LoginPageState