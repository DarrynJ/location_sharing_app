import 'package:flutter/material.dart';
import 'package:location_sharing_app/navigation/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 70),
          child: Image.asset(
            'assets/images/wbclogo.png',
            height: 200,
            width: 200,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: const Text(
            'We Track Cars',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: 'Username',
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: MaterialButton(
              height: 50.5,
              child: const Text("Login"),
              color: Colors.orange,
              textColor: Colors.white,
              minWidth: 320.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                Navigator.pushNamed(context, Routes.MAP,
                    arguments: _usernameController.text);
              },
            ),
          ),
        ),
      ],
    )));
  }
}
