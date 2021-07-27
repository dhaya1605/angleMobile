import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';



class editBatch extends StatefulWidget {
  editBatch(this.id);
  var id;
  @override
  _editBatchState createState() => _editBatchState(id);
}

class _editBatchState extends State<editBatch> {
  _editBatchState(this.id);
  var id;
  final _formKey = GlobalKey<FormState>();
  DateTime _SdateTime;
  DateTime _EdateTime;
  var partId,machineId,materialId,plannedQuantity,batchNumber;
  bool getDoc = false;
  bool _isSelected = false;
  List<String> partsSuggestions = [''];
  List<String> materialSuggestions = [''];
  List<String> machineSuggestions = [''];
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();
  var suggestedPartId,suggestedMaterialId,suggestedMachineId;


  var partsIdMap = new Map();
  var materialsIdMap = new Map();
  var machinesIdMap = new Map();
  var diffterenceOfTime;
  var cycleTime;

  calculatePlannedQuantity() async{
    var value = await FirebaseFirestore.instance.collection('parts').doc(partsIdMap[suggestedPartId]).get();
    setState(() {
      cycleTime = value.data()['cycleTime'];
    });
    diffterenceOfTime = _EdateTime.difference(_SdateTime).inMinutes * 60;
    var result = diffterenceOfTime/cycleTime;
    setState(() {
      plannedQuantity = result.toInt();
    });
    print(cycleTime);
    print(diffterenceOfTime);
    print(result);
  }

  getDocument(id) async{
    await FirebaseFirestore.instance.collection('batchcard').doc(id).get().then((value) => {
      setState((){
        suggestedPartId = value['partId'];
        suggestedMachineId = value['machineId'];
        suggestedMaterialId = value['materialId'];
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
        partsIdMap[d] = doc.id;
        partsSuggestions.add(doc.data()["name"]);
        setState(() {
          partsSuggestions = partsSuggestions;
        });
      }
    });
    print(partsSuggestions);
    print(partsIdMap);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocument(id);
    getParts();
    getMaterial();
    getMachine();
  }
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return getDoc?
      Scaffold(
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
              Form(
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
                                      initialValue: batchNumber,
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
                                      controller: TextEditingController(text: suggestedPartId),
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
                                      controller: TextEditingController(text: suggestedMaterialId),
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
                                      controller: TextEditingController(text: suggestedMachineId),
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
                                                Text("Time:  "+(_SdateTime.hour>12?(_SdateTime.hour-12):_SdateTime.hour).toString()+":"+_SdateTime.minute.toString()+" "+(_SdateTime.hour>12?"PM":"AM"),
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
                                                Text("Time:  "+(_EdateTime.hour>12?(_EdateTime.hour-12):_EdateTime.hour).toString()+":"+_EdateTime.minute.toString()+" "+(_EdateTime.hour>12?"PM":"AM"),
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
                                        "Planned Quantity",
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
                                      initialValue: plannedQuantity.toString(),
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
                                        hintText: 'eg. 1 Kg',
                                        hintStyle:
                                        TextStyle(color: Colors.white54),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          // name = value;
                                          plannedQuantity = value;
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: GestureDetector(
                              onTap: () async{
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: mwidth * 0.35,
                                height: mHeight * 0.07,
                                color: secondaryColor,
                                child: Center(child: Text("Back",
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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: GestureDetector(
                              onTap: () async{
                                // var id = Uuid().v4();
                                await calculatePlannedQuantity();
                                if(_SdateTime.isBefore(_EdateTime)) {
                                  if (_formKey.currentState.validate()) {
                                    await FirebaseFirestore.instance
                                        .collection('batchcard')
                                        .doc(id)
                                        .update({
                                      'status': "batchcard",
                                      'partId': suggestedPartId,
                                      'machineId': suggestedMachineId,
                                      'materialId': suggestedMaterialId,
                                      'plannedStartTime': _SdateTime,
                                      'plannedEndTime': _EdateTime,
                                      'plannedQuantity': plannedQuantity,
                                      'id': id,
                                      'batchNumber':batchNumber,
                                      'partDocId':partsIdMap[suggestedPartId],
                                      'materialDocId':materialsIdMap[suggestedMaterialId],
                                      'machineDocId':machinesIdMap[suggestedMachineId],
                                    });
                                    Navigator.pop(context);
                                  }
                                }
                                else{
                                  _showMyDialog();
                                }
                              },
                              child: Container(
                                width: mwidth * 0.35,
                                height: mHeight * 0.07,
                                color: secondaryColor,
                                child: Center(child: Text("Update",
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
                      ],
                    ),
                    SizedBox(
                      height: mHeight*0.1,
                    ),
                    // Add TextFormFields and ElevatedButton here.
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    ):
    Platform.isAndroid?Scaffold(
        backgroundColor: textFieldBackgroundColor,
        body: Center(child: CircularProgressIndicator())):
    Scaffold(
        backgroundColor: textFieldBackgroundColor,
        body : Center(child: CupertinoActivityIndicator(
          radius: 20.0,
        )));
  }
}



// class initial extends StatefulWidget {
//   initial(this.id);
//   var id;
//   @override
//   _initialState createState() => _initialState(id);
// }
//
// class _initialState extends State<initial> {
//   _initialState(this.id);
//   final _formKey = GlobalKey<FormState>();
//   DateTime _SdateTime;
//   DateTime _EdateTime;
//   var partId,machineId,materialId,plannedQuantity;
//   var id;
//   bool getDoc = false;
//   bool _isSelected = false;
//   getDocument(id) async{
//     await FirebaseFirestore.instance.collection('batchcard').doc(id).get().then((value) => {
//       setState((){
//         partId = value['partId'];
//         machineId = value['machineId'];
//         materialId = value['materialId'];
//         _SdateTime = value['plannedStartTime'];
//         _EdateTime = value['plannedEndTime'];
//         plannedQuantity = value['plannedQuantity'];
//       })
//     });
//     setState(() {
//       getDoc = true;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getDocument(id);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mHeight = MediaQuery.of(context).size.height;
//     var mwidth = MediaQuery.of(context).size.width;
//     return
//       getDoc?
//       Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: mHeight * 0.05,
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Part Id",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0,
//                               right: 20.0,
//                               top: 10.0,
//                               bottom: 5.0),
//                           child: TextFormField(
//                             initialValue: partId,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.red),
//                               ),
//                               filled: true,
//                               fillColor: primaryColor,
//                               errorStyle: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: mwidth * 0.035),
//                               hintText: 'eg. 0001',
//                               hintStyle:
//                               TextStyle(color: Colors.white54),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 // name = value;
//                                 partId = value;
//                               });
//                             },
//                             validator: (value) {
//                               if ((value == null || value.isEmpty) &&
//                                   true) {
//                                 return "Required";
//                               }
//                               return null;
//                             },
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Machine Id",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0,
//                               right: 20.0,
//                               top: 10.0,
//                               bottom: 5.0),
//                           child: TextFormField(
//                             initialValue: machineId,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.red),
//                               ),
//                               filled: true,
//                               fillColor: primaryColor,
//                               errorStyle: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: mwidth * 0.035),
//                               hintText: 'eg. 0001',
//                               hintStyle:
//                               TextStyle(color: Colors.white54),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 // name = value;
//                                 machineId = value;
//                               });
//                             },
//                             validator: (value) {
//                               if ((value == null || value.isEmpty) &&
//                                   true) {
//                                 return "Required";
//                               }
//                               return null;
//                             },
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Material Id",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0,
//                               right: 20.0,
//                               top: 10.0,
//                               bottom: 5.0),
//                           child: TextFormField(
//                             initialValue: materialId,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.red),
//                               ),
//                               filled: true,
//                               fillColor: primaryColor,
//                               errorStyle: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: mwidth * 0.035),
//                               hintText: 'eg. 0001',
//                               hintStyle:
//                               TextStyle(color: Colors.white54),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 // name = value;
//                                 materialId = value;
//                               });
//                             },
//                             validator: (value) {
//                               if ((value == null || value.isEmpty) &&
//                                   true) {
//                                 return "Required";
//                               }
//                               return null;
//                             },
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//
//
//
//
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Planned Start Time",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 20.0,
//                                   right: 20.0,
//                                   top: 10.0,
//                                   bottom: 5.0),
//                               child: Container(
//                                 width: mwidth*0.5,
//                                 decoration: BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 // height: mHeight*0.1,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(vertical:8.0),
//                                   child: Column(
//                                     children: [
//                                       Text("Date:  "+_SdateTime.day.toString()+"-"+_SdateTime.month.toString()+"-"+_SdateTime.year.toString(),
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: mwidth*0.04
//                                         ),
//                                       ),
//                                       Text("Time:  "+(_SdateTime.hour>12?(_SdateTime.hour-12):_SdateTime.hour).toString()+":"+_SdateTime.minute.toString()+" "+(_SdateTime.hour>12?"PM":"AM"),
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: mwidth*0.04
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: mwidth*0.25,
//                               height: mHeight*0.04,
//                               child: MaterialButton(
//                                   color: Colors.white,
//                                   child: Text("Change"),
//                                   onPressed:(){
//                                     showModalBottomSheet(
//                                         context: context,
//                                         builder: (BuildContext builder) {
//                                           return Container(
//                                             height: mHeight * 0.25,
//                                             child: CupertinoDatePicker(
//                                               use24hFormat: false,
//                                               onDateTimeChanged: (time) {
//                                                 setState(() {
//                                                   _SdateTime = time;
//                                                 });
//                                                 //print(_SdateTime);
//                                               },
//                                               initialDateTime: _SdateTime,
//                                             ),
//                                           );
//                                         });
//                                   }
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Planned End Time",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   left: 20.0,
//                                   right: 20.0,
//                                   top: 10.0,
//                                   bottom: 5.0),
//                               child: Container(
//                                 width: mwidth*0.5,
//                                 decoration: BoxDecoration(
//                                   color: primaryColor,
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 // height: mHeight*0.1,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(vertical:8.0),
//                                   child: Column(
//                                     children: [
//                                       Text("Date:  "+_EdateTime.day.toString()+"-"+_EdateTime.month.toString()+"-"+_EdateTime.year.toString(),
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: mwidth*0.04
//                                         ),
//                                       ),
//                                       Text("Time:  "+(_EdateTime.hour>12?(_EdateTime.hour-12):_EdateTime.hour).toString()+":"+_EdateTime.minute.toString()+" "+(_EdateTime.hour>12?"PM":"AM"),
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: mwidth*0.04
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: mwidth*0.25,
//                               height: mHeight*0.04,
//                               child: MaterialButton(
//                                   color: Colors.white,
//                                   child: Text("Change"),
//                                   onPressed:(){
//                                     showModalBottomSheet(
//                                         context: context,
//                                         builder: (BuildContext builder) {
//                                           return Container(
//                                             height: mHeight * 0.25,
//                                             child: CupertinoDatePicker(
//
//                                               use24hFormat: false,
//                                               onDateTimeChanged: (time) {
//                                                 setState(() {
//                                                   _EdateTime = time;
//                                                 });
//                                                 //print(_EdateTime);
//                                               },
//                                               initialDateTime: _EdateTime,
//                                             ),
//                                           );
//                                         });
//                                   }
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//
//
//
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Container(
//                 width: mwidth * 0.9,
//                 height: mHeight * 0.15,
//                 color: textFieldBackgroundColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mwidth * 0.05,
//                             ),
//                             Text(
//                               "Planned Quantity",
//                               style: TextStyle(
//                                   color: formLabelColor,
//                                   fontSize: mwidth * 0.04,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0,
//                               right: 20.0,
//                               top: 10.0,
//                               bottom: 5.0),
//                           child: TextFormField(
//                             initialValue: plannedQuantity,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: secondaryColor),
//                               ),
//                               errorBorder: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.red),
//                               ),
//                               filled: true,
//                               fillColor: primaryColor,
//                               errorStyle: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: mwidth * 0.035),
//                               hintText: 'eg. 1 Kg',
//                               hintStyle:
//                               TextStyle(color: Colors.white54),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 // name = value;
//                                 plannedQuantity = value;
//                               });
//                             },
//                             validator: (value) {
//                               if ((value == null || value.isEmpty) &&
//                                   true) {
//                                 return "Required";
//                               }
//                               return null;
//                             },
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//             ),
//           ),
//
//           Row(
//             children: [
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                   child: GestureDetector(
//                     onTap: () async{
//                         Navigator.pop(context);
//                     },
//                     child: Container(
//                       width: mwidth * 0.35,
//                       height: mHeight * 0.07,
//                       color: secondaryColor,
//                       child: Center(child: Text("Back",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: mwidth*0.04
//                         ),
//                       )),
//                     ),
//                   ),
//                   // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//                 ),
//               ),
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                   child: GestureDetector(
//                     onTap: () async{
//                       // var id = Uuid().v4();
//                       if (_formKey.currentState.validate()) {
//                         await FirebaseFirestore.instance
//                             .collection('batchcard')
//                             .doc(id)
//                             .update({
//                           'status':"batchcard",
//                           'partId': partId,
//                           'machineId': machineId,
//                           'materialId': materialId,
//                           'plannedStartTime': _SdateTime,
//                           'plannedEndTime': _EdateTime,
//                           'plannedQuantity': plannedQuantity,
//                           'id': id,
//                         });
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: Container(
//                       width: mwidth * 0.35,
//                       height: mHeight * 0.07,
//                       color: secondaryColor,
//                       child: Center(child: Text("Update",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: mwidth*0.04
//                         ),
//                       )),
//                     ),
//                   ),
//                   // child: textField("Part Name", "eg. GB LHD Reservior","","",true),
//                 ),
//               ),
//             ],
//           ),
//           // Add TextFormFields and ElevatedButton here.
//         ],
//       ),
//     ):
//       Platform.isAndroid?
//           Center(child: CircularProgressIndicator()):
//           Center(child: CupertinoActivityIndicator(
//             radius: 20.0,
//           ));
//     ;
//   }
// }