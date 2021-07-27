import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class moulding extends StatefulWidget {
  moulding(this.id);
  var id;
  @override
  _mouldingState createState() => _mouldingState(id);
}

class _mouldingState extends State<moulding> {
  _mouldingState(this.id);
  var id;
  DateTime _SdateTime;
  DateTime _EdateTime;

  DateTime actualStartTime = DateTime.now();
  DateTime actualEndTime = DateTime.now();
  DateTime downTimeStartTime = DateTime.now();
  DateTime downTimeEndTime = DateTime.now();
  var partId, machineId, materialId, plannedQuantity,batchNumber;
  var actualQuanity,
      acceptedQuantity,
      operator,
      operation,
      rejectionQuantity,
      downtimeId;
  bool getDoc = false;
  final _formKey = GlobalKey<FormState>();

  List<Widget> rejectionList = [
    SizedBox(
      height: 20.0,
    )
  ];
  List<Widget> DownTimeList = [
    SizedBox(
      height: 20.0,
    )
  ];
  List<String> rejectionData = [];
  List<String> downTimeData = [];
  final fieldText1 = TextEditingController();
  final fieldText2 = TextEditingController();
  String dropdownValue1 = 'Short Mould';
  String dropdownValue2 = 'Short Mould';
  List<String> rejectionType = ['Short Mould', 'Spray Mark', 'Shrinkage', 'Bubbles', 'Blow Holes',
                                'Black Dots', 'White Patches', 'MisMatch','Damage',
                                'Setup Waste','Dent Mark', 'Weld Damage','Welding Black','Holes',
                                'Inset Gap','Thread Sticking','Fell Down','Colour Variation','Under Cut','Date Code','Flow Mark',
                                'Silver Streak','Warpage','Insert Missing','Others'];
  List<String> downTimeType = ['Short Mould', 'Spray Mark', 'Shrinkage'];
  var rejectedQuantity = 0;

  List<Map> rejectionDataValues = [];
  List<Map> downTimeDataValues = [];

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Interval Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Start time should be lesser than End time'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  getDocument(id) async {
    await FirebaseFirestore.instance
        .collection('batchcard')
        .doc(id)
        .get()
        .then((value) => {
              setState(() {
                partId = value['partId'];
                machineId = value['machineId'];
                materialId = value['materialId'];
                _SdateTime = value['plannedStartTime'].toDate();
                _EdateTime = value['plannedEndTime'].toDate();
                plannedQuantity = value['plannedQuantity'];
                batchNumber = value['batchNumber'];
              })
            });
    setState(() {
      getDoc = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return getDoc
        ? Scaffold(
            backgroundColor: textFieldBackgroundColor,
            appBar: Platform.isAndroid
                ? AppBar(
                    title: Text("Batch Details"),
                    backgroundColor: primaryColor,
                  )
                : CupertinoNavigationBar(
                    middle: Text(
                      "Batch Details",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: primaryColor,
                  ),
            body: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: mHeight*0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "BatchNumber",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: mwidth * 0.04),
                              ),
                              SizedBox(
                                width: mwidth * 0.05,
                              ),
                              Text(
                                "$batchNumber",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: mwidth * 0.04),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mwidth * 0.9,
                          height: mHeight * 0.38,
                          decoration: BoxDecoration(
                            color: textFieldBackgroundColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border:
                                Border.all(color: secondaryColor, width: 1.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Part Id:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                      SizedBox(
                                        width: mwidth * 0.05,
                                      ),
                                      Text(
                                        "$partId",
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Machine Id:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                      SizedBox(
                                        width: mwidth * 0.05,
                                      ),
                                      Text(
                                        "$machineId",
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Material Id:",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                      SizedBox(
                                        width: mwidth * 0.05,
                                      ),
                                      Text(
                                        "$materialId",
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Planned Quantity:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mwidth * 0.04),
                                  ),
                                  SizedBox(
                                    width: mwidth * 0.05,
                                  ),
                                  Text(
                                    "$plannedQuantity",
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mwidth * 0.04),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Planned Start Time",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                      SizedBox(
                                        width: mwidth * 0.05,
                                      ),
                                      Text(
                                        _SdateTime.day.toString()+"-"+_SdateTime.month.toString()+"-"+_SdateTime.year.toString()+"     "+_SdateTime.hour.toString()+":"+(_SdateTime.minute>=10 ? _SdateTime.minute.toString():"0"+_SdateTime.minute.toString()),
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Planned End Time",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                      SizedBox(
                                        width: mwidth * 0.05,
                                      ),
                                      Text(
                                        _EdateTime.day.toString()+"-"+_EdateTime.month.toString()+"-"+_EdateTime.year.toString()+"     "+_EdateTime.hour.toString()+":"+(_EdateTime.minute>=10 ? _EdateTime.minute.toString():"0"+_EdateTime.minute.toString()),
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth * 0.04),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: mHeight * 0.05,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  width: mwidth * 0.9,
                                  height: mHeight * 0.15,
                                  color: textFieldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: mwidth * 0.05,
                                              ),
                                              Text(
                                                "Operator",
                                                style: TextStyle(
                                                    color: formLabelColor,
                                                    fontSize: mwidth * 0.04,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 10.0,
                                                bottom: 5.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                filled: true,
                                                fillColor: primaryColor,
                                                errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: mwidth * 0.035),
                                                hintText: 'eg. John',
                                                hintStyle: TextStyle(
                                                    color: Colors.white54),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  // name = value;
                                                  operator = value;
                                                });
                                              },
                                              validator: (value) {
                                                if ((value == null ||
                                                        value.isEmpty) &&
                                                    true) {
                                                  return "Required";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                              ),
                            ),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  width: mwidth * 0.9,
                                  height: mHeight * 0.15,
                                  color: textFieldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: mwidth * 0.05,
                                              ),
                                              Text(
                                                "Actual Start Time",
                                                style: TextStyle(
                                                    color: formLabelColor,
                                                    fontSize: mwidth * 0.04,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    top: 10.0,
                                                    bottom: 5.0),
                                                child: Container(
                                                  width: mwidth * 0.5,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  // height: mHeight*0.1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Date:  " +
                                                              actualStartTime
                                                                  .day
                                                                  .toString() +
                                                              "-" +
                                                              actualStartTime
                                                                  .month
                                                                  .toString() +
                                                              "-" +
                                                              actualStartTime
                                                                  .year
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: mwidth *
                                                                  0.04),
                                                        ),
                                                        Text(
                                                          "Time:  " +
                                                              (actualStartTime.hour >
                                                                          12
                                                                      ? (actualStartTime
                                                                              .hour -
                                                                          12)
                                                                      : actualStartTime
                                                                          .hour)
                                                                  .toString() +
                                                              ":" +
                                                              (actualStartTime.minute>=10 ? actualStartTime.minute.toString():"0"+actualStartTime.minute.toString()) +
                                                              " " +
                                                              (actualStartTime
                                                                          .hour >
                                                                      12
                                                                  ? "PM"
                                                                  : "AM"),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: mwidth *
                                                                  0.04),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: mwidth * 0.25,
                                                height: mHeight * 0.04,
                                                child: MaterialButton(
                                                    color: Colors.white,
                                                    child: Text("Change"),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              builder) {
                                                            return Container(
                                                              height: mHeight *
                                                                  0.25,
                                                              child:
                                                                  CupertinoDatePicker(
                                                                use24hFormat:
                                                                    false,
                                                                onDateTimeChanged:
                                                                    (time) {
                                                                  setState(() {
                                                                    actualStartTime =
                                                                        time;
                                                                  });
                                                                  //print(_SdateTime);
                                                                },
                                                                initialDateTime:
                                                                    actualStartTime,
                                                              ),
                                                            );
                                                          });
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  width: mwidth * 0.9,
                                  height: mHeight * 0.15,
                                  color: textFieldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: mwidth * 0.05,
                                              ),
                                              Text(
                                                "Actual End Time",
                                                style: TextStyle(
                                                    color: formLabelColor,
                                                    fontSize: mwidth * 0.04,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                    top: 10.0,
                                                    bottom: 5.0),
                                                child: Container(
                                                  width: mwidth * 0.5,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  // height: mHeight*0.1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Date:  " +
                                                              actualEndTime.day
                                                                  .toString() +
                                                              "-" +
                                                              actualEndTime
                                                                  .month
                                                                  .toString() +
                                                              "-" +
                                                              actualEndTime.year
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: mwidth *
                                                                  0.04),
                                                        ),
                                                        Text(
                                                          "Time:  " +
                                                              (actualEndTime.hour >
                                                                          12
                                                                      ? (actualEndTime
                                                                              .hour -
                                                                          12)
                                                                      : actualEndTime
                                                                          .hour)
                                                                  .toString() +
                                                              ":" +(actualEndTime.minute>=10 ? actualEndTime.minute.toString():"0"+actualEndTime.minute.toString())+
                                                              " " +
                                                              (actualEndTime
                                                                          .hour >
                                                                      12
                                                                  ? "PM"
                                                                  : "AM"),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: mwidth *
                                                                  0.04),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: mwidth * 0.25,
                                                height: mHeight * 0.04,
                                                child: MaterialButton(
                                                    color: Colors.white,
                                                    child: Text("Change"),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              builder) {
                                                            return Container(
                                                              height: mHeight *
                                                                  0.25,
                                                              child:
                                                                  CupertinoDatePicker(
                                                                use24hFormat:
                                                                    false,
                                                                onDateTimeChanged:
                                                                    (time) {
                                                                  setState(() {
                                                                    actualEndTime =
                                                                        time;
                                                                  });
                                                                  //print(_EdateTime);
                                                                },
                                                                initialDateTime:
                                                                    actualEndTime,
                                                              ),
                                                            );
                                                          });
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                              ),
                            ),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  width: mwidth * 0.9,
                                  height: mHeight * 0.15,
                                  color: textFieldBackgroundColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: mwidth * 0.05,
                                              ),
                                              Text(
                                                "Actual Quantity",
                                                style: TextStyle(
                                                    color: formLabelColor,
                                                    fontSize: mwidth * 0.04,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 10.0,
                                                bottom: 5.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                filled: true,
                                                fillColor: primaryColor,
                                                errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: mwidth * 0.035),
                                                hintText: 'eg. 1 Kg',
                                                hintStyle: TextStyle(
                                                    color: Colors.white54),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  // name = value;
                                                  actualQuanity = value;
                                                });
                                              },
                                              validator: (value) {
                                                if ((value == null ||
                                                        value.isEmpty) &&
                                                    true) {
                                                  return "Required";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                              ),
                            ),

                            Column(
                              children: [
                                Text(
                                  "Rejection",
                                  style: TextStyle(
                                      color: formLabelColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mwidth * 0.04),
                                ),
                                Column(
                                  children: rejectionList,
                                ),
                                Container(
                                  width: mwidth * 0.27,
                                  height: mHeight * 0.07,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // fieldText.clear();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: primaryColor,
                                              title: Text('Rejection Detail',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              ),
                                              content: StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return Container(
                                                      width: mwidth*0.8,
                                                      height: mHeight*0.4,
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: mHeight*0.05,
                                                              ),
                                                              Text("Rejection Quantity",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: mHeight*0.02,
                                                              ),
                                                              Container(
                                                                width: mwidth*0.5,
                                                                child: Theme(
                                                                  data: ThemeData(
                                                                    primaryColor: secondaryColor,
                                                                  ),
                                                                  child: TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.digitsOnly,
                                                                    ],
                                                                    style: TextStyle(
                                                                      color: secondaryColor,
                                                                    ),
                                                                    controller: fieldText1,
                                                                    decoration: InputDecoration(
                                                                        hintText: "eg. 001",
                                                                      hintStyle: TextStyle(
                                                                        color: Colors.white54,
                                                                      ),
                                                                    ),
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        rejectionQuantity = value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: mHeight*0.1,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text("Rejection Type",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: mHeight*0.03,
                                                              ),
                                                              DropdownButton<String>(
                                                                value: dropdownValue1,
                                                                icon: const Icon(Icons.arrow_downward),
                                                                iconSize: 24,
                                                                elevation: 16,
                                                                style: const TextStyle(color: secondaryColor),
                                                                underline: Container(
                                                                  height: 2,
                                                                  color: secondaryColor,
                                                                ),
                                                                onChanged: (String newValue) {
                                                                  setState(() {
                                                                    // dummyDropDownValue = newValue;
                                                                    dropdownValue1 = newValue;
                                                                  });
                                                                },
                                                                items: rejectionType
                                                                    .map<DropdownMenuItem<String>>((String value) {
                                                                  return DropdownMenuItem<String>(
                                                                    value: value,
                                                                    child: Text(value),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('SUBMIT',style: TextStyle(color: secondaryColor),),
                                                  onPressed: () {
                                                    if(rejectionQuantity!=null) {
                                                      rejectionDataValues.add({"quantity":int.parse(rejectionQuantity),"name":dropdownValue1});
                                                      rejectionList.add(
                                                          ListTileList(rejectionQuantity, dropdownValue1));
                                                      // rejectionData
                                                      //     .add(rejectionQuantity+" "+dropdownValue1);
                                                      setState(() {
                                                        rejectedQuantity = rejectedQuantity + int.parse(rejectionQuantity);
                                                        // rejectionData = rejectionData;
                                                        rejectionList = rejectionList;
                                                        rejectionQuantity = null;
                                                      });
                                                      // _textFieldController.clear();
                                                      fieldText1.clear();
                                                      // print(rejectionData);
                                                      print(rejectedQuantity);
                                                      print(rejectionDataValues);
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('CLOSE',style: TextStyle(color: secondaryColor),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: secondaryColor,
                                        ),
                                        SizedBox(
                                          width: mwidth * 0.01,
                                        ),
                                        Text(
                                          "ADD",
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      elevation: 10.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: mHeight * 0.05,
                                ),
                              ],
                            ),


                            
                            Column(
                              children: [
                                Text(
                                  "DownTime",
                                  style: TextStyle(
                                      color: formLabelColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mwidth * 0.04),
                                ),
                                Column(
                                  children: DownTimeList,
                                ),
                                Container(
                                  width: mwidth * 0.27,
                                  height: mHeight * 0.07,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // _displayDialog(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: primaryColor,
                                              title: Text('DownTime Detail',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              content: StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return Container(
                                                      width: mwidth*0.8,
                                                      height: mHeight*0.7,
                                                      child: Column(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: mHeight*0.05,
                                                              ),
                                                              Text("DownTime Type",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: mHeight*0.02,
                                                              ),
                                                              Container(
                                                                width: mwidth*0.6,
                                                                child: Theme(
                                                                  data: ThemeData(
                                                                    primaryColor: secondaryColor,
                                                                  ),
                                                                  child: TextFormField(
                                                                    style: TextStyle(
                                                                      color: secondaryColor,
                                                                    ),
                                                                    controller: fieldText2,
                                                                    decoration: InputDecoration(
                                                                      hintText: "eg. Power Cut",
                                                                      hintStyle: TextStyle(
                                                                        color: Colors.white54,
                                                                      ),
                                                                    ),
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        downtimeId = value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: mHeight*0.05,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text("DownTime Type",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: mHeight*0.03,
                                                              ),
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 8.0, right: 8.0),
                                                                  child: Container(
                                                                    width: mwidth * 0.9,
                                                                    height: mHeight * 0.2,
                                                                    color: textFieldBackgroundColor,
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: mwidth * 0.05,
                                                                                ),
                                                                                Text(
                                                                                  "Start Time",
                                                                                  style: TextStyle(
                                                                                      color: formLabelColor,
                                                                                      fontSize: mwidth * 0.04,
                                                                                      fontWeight:
                                                                                      FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                      left: 20.0,
                                                                                      right: 20.0,
                                                                                      top: 10.0,
                                                                                      bottom: 5.0),
                                                                                  child: Container(
                                                                                    width: mwidth * 0.6,
                                                                                    decoration: BoxDecoration(
                                                                                      color: primaryColor,
                                                                                      borderRadius:
                                                                                      BorderRadius.circular(
                                                                                          10.0),
                                                                                    ),
                                                                                    // height: mHeight*0.1,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 8.0),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Date:  " +
                                                                                                downTimeStartTime
                                                                                                    .day
                                                                                                    .toString() +
                                                                                                "-" +
                                                                                                downTimeStartTime
                                                                                                    .month
                                                                                                    .toString() +
                                                                                                "-" +
                                                                                                downTimeStartTime
                                                                                                    .year
                                                                                                    .toString(),
                                                                                            style: TextStyle(
                                                                                                color:
                                                                                                Colors.white,
                                                                                                fontWeight:
                                                                                                FontWeight
                                                                                                    .bold,
                                                                                                fontSize: mwidth *
                                                                                                    0.04),
                                                                                          ),
                                                                                          Text(
                                                                                            "Time:  " +
                                                                                                (downTimeStartTime.hour >
                                                                                                    12
                                                                                                    ? (downTimeStartTime
                                                                                                    .hour -
                                                                                                    12)
                                                                                                    : downTimeStartTime
                                                                                                    .hour)
                                                                                                    .toString() +
                                                                                                ":" +
                                                                                                (downTimeStartTime.minute>=10 ? downTimeStartTime.minute.toString():"0"+downTimeStartTime.minute.toString()) +
                                                                                                " " +
                                                                                                (downTimeStartTime
                                                                                                    .hour >
                                                                                                    12
                                                                                                    ? "PM"
                                                                                                    : "AM"),
                                                                                            style: TextStyle(
                                                                                                color:
                                                                                                Colors.white,
                                                                                                fontWeight:
                                                                                                FontWeight
                                                                                                    .bold,
                                                                                                fontSize: mwidth *
                                                                                                    0.04),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: mwidth * 0.25,
                                                                                  height: mHeight * 0.04,
                                                                                  child: MaterialButton(
                                                                                      color: Colors.white,
                                                                                      child: Text("Change"),
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                            context: context,
                                                                                            builder: (BuildContext
                                                                                            builder) {
                                                                                              return Container(
                                                                                                height: mHeight *
                                                                                                    0.25,
                                                                                                child:
                                                                                                CupertinoDatePicker(
                                                                                                  use24hFormat:
                                                                                                  false,
                                                                                                  onDateTimeChanged:
                                                                                                      (time) {
                                                                                                    setState(() {
                                                                                                      downTimeStartTime =
                                                                                                          time;
                                                                                                    });
                                                                                                    //print(_SdateTime);
                                                                                                  },
                                                                                                  initialDateTime:
                                                                                                  downTimeStartTime,
                                                                                                ),
                                                                                              );
                                                                                            });
                                                                                      }),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 8.0, right: 8.0),
                                                                  child: Container(
                                                                    width: mwidth * 0.9,
                                                                    height: mHeight * 0.2,
                                                                    color: textFieldBackgroundColor,
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: mwidth * 0.05,
                                                                                ),
                                                                                Text(
                                                                                  "End Time",
                                                                                  style: TextStyle(
                                                                                      color: formLabelColor,
                                                                                      fontSize: mwidth * 0.04,
                                                                                      fontWeight:
                                                                                      FontWeight.bold),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                      left: 20.0,
                                                                                      right: 20.0,
                                                                                      top: 10.0,
                                                                                      bottom: 5.0),
                                                                                  child: Container(
                                                                                    width: mwidth * 0.6,
                                                                                    decoration: BoxDecoration(
                                                                                      color: primaryColor,
                                                                                      borderRadius:
                                                                                      BorderRadius.circular(
                                                                                          10.0),
                                                                                    ),
                                                                                    // height: mHeight*0.1,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 8.0),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Date:  " +
                                                                                                downTimeEndTime.day
                                                                                                    .toString() +
                                                                                                "-" +
                                                                                                downTimeEndTime
                                                                                                    .month
                                                                                                    .toString() +
                                                                                                "-" +
                                                                                                downTimeEndTime.year
                                                                                                    .toString(),
                                                                                            style: TextStyle(
                                                                                                color:
                                                                                                Colors.white,
                                                                                                fontWeight:
                                                                                                FontWeight
                                                                                                    .bold,
                                                                                                fontSize: mwidth *
                                                                                                    0.04),
                                                                                          ),
                                                                                          Text(
                                                                                            "Time:  " +
                                                                                                (downTimeEndTime.hour >
                                                                                                    12
                                                                                                    ? (downTimeEndTime
                                                                                                    .hour -
                                                                                                    12)
                                                                                                    : downTimeEndTime
                                                                                                    .hour)
                                                                                                    .toString() +
                                                                                                ":" +
                                                                                                (downTimeEndTime.minute>=10 ? downTimeEndTime.minute.toString():"0"+downTimeEndTime.minute.toString()) +
                                                                                                " " +
                                                                                                (downTimeEndTime
                                                                                                    .hour >
                                                                                                    12
                                                                                                    ? "PM"
                                                                                                    : "AM"),
                                                                                            style: TextStyle(
                                                                                                color:
                                                                                                Colors.white,
                                                                                                fontWeight:
                                                                                                FontWeight
                                                                                                    .bold,
                                                                                                fontSize: mwidth *
                                                                                                    0.04),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: mwidth * 0.25,
                                                                                  height: mHeight * 0.04,
                                                                                  child: MaterialButton(
                                                                                      color: Colors.white,
                                                                                      child: Text("Change"),
                                                                                      onPressed: () {
                                                                                        showModalBottomSheet(
                                                                                            context: context,
                                                                                            builder: (BuildContext
                                                                                            builder) {
                                                                                              return Container(
                                                                                                height: mHeight *
                                                                                                    0.25,
                                                                                                child:
                                                                                                CupertinoDatePicker(
                                                                                                  use24hFormat:
                                                                                                  false,
                                                                                                  onDateTimeChanged:
                                                                                                      (time) {
                                                                                                    setState(() {
                                                                                                      downTimeEndTime =
                                                                                                          time;
                                                                                                    });
                                                                                                    //print(_EdateTime);
                                                                                                  },
                                                                                                  initialDateTime:
                                                                                                  downTimeEndTime,
                                                                                                ),
                                                                                              );
                                                                                            });
                                                                                      }),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('SUBMIT',style: TextStyle(color: secondaryColor),),
                                                  onPressed: () {
                                                    if(downTimeStartTime.isBefore(downTimeEndTime)) {
                                                      if (downtimeId != null) {
                                                        DownTimeList.add(
                                                            ListTileList1(
                                                                downtimeId,
                                                                downTimeStartTime
                                                                    .difference(
                                                                    downTimeEndTime),
                                                              downTimeStartTime.difference(downTimeEndTime).inHours
                                                                    ));
                                                        downTimeData
                                                            .add(
                                                            downtimeId + " " +
                                                                (downTimeStartTime
                                                                    .difference(
                                                                    downTimeEndTime).inHours * -1)
                                                                    .toString()+"  Hours  "+(((downTimeStartTime.difference(downTimeEndTime).inMinutes)*-1)%60).toString()+"  Minutes");
                                                        setState(() {
                                                          downTimeData =
                                                              downTimeData;
                                                          DownTimeList =
                                                              DownTimeList;
                                                          downtimeId = null;
                                                        });
                                                        // _textFieldController.clear();
                                                        fieldText2.clear();
                                                        print(downTimeData);
                                                        setState(() {
                                                          downTimeStartTime =
                                                              DateTime.now();
                                                          downTimeEndTime =
                                                              DateTime.now();
                                                        });
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                    else{
                                                      _showMyDialog();
                                                    }
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('CLOSE',style: TextStyle(color: secondaryColor),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: secondaryColor,
                                        ),
                                        SizedBox(
                                          width: mwidth * 0.01,
                                        ),
                                        Text(
                                          "ADD",
                                          style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      elevation: 10.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: mHeight * 0.05,
                                ),
                              ],
                            ),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    // var id = Uuid().v4();
                                    if(actualStartTime.isBefore(actualEndTime)) {
                                      if (_formKey.currentState.validate()) {
                                        await FirebaseFirestore.instance
                                            .collection('batchcard')
                                            .doc(id)
                                            .update({
                                          'status': "jobcard",
                                          'operator': operator,
                                          'actualStartTime': actualStartTime,
                                          'actualEndTime': actualEndTime,
                                          'actualQuantity': actualQuanity,
                                          // 'acceptedQuantity': acceptedQuantity,
                                          // 'rejectionData': rejectionData,
                                          'downTimeData': downTimeData,
                                          'totalRejectedQuantity': rejectedQuantity,
                                          'rejectionDataValues':rejectionDataValues,
                                        });
                                        Navigator.pop(context);
                                      }
                                    }
                                    else{
                                      _showMyDialog();
                                    }
                                  },
                                  child: Container(
                                    width: mwidth * 0.8,
                                    height: mHeight * 0.07,
                                    color: secondaryColor,
                                    child: Center(
                                        child: Text(
                                      "Complete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mwidth * 0.04),
                                    )),
                                  ),
                                ),
                                // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
                              ),
                            ),
                            // Add TextFormFields and ElevatedButton here.
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mHeight * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Platform.isAndroid
            ? Scaffold(
                backgroundColor: textFieldBackgroundColor,
                body: Center(child: CircularProgressIndicator()))
            : Scaffold(
                backgroundColor: textFieldBackgroundColor,
                body: Center(
                    child: CupertinoActivityIndicator(
                  radius: 20.0,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocument(id);
  }
}

class ListTileList extends StatelessWidget {
  ListTileList(this.id, this.text);
  var id, text;
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: mwidth * 0.8,
          height: mHeight * 0.07,
          color: primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$id",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: mwidth * 0.01,
              ),
              Text(
                "$text",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          height: mHeight * 0.01,
        ),
      ],
    );
  }
}


class ListTileList1 extends StatelessWidget {
  ListTileList1(this.type, this.text,this.hours);
  var type, text, hours;
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: mwidth * 0.8,
          height: mHeight * 0.07,
          color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$type",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: mwidth * 0.01,
              ),
              Text(
                (text.inHours*-1).toString()+" Hours "+(hours==0?text.inMinutes.toString():(((text.inMinutes-(hours*60))).toString()))+" Minutes ",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          height: mHeight * 0.01,
        ),
      ],
    );
  }
}


