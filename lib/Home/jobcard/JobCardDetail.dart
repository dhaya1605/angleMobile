import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobcard/Home/batch/editBatch.dart';
import 'package:jobcard/Home/batch/moulding.dart';
import 'dart:math';

class jobCardDetails extends StatefulWidget {
  jobCardDetails(this.id);
  var id;
  @override
  _jobCardDetailsState createState() => _jobCardDetailsState(id);
}

class _jobCardDetailsState extends State<jobCardDetails> {
  _jobCardDetailsState(this.id);
  var id;
  DateTime _SdateTime;
  DateTime _EdateTime;
  var partId, machineId, materialId, plannedQuantity;
  bool getDoc = false;
  DateTime actualStartTime;
  DateTime actualEndTime;
  var actualQuanity,
      acceptedQuantity,
      operator;
  // List rejectionData;
  List downTimeData;
  var rejectedQuantity;
  var batchNumber;
  List rejecttionDataValues;
  var availability,performance,quality,oee;

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  calculateOOE(pQ,aQ,acQ,aS,aE,pS,pE){
    var plannedTime = pE.difference(pS).inMinutes;
    var actualTime = aE.difference(aS).inMinutes;
    setState(() {
      availability = (actualTime+1)/(plannedTime+1) * 100;
      performance = (int.parse(actualQuanity)/plannedQuantity) * 100;
      quality = (acceptedQuantity/int.parse(actualQuanity)) * 100;
      availability = roundDouble(availability, 2);
      performance = roundDouble(performance, 2);
      quality = roundDouble(quality, 2);
      oee = roundDouble((availability*performance*quality)/10000, 2);
      print(oee);
    });
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
                actualStartTime = value['actualStartTime'].toDate();
                actualEndTime = value['actualEndTime'].toDate();
                actualQuanity = value['actualQuantity'];
                operator = value['operator'];
                // rejectionData = value['rejectionData'];
                downTimeData = value['downTimeData'];
                acceptedQuantity = int.parse(actualQuanity)-value['totalRejectedQuantity'];
                batchNumber = value['batchNumber'];
                rejecttionDataValues = value['rejectionDataValues'];
              })
            });
    setState(() {
      getDoc = true;
    });
    calculateOOE(plannedQuantity,actualQuanity,acceptedQuantity,actualStartTime,actualEndTime,_SdateTime,_EdateTime);
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
                        height: mHeight * 0.01,
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
                      SizedBox(
                        height: mHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Performance",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                          SizedBox(
                            width: mwidth * 0.05,
                          ),
                          Text(
                            "$performance %",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Availability",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                          SizedBox(
                            width: mwidth * 0.05,
                          ),
                          Text(
                            "$availability %",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Quality",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                          SizedBox(
                            width: mwidth * 0.05,
                          ),
                          Text(
                            "$quality %",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mHeight * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "OEE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                          SizedBox(
                            width: mwidth * 0.05,
                          ),
                          Text(
                            "$oee %",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: mwidth * 0.04),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mHeight * 0.01,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>editBatch(id)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: mwidth * 0.9,
                            height: mHeight * 0.35,
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
                      ),
                      SizedBox(
                        height: mHeight * 0.02,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>moulding(id)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: mwidth * 0.9,
                            height: mHeight * 0.35,
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
                                    Text(
                                      "Accepted Quantity:",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mwidth * 0.04),
                                    ),
                                    SizedBox(
                                      width: mwidth * 0.05,
                                    ),
                                    Text(
                                      "$acceptedQuantity",
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
                                    Text(
                                      "Actual Quantity:",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mwidth * 0.04),
                                    ),
                                    SizedBox(
                                      width: mwidth * 0.05,
                                    ),
                                    Text(
                                      "$actualQuanity",
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
                                          "Actual Start Time",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: mwidth * 0.04),
                                        ),
                                        SizedBox(
                                          width: mwidth * 0.05,
                                        ),
                                        Text(
                                          actualStartTime.day.toString()+"-"+actualStartTime.month.toString()+"-"+actualStartTime.year.toString()+"     "+actualStartTime.hour.toString()+":"+(actualStartTime.minute>=10 ? actualStartTime.minute.toString():"0"+actualStartTime.minute.toString()),
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
                                          "Actual End Time",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: mwidth * 0.04),
                                        ),
                                        SizedBox(
                                          width: mwidth * 0.05,
                                        ),
                                        Text(
                                          actualEndTime.day.toString()+"-"+actualEndTime.month.toString()+"-"+actualEndTime.year.toString()+"     "+actualEndTime.hour.toString()+":"+(actualEndTime.minute>=10 ? actualEndTime.minute.toString():"0"+actualEndTime.minute.toString()),
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
                                          "Operator",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: mwidth * 0.04),
                                        ),
                                        SizedBox(
                                          width: mwidth * 0.05,
                                        ),
                                        Text(
                                          "$operator",
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
                      ),
                      SizedBox(
                        height: mHeight * 0.02,
                      ),
                      Text("Rejections",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: mwidth*0.04
                      ),),
                      SizedBox(
                        height: mHeight*0.01,
                      ),
                      Container(
                        height: mHeight*0.2,
                        width: mwidth*0.8,
                        decoration: BoxDecoration(
                          color: textFieldBackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border:
                          Border.all(color: secondaryColor, width: 1.0),
                        ),
                        child: ListView.builder(
                          itemCount: rejecttionDataValues.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('${rejecttionDataValues[index]["quantity"]} - ${rejecttionDataValues[index]["name"]}',style: TextStyle(
                                color: Colors.white,
                              ),),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: mHeight * 0.02,
                      ),
                      Text("DownTime",style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: mwidth*0.04
                      ),),
                      SizedBox(
                        height: mHeight*0.01,
                      ),
                      Container(
                        height: mHeight*0.2,
                        width: mwidth*0.8,
                        decoration: BoxDecoration(
                          color: textFieldBackgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                          border:
                          Border.all(color: secondaryColor, width: 1.0),
                        ),
                        child: ListView.builder(
                          itemCount: downTimeData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('${downTimeData[index]}',style: TextStyle(
                                color: Colors.white,
                              ),),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: mHeight*0.05,
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
