import 'package:flutter/material.dart';
import 'HomeScreen/HomeScreen.dart';
import 'Signup_login/Signup.dart';
import 'Signup_login/login.dart';
import 'SplashScreen/landingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat/chat_page.dart';
import 'group/search_and_join.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      home: LandingScreen(),
    );
  }
}
