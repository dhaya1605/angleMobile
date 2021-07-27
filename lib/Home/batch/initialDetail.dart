import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';


class initialDetail extends StatefulWidget {
  @override
  _initialDetailState createState() => _initialDetailState();
}

class _initialDetailState extends State<initialDetail> {

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          child: Column(
            children: [
              initial('id'),
            ],
          ),
        ),
      ),
    );  }
}


class initial extends StatefulWidget {
  initial(this.id);
  var id;
  @override
  _initialState createState() => _initialState(id);
}

class _initialState extends State<initial> {
  _initialState(this.id);
  final _formKey = GlobalKey<FormState>();
  DateTime _SdateTime = DateTime.now();
  DateTime _EdateTime = DateTime.now();
  var partId,machineId,materialId,plannedQuantity,batchNumber;
  var id;
  var suggestedPartId = '',suggestedMaterialId='',suggestedMachineId = '';
  bool _isSelected = false;
  // void upload(){
  //   print("hi");
  // }
  List<String> partsSuggestions = [''];
  List<String> materialSuggestions = [''];
  List<String> machineSuggestions = [''];
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();

  var partsIdMap = new Map();
  var materialsIdMap = new Map();
  var machinesIdMap = new Map();
  var diffterenceOfTime;
  var cycleTime;

  calculatePlannedQuantity() async{
    var value = await FirebaseFirestore.instance.collection('parts').doc(partsIdMap[suggestedPartId]).get();
    cycleTime = value.data()['cycleTime'];
    diffterenceOfTime = _EdateTime.difference(_SdateTime).inMinutes * 60;
    var result = diffterenceOfTime/cycleTime;
    setState(() {
      plannedQuantity = result.toInt();
    });
    print(cycleTime);
    print(diffterenceOfTime);
    print(result);
  }


  getMachine() async{
    await FirebaseFirestore.instance.collection('machines').get().then((value) {
      for(var doc in value.docs){
        var d = doc.data()["name"];
        machinesIdMap[d] = doc.id;
        machineSuggestions.add(doc.data()["name"]);
        setState(() {
          machineSuggestions = machineSuggestions;
        });
      }
    });
    print(machineSuggestions);
  }
  getMaterial() async{
    await FirebaseFirestore.instance.collection('materials').get().then((value) {
      for(var doc in value.docs){
        var d = doc.data()["name"];
        materialsIdMap[d] = doc.id;
        materialSuggestions.add(doc.data()["name"]);
        setState(() {
          materialSuggestions = materialSuggestions;
        });
      }
    });
    print(materialSuggestions);
  }

  getParts() async{
    await FirebaseFirestore.instance.collection('parts').get().then((value) {
      for(var doc in value.docs){
        var d = doc.data()["name"];
        partsSuggestions.add(doc.data()["name"]);
        partsIdMap[d] = doc.id;
        setState(() {
          partsSuggestions = partsSuggestions;
        });
      }
    });
    print(partsSuggestions);
    print(partsIdMap);
  }
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
  Future<void> _showMyDialog1() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fill Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Values should not be empty'),
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

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: mHeight * 0.05,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Batch Number",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
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
                                borderSide:
                                BorderSide(color: secondaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: secondaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              fillColor: primaryColor,
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mwidth * 0.035),
                              hintText: 'eg. 0001',
                              hintStyle:
                              TextStyle(color: Colors.white54),
                            ),
                            onChanged: (value) {
                              setState(() {
                                // name = value;
                                batchNumber = value;
                              });
                            },
                            validator: (value) {
                              if ((value == null || value.isEmpty) &&
                                  true) {
                                return "Required";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Part Name",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 10.0,
                              bottom: 5.0),
                          child: SimpleAutoCompleteTextField(
                            key: key,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              fillColor: primaryColor,
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mwidth*0.035
                              ),
                              hintText: 'eg. GB LHD Reservior',
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                            ),
                            suggestions: partsSuggestions,
                            clearOnSubmit: false,
                            textSubmitted: (text) => setState(() {
                              if (text != "") {
                                suggestedPartId = text;
                                print(suggestedPartId);
                              }
                            }),
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Material Name",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 10.0,
                              bottom: 5.0),
                          child: SimpleAutoCompleteTextField(
                            key: key1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              fillColor: primaryColor,
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mwidth*0.035
                              ),
                              hintText: 'eg. GB LHD Reservior',
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                            ),
                            suggestions: materialSuggestions,
                            clearOnSubmit: false,
                            textSubmitted: (text) => setState(() {
                              if (text != "") {
                                suggestedMaterialId = text;
                                print(suggestedMaterialId);
                              }
                            }),
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Machine Name",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 10.0,
                              bottom: 5.0),
                          child: SimpleAutoCompleteTextField(
                            key: key2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              filled: true,
                              fillColor: primaryColor,
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mwidth*0.035
                              ),
                              hintText: 'eg. GB LHD Reservior',
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                            ),
                            suggestions: machineSuggestions,
                            clearOnSubmit: false,
                            textSubmitted: (text) => setState(() {
                              if (text != "") {
                                suggestedMachineId = text;
                                print(suggestedMachineId);
                              }
                            }),
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Planned Start Time",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
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
                                width: mwidth*0.5,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // height: mHeight*0.1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                  child: Column(
                                    children: [
                                      Text("Date:  "+_SdateTime.day.toString()+"-"+_SdateTime.month.toString()+"-"+_SdateTime.year.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mwidth*0.04
                                      ),
                                      ),
                                      Text("Time:  "+(_SdateTime.hour>12?(_SdateTime.hour-12):_SdateTime.hour).toString()+":"+
                                        (_SdateTime.minute>=10 ? _SdateTime.minute.toString():"0"+_SdateTime.minute.toString())
                                          +" "+(_SdateTime.hour>12?"PM":"AM"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth*0.04
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mwidth*0.25,
                              height: mHeight*0.04,
                              child: MaterialButton(
                                  color: Colors.white,
                                  child: Text("Change"),
                                  onPressed:(){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext builder) {
                                          return Container(
                                            height: mHeight * 0.25,
                                            child: CupertinoDatePicker(
                                              use24hFormat: false,
                                              onDateTimeChanged: (time) {
                                                setState(() {
                                                  _SdateTime = time;
                                                });
                                                //print(_SdateTime);
                                              },
                                              initialDateTime: _SdateTime,
                                            ),
                                          );
                                        });
                                  }
                              ),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                width: mwidth * 0.9,
                height: mHeight * 0.15,
                color: textFieldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: mwidth * 0.05,
                            ),
                            Text(
                              "Planned End Time",
                              style: TextStyle(
                                  color: formLabelColor,
                                  fontSize: mwidth * 0.04,
                                  fontWeight: FontWeight.bold),
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
                                width: mwidth*0.5,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                // height: mHeight*0.1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical:8.0),
                                  child: Column(
                                    children: [
                                      Text("Date:  "+_EdateTime.day.toString()+"-"+_EdateTime.month.toString()+"-"+_EdateTime.year.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth*0.04
                                        ),
                                      ),
                                      Text("Time:  "+(_EdateTime.hour>12?(_EdateTime.hour-12):_EdateTime.hour).toString()+":"+
                                          (_EdateTime.minute>=10 ? _EdateTime.minute.toString():"0"+_EdateTime.minute.toString()) +
                                          " "+(_EdateTime.hour>12?"PM":"AM"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: mwidth*0.04
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: mwidth*0.25,
                              height: mHeight*0.04,
                              child: MaterialButton(
                                  color: Colors.white,
                                  child: Text("Change"),
                                  onPressed:(){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext builder) {
                                          return Container(
                                            height: mHeight * 0.25,
                                            child: CupertinoDatePicker(
                                              // minimumDate: _SdateTime,
                                              use24hFormat: false,
                                              onDateTimeChanged: (time) {
                                                setState(() {
                                                  _EdateTime = time;
                                                });
                                                //print(_EdateTime);
                                              },
                                              initialDateTime: _EdateTime,
                                            ),
                                          );
                                        });
                                  }
                              ),
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



          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          //     child: Container(
          //       width: mwidth * 0.9,
          //       height: mHeight * 0.15,
          //       color: textFieldBackgroundColor,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   SizedBox(
          //                     width: mwidth * 0.05,
          //                   ),
          //                   Text(
          //                     "Planned Quantity",
          //                     style: TextStyle(
          //                         color: formLabelColor,
          //                         fontSize: mwidth * 0.04,
          //                         fontWeight: FontWeight.bold),
          //                   ),
          //                 ],
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 20.0,
          //                     right: 20.0,
          //                     top: 10.0,
          //                     bottom: 5.0),
          //                 child: TextFormField(
          //                   decoration: InputDecoration(
          //                     border: OutlineInputBorder(
          //                       borderSide:
          //                       BorderSide(color: secondaryColor),
          //                     ),
          //                     focusedBorder: OutlineInputBorder(
          //                       borderSide:
          //                       BorderSide(color: secondaryColor),
          //                     ),
          //                     errorBorder: OutlineInputBorder(
          //                       borderSide:
          //                       BorderSide(color: Colors.red),
          //                     ),
          //                     filled: true,
          //                     fillColor: primaryColor,
          //                     errorStyle: TextStyle(
          //                         color: Colors.red,
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: mwidth * 0.035),
          //                     hintText: 'eg. 1 Kg',
          //                     hintStyle:
          //                     TextStyle(color: Colors.white54),
          //                   ),
          //                   onChanged: (value) {
          //                     setState(() {
          //                       // name = value;
          //                       plannedQuantity = value;
          //                     });
          //                   },
          //                   validator: (value) {
          //                     if ((value == null || value.isEmpty) &&
          //                         true) {
          //                       return "Required";
          //                     }
          //                     return null;
          //                   },
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //     // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
          //   ),
          // ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GestureDetector(
                onTap: () async{
                  await calculatePlannedQuantity();
                  var id = Uuid().v4();
                  if(_SdateTime.isBefore(_EdateTime)) {
                    if(suggestedPartId!='' && suggestedMachineId!='' && suggestedMaterialId!='') {
                      if (_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('batchcard')
                            .doc(id)
                            .set({
                          'status': "batchcard",
                          'partId': suggestedPartId,
                          'machineId': suggestedMachineId,
                          'materialId': suggestedMaterialId,
                          'plannedStartTime': _SdateTime,
                          'plannedEndTime': _EdateTime,
                          'plannedQuantity': plannedQuantity,
                          'id': id,
                          'batchNumber': batchNumber,
                          'createdAt':DateTime.now(),
                          'partDocId':partsIdMap[suggestedPartId],
                          'materialDocId':materialsIdMap[suggestedMaterialId],
                          'machineDocId':machinesIdMap[suggestedMachineId],
                        });
                        Navigator.pop(context);
                      }
                    }
                    else{
                      _showMyDialog1();
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
                  child: Center(child: Text("Create",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mwidth*0.04
                  ),
                  )),
                ),
              ),
              // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
            ),
          ),
          SizedBox(
            height: mHeight*0.1,
          ),
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParts();
    getMaterial();
    getMachine();
  }
}