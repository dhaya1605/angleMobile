import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:uuid/uuid.dart';



class createNewPart extends StatefulWidget {
  @override
  _createNewPartState createState() => _createNewPartState();
}

class _createNewPartState extends State<createNewPart> {
  final _formKey = GlobalKey<FormState>();
  bool WIP = true, FG = false;
  List<RadioModel> sampleData = new List<RadioModel>();
  var partName,Description,Code,Weight,Customer,Price,cycleTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(RadioModel(WIP, 'hi', 'WIP'));
    sampleData.add(RadioModel(FG, 'hi', 'FG'));

  }
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: textFieldBackgroundColor,
        appBar:
        Platform.isAndroid?
        AppBar(
          title: Text("New Part"),
          backgroundColor: primaryColor,
        ):
        CupertinoNavigationBar(
          middle: Text("New Part",style: TextStyle(
              color: Colors.white
          ),),
          backgroundColor: primaryColor,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            },
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: mHeight*0.02,
                    ),
                    Text("Part Details",style: TextStyle(
                      fontSize: mwidth*0.05,
                      color: Colors.white54
                    ),),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Part Name",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                      onChanged: (value){
                                        setState(() {
                                          partName = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
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
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Description (optional)",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        hintText: 'eg. Project DB',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          Description = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&false){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Description (optional)", "eg. Project Db","","",false),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Code",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        hintText: 'eg. 79001',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          Code = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Code", "eg. 79001","","",true),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Weight",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        suffixText: 'g',
                                        suffixStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintText: 'eg. 12',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          Weight = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Weight", "eg. 12","","g",true),
                      ),
                    ),


                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Cycle Time",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        suffixText: 's',
                                        suffixStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        hintText: 'eg. 12',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          cycleTime = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Weight", "eg. 12","","g",true),
                      ),
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: mwidth*0.1,
                        ),
                        Text("Type of Inventory",
                        style: TextStyle(
                          color: formLabelColor,
                          fontSize: mwidth*0.04,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ],
                    ),
                    Container(
                      height: mHeight*0.19,
                      width: mwidth*0.8,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sampleData.length,
                          itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              sampleData.forEach((element) => element.isSelected = false);
                              sampleData[index].isSelected = true;
                              if(sampleData[index].text == "WIP"){
                                WIP = true;
                                FG = false;
                              }
                              else{
                                FG = true;
                                WIP = false;
                              }
                              print(WIP);
                            });
                          },
                          child: RadioItem(sampleData[index]),
                        );
                      }),
                    ),




                    SizedBox(
                      height: mHeight*0.05,
                    ),
                    Text("Sourcing Details",style: TextStyle(
                        fontSize: mwidth*0.05,
                        color: Colors.white54
                    ),),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right:8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Customer",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        hintText: 'eg. Mando',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          Customer = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Customer", "eg. Mando","","",true),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mwidth*0.9,
                          height: mHeight*0.15,
                          color: textFieldBackgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mwidth*0.05,
                                      ),
                                      Text("Price",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
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
                                        hintText: 'EG. 12',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                        prefixText: "\u20B9",
                                        prefixStyle: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          Price = value;
                                        });
                                      },
                                      validator: (value){
                                        if((value==null || value.isEmpty)&&true){
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                          color: Colors.white
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //child: textField("Price", "eg. 12","\u20B9","",true),
                      ),
                    ),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: mwidth*0.1,
                        ),
                        RaisedButton(onPressed:() async{
                          var id = Uuid().v4();
                          if(_formKey.currentState.validate()) {
                            await FirebaseFirestore.instance.collection('parts').doc(id).set({
                              'name':partName,
                              'description':Description,
                              'code':Code,
                              'weight':Weight,
                              'inventoryType':FG?"FG":"WIP",
                              'customer':Customer,
                              'price':Price,
                              'id': id,
                              'cycleTime':cycleTime,
                            });
                            Navigator.pop(context);
                          };
                        },
                        color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 20.0),
                            child: Text("Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mwidth*0.05,
                            ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mwidth*0.05,
                        ),
                        RaisedButton(onPressed:(){
                          Navigator.pop(context);
                        },
                          color: primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("Discard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mwidth*0.05,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: mHeight*0.1,
                    ),
                  ],
                ),
              )),
        ));
  }
}


class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}

class RadioItem extends StatelessWidget {
  final RadioModel item;
  RadioItem(this.item);
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: mwidth*0.35,
        height: mHeight*0.15,
        child: Card(
          color: item.isSelected? secondaryColor:
          primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.hardware,size: mwidth*0.1,),
              Text(item.text,style: TextStyle(
                  color: Colors.white,
                  fontSize: mwidth*0.04
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
