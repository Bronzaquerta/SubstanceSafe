import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:substancesafe_beta/screens/homepage.dart';
import 'package:substancesafe_beta/screens/patientPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

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
    if (userController.text == 'bug@expert.com' &&
        passwordController.text == '5TrNgP5Wd') {
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
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Wrong email/password')));
    }
  }

  void _goToPatientPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PatientPage()),
    );
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
            Container(
              height: 50,
              width: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: _goToPatientPage,
                child: Text(
                  'To Patient Page',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
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
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
