import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobcard/Home/Material/materialList.dart';
import 'package:jobcard/Home/batch/batchList.dart';
import 'package:jobcard/Home/batch/batchProcess.dart';
import 'package:jobcard/Home/jobcard/jobcard.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'Dashboard/dashboard.dart';
import 'Part/partsList.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    dashboard(),
    jobCard(),
    partsList(),
    materialList(),
    batchList()
    // batchProcess1(0),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Platform.isAndroid ?
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: primaryColor
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'JobCard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hardware),
                label: 'Parts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_stream_outlined),
                label: 'Materials',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.backpack),
                label: 'Batch',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: secondaryColor,
            onTap: _onItemTapped,
          ),
        ) :
        CupertinoTabBar(items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_square),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.app_badge),
            label: 'JobCard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.hammer),
            label: 'Parts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack_3d_up),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bold),
            label: 'Batch',
          ),
        ],
          currentIndex: _selectedIndex,
          activeColor: secondaryColor,
          onTap: _onItemTapped,
          backgroundColor: primaryColor,
        ),
      body: _widgetOptions[_selectedIndex],
      );
  }
}
