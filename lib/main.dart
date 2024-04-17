import 'package:flutter/material.dart';
import 'package:junkee_dealer/login_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dealer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginSignupPage(), // Replace with the initial screen of your app
    );
  }
}

