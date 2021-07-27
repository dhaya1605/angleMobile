import 'package:flutter/material.dart';
import 'package:jobcard/Home/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: homePage(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff515152),
        primarySwatch: Colors.blue,
        iconTheme: IconThemeData(
          color: Color(0xffA4A6A9)
        ),
        scaffoldBackgroundColor: Color(0xff020202),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xffFBC20C)
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: homePage(),
    );
  }
}

