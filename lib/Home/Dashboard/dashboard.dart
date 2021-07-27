import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobcard/Home/Part/newPart.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();


  List<String> suggestions = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];
  SimpleAutoCompleteTextField textField;
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;


    return Scaffold(
        backgroundColor: textFieldBackgroundColor,
        appBar:
        Platform.isAndroid?
        AppBar(
          title: Text("Dashboard"),
          backgroundColor: primaryColor,
        ):
        CupertinoNavigationBar(
          middle: Text("Dashboard",style: TextStyle(
              color: Colors.white
          ),),
          backgroundColor: Color(0xff515152),
        ),
        body: Column(
        ));
  }
}
