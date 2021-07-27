import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];


class batchProcess1 extends StatefulWidget {
  batchProcess1(this.index);
  int index;
  @override
  _batchProcess1State createState() => _batchProcess1State();
}

class _batchProcess1State extends State<batchProcess1> {
  _batchProcess1State();
  int _index = 0;
  // List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];



  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Platform.isAndroid
          ? AppBar(
        title: Text("JobCard"),
        backgroundColor: primaryColor,
      )
          : CupertinoNavigationBar(
        middle: Text(
          "JobCard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Theme(
                data: ThemeData(
                  canvasColor: textFieldBackgroundColor,
                  primaryColor: secondaryColor,
                ),
                child: Container(
                  width: mwidth,
                  height: mHeight*2,
                  color: textFieldBackgroundColor,
                  child: Stepper(
                    physics: ClampingScrollPhysics(),
                    controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue,VoidCallback onStepCancel}
                    ){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(onPressed: onStepContinue,
                          color: secondaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
                              child: Text("Continue",style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                          SizedBox(
                            width: mwidth*0.15,
                          ),
                          RaisedButton(onPressed: onStepCancel,
                            color: primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:8.0,vertical: 12.0),
                              child: Text("Cancel",style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                        ],
                      );
                    },
                    type: StepperType.horizontal,
                    currentStep: _index,
                    onStepCancel: () {
                      if (_index <= 0) {
                        return;
                      }
                      setState(() {
                        _index--;
                      });
                    },
                    onStepContinue: () {
                      setState(() {

                      if(formKeys[_index].currentState.validate()) {
                        if (_index < 4 - 1) {
                          if(_index==0){
                            _initialState("hi").upload();
                          }
                          _index = _index + 1;
                        } else {
                          _index = 0;
                        }
                      }
                      });
                    },
                    onStepTapped: (index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    steps: [
                      Step(
                        isActive: _index==0?true:false,
                        state: _index>0?StepState.complete:StepState.editing,
                        title: Text("1"),
                        content: Container(
                            alignment: Alignment.centerLeft,
                            child: initial("hi"),),
                      ),
                      Step(
                        isActive: _index==1?true:false,
                        state: _index>1?StepState.complete:StepState.editing,
                        title: Text("2"),
                        content: Form(
                          key: formKeys[1],
                          child: Column(
                            children: <Widget>[
                              // Add TextFormFields and ElevatedButton here.
                              TextFormField(
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        isActive: _index==2?true:false,
                        state: _index>2?StepState.complete:StepState.editing,
                        title: Text("3"),
                        content: Text("Content for Step 3"),
                      ),
                      Step(
                        isActive: _index==3?true:false,
                        state: _index>3?StepState.complete:StepState.editing,
                        title: Text("4"),
                        content: Text("Content for Step 4"),
                      ),
                      Step(
                        isActive: _index==4?true:false,
                        state: _index>4?StepState.complete:StepState.editing,
                        title: Text("4"),
                        content: Text("Content for Step 4"),
                      ),
                    ],
                  ),
                ),
              ),
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
  var id;
  bool _isSelected = false;
void upload(){
    print("hi");
  }
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKeys[0],
      child: Column(
        children: <Widget>[
          Text(
            "Batch Details",
            style: TextStyle(
                fontSize: mwidth * 0.05, color: Colors.white54),
          ),
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
                              "Part Id",
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
                              "Machine Id",
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
                              "Material Id",
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
                              "Status",
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
                              hintText: 'Moulding',
                              hintStyle:
                              TextStyle(color: Colors.white54),
                            ),
                            onChanged: (value) {
                              setState(() {
                                // name = value;
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
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}

