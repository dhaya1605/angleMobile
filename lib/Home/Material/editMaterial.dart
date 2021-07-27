import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:uuid/uuid.dart';

class editMaterial extends StatefulWidget {
  editMaterial(this.id);
  var id;
  @override
  _editMaterialState createState() => _editMaterialState(id);
}

class _editMaterialState extends State<editMaterial> {
  _editMaterialState(this.id);
  var id;
  final _formKey = GlobalKey<FormState>();
  bool bPolymer = false, bChildPart = false, bConsumables = false, bStationaries = false, bCriticalSpares = false;
  List<RadioModel> sampleData1 = new List<RadioModel>();
  var name,typeOfMaterial,grade,color,description,vendor,price,rname;
  var mName;
  bool getDoc = false;

  getDocument(id) async{
    await FirebaseFirestore.instance.collection('materials').doc(id).get().then((value) => {
      setState((){
        name = value['name'];
        description = value['description'];
        color = value['color'];
        grade = value['grade'];
        vendor = value['vendor'];
        price = value['price'];
        typeOfMaterial = value['typeOfMaterial'];
        rname = value['rmCategory'];
        if(typeOfMaterial=='Polymer'|| typeOfMaterial=="Raw Material"){
          bPolymer = true;
        }
        else if(typeOfMaterial=='Child Part'){
          bChildPart = true;
        }
        else if(typeOfMaterial == 'Consumables'){
          bConsumables = true;
        }
        else if(typeOfMaterial == "Stationaries"){
          bStationaries = true;
        }
        else{
          bCriticalSpares = true;
        }
      })
    });

    sampleData1.add(RadioModel(bPolymer, 'hi', 'Polymer'));
    sampleData1.add(RadioModel(bChildPart, 'hi', 'Child Part'));
    sampleData1.add(RadioModel(bConsumables, 'hi', 'Consumables'));
    sampleData1.add(RadioModel(bStationaries, 'hi', 'Stationaries'));
    sampleData1.add(RadioModel(bCriticalSpares, 'hi', 'Critical Spares'));
    setState(() {
      getDoc = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocument(id);
  }
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return getDoc?
    Scaffold(
        backgroundColor: textFieldBackgroundColor,
        appBar:
        Platform.isAndroid?
        AppBar(
          title: Text("Edit Material"),
          backgroundColor: primaryColor,
        ):
        CupertinoNavigationBar(
          middle: Text("Edit Material",style: TextStyle(
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
                    Text("Material Details",style: TextStyle(
                        fontSize: mwidth*0.05,
                        color: Colors.white54
                    ),),
                    SizedBox(
                      height: mHeight*0.05,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: mwidth*0.1,
                        ),
                        Text("Type of Material",
                          style: TextStyle(
                              color: formLabelColor,
                              fontSize: mwidth*0.04,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: mHeight*0.6,
                      width: mwidth*0.9,
                      child: GridView.count(
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        // Generate 100 widgets that display their index in the List.
                        children: sampleData1.map((index) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  sampleData1.forEach(
                                          (element) => element.isSelected = false);
                                  index.isSelected = true;
                                  if (index.text == "Polymer") {
                                    bPolymer = true;
                                    bChildPart = false;
                                    bConsumables = false;
                                    bStationaries = false;
                                    bCriticalSpares = false;
                                    typeOfMaterial = "Polymer";
                                  }
                                  else if (index.text == "Child Part") {
                                    bPolymer = false;
                                    bChildPart = true;
                                    bConsumables = false;
                                    bStationaries = false;
                                    bCriticalSpares = false;
                                    typeOfMaterial = "Child Part";
                                  }
                                  else if (index.text ==
                                      "Consumables") {
                                    bPolymer = false;
                                    bChildPart = false;
                                    bConsumables = true;
                                    bStationaries = false;
                                    bCriticalSpares = false;
                                    typeOfMaterial = "Consumables";
                                  }
                                  else if (index.text ==
                                      "Stationaries") {
                                    bPolymer = false;
                                    bChildPart = false;
                                    bConsumables = false;
                                    bStationaries = true;
                                    bCriticalSpares = false;
                                    typeOfMaterial = "Stationaries";
                                  }
                                  else if (index.text=="Critical Spares") {
                                    bPolymer = false;
                                    bChildPart = false;
                                    bConsumables = false;
                                    bStationaries = false;
                                    bCriticalSpares = true;
                                    typeOfMaterial = "Critical Spares";
                                  }
                                });
                              },
                              child: RadioItem(index));
                        }).toList(),
                      ),
                    ),
                    // Container(
                    //   height: mHeight*0.19,
                    //   width: mwidth*0.8,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: sampleData1.length,
                    //       itemBuilder: (BuildContext context, int index){
                    //         return GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               sampleData1.forEach((element) => element.isSelected = false);
                    //               sampleData1[index].isSelected = true;
                    //               if(sampleData1[index].text == "Polymer"){
                    //                 bPolymer = true;
                    //                 bChildPart = false;
                    //                 bConsumables = false;
                    //                 bStationaries = false;
                    //                 bCriticalSpares = false;
                    //                 typeOfMaterial = "Polymer";
                    //               }
                    //               else if(sampleData1[index].text == "Child Part"){
                    //                 bPolymer = false;
                    //                 bChildPart = true;
                    //                 bConsumables = false;
                    //                 bStationaries = false;
                    //                 bCriticalSpares = false;
                    //                 typeOfMaterial = "Child Part";
                    //               }
                    //               else if(sampleData1[index].text == "Consumables"){
                    //                 bPolymer = false;
                    //                 bChildPart = false;
                    //                 bConsumables = true;
                    //                 bStationaries = false;
                    //                 bCriticalSpares = false;
                    //                 typeOfMaterial = "Consumables";
                    //               }
                    //               else if(sampleData1[index].text == "Stationaries"){
                    //                 bPolymer = false;
                    //                 bChildPart = false;
                    //                 bConsumables = false;
                    //                 bStationaries = true;
                    //                 bCriticalSpares = false;
                    //                 typeOfMaterial = "Stationaries";
                    //               }
                    //               else if(sampleData1[index].text=="Critical Spares"){
                    //                 bPolymer = false;
                    //                 bChildPart = false;
                    //                 bConsumables = false;
                    //                 bStationaries = false;
                    //                 bCriticalSpares = true;
                    //                 typeOfMaterial = "Critical Spares";
                    //               }
                    //             });
                    //           },
                    //           child: RadioItem(sampleData1[index]),
                    //         );
                    //       }),
                    // ),
                    SizedBox(
                      height: mHeight*0.05,
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
                                      Text("Name",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
                                      initialValue: name,
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
                                          name = value;
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
                                      Text("Raw Material",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
                                      initialValue: rname,
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
                                        hintText: 'eg. PP PolyPropylene',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          rname = value;
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
                                      Text("Grade",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
                                      initialValue: grade,
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
                                        hintText: 'eg. MI 79001',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          grade = value;
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
                                      Text("Color",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
                                      initialValue: color,
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
                                        hintText: 'eg. Natural',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          color = value;
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
                                      initialValue: description,
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
                                        hintText: 'eg. 35% long glass filled',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          description = value;
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
                                      Text("Vendor",style: TextStyle(
                                          color: formLabelColor,
                                          fontSize: mwidth*0.04,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 5.0),
                                    child: TextFormField(
                                      initialValue: vendor,
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
                                        hintText: 'eg. Reliance Industries',
                                        hintStyle: TextStyle(
                                            color: Colors.white54
                                        ),
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          vendor = value;
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
                                      initialValue: price.toString(),
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
                                          price = int.parse(value);
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
                          if(_formKey.currentState.validate()) {
                            await FirebaseFirestore.instance.collection('materials').doc(id).update({
                              'name':name,
                              'description':description,
                              'color':color,
                              'grade':grade,
                              'typeOfMaterial':typeOfMaterial,
                              'vendor':vendor,
                              'price':price,
                              'rmCategory':rname,
                              'id': id,
                            });
                            Navigator.pop(context);
                          };
                        },
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical:15.0,horizontal: 20.0),
                            child: Text("Update",
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
        )):
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
        width: mwidth*0.3,
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
                  fontSize: mwidth*0.03
              ),)
            ],
          ),
        ),
      ),
    );
  }
}