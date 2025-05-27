import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sensors_plus/sensors_plus.dart';

import 'package:tokomakeup/pages/loginPage.dart';
import 'package:tokomakeup/pages/listPage.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeup Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: SplashScreen(),
    );
  }
}

// Splash Screen to check login status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('loggedIn') ?? false;

    if (loggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ListPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}









