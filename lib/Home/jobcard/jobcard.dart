import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobcard/Home/jobcard/JobCardDetail.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SingingCharacter { lafayette, jefferson }

class jobCard extends StatefulWidget {
  @override
  _jobCardState createState() => _jobCardState();
}

class _jobCardState extends State<jobCard> {
  SingingCharacter _character = SingingCharacter.lafayette;
  bool completed = true;
  bool batches = false;
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          // color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  batches?Theme(
                    data: ThemeData.dark(),
                    child: RaisedButton(onPressed: (){
                      setState(() {
                        batches = true;
                      });
                    },
                      child: Text("Batch Number",style: TextStyle(color: Colors.black),),
                      color:secondaryColor,
                    ),
                  ):
                  Theme(
                    data: ThemeData.dark(),
                    child: OutlineButton(onPressed: (){
                      setState(() {
                        batches = true;
                      });
                    },
                      child: Text("Batch Number",style: TextStyle(color: Colors.white),),
                      borderSide: BorderSide(
                          color: Colors.white, style: BorderStyle.solid,
                          width: 1),
                    ),
                  ),
                  batches?Theme(
                    data: ThemeData.dark(),
                    child: OutlineButton(onPressed: (){
                      setState(() {
                        batches = false;
                      });
                    },
                      child: Text("Latest Added",style: TextStyle(color: Colors.white),),
                      borderSide: BorderSide(
                          color: Colors.white, style: BorderStyle.solid,
                          width: 1),
                    ),
                  ):
                  Theme(
                    data: ThemeData.dark(),
                    child: RaisedButton(onPressed: (){
                      setState(() {
                        batches = false;
                      });
                    },
                      child: Text("Latest Added",style: TextStyle(color: Colors.black),),
                      color:secondaryColor,
                    ),
                  )
                ],
              ),
              batches?StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('batchcard').orderBy('batchNumber',descending: true).snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {

                      //listItem = snapshot.data.documents;
                      List<Widget> partsWidgets = [];
                      final cards = snapshot.data.docs.reversed;
                      for(var card in cards){
                        // print(Class.data()['money']);
                        // String name = card.data()['name'];
                        // String type = card.data()['typeOfMaterial'];
                        String status = card.data()['status'];
                        String id = card.data()['id'];
                        String partId = card.data()['partId'];
                        String machineId = card.data()['machineId'];
                        String batchNumber = card.data()['batchNumber'];


                        //gettingImage(classroom_id);
                        if(status=="jobcard") {
                          final classCardWidget = batchCard(id,partId,machineId,batchNumber);
                          partsWidgets.add(classCardWidget);
                        }

                      }
                      return Column(
                        children: partsWidgets,
                      );
                    }
                  }):
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('batchcard').orderBy('createdAt',descending: false).snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {

                      //listItem = snapshot.data.documents;
                      List<Widget> partsWidgets = [];
                      final cards = snapshot.data.docs.reversed;
                      for(var card in cards){
                        // print(Class.data()['money']);
                        // String name = card.data()['name'];
                        // String type = card.data()['typeOfMaterial'];
                        String status = card.data()['status'];
                        String id = card.data()['id'];
                        String partId = card.data()['partId'];
                        String machineId = card.data()['machineId'];
                        String batchNumber = card.data()['batchNumber'];


                        //gettingImage(classroom_id);
                        if(status=="jobcard") {
                          final classCardWidget = batchCard(id,partId,machineId,batchNumber);
                          partsWidgets.add(classCardWidget);
                        }

                      }
                      return Column(
                        children: partsWidgets,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
      backgroundColor: textFieldBackgroundColor,
    );
  }
}

class batchCard extends StatelessWidget {
  batchCard(this.id,this.partId,this.machineId,this.batchNumber);
  var id,partId,machineId,batchNumber;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>jobCardDetails(id)));
        },
        child: Card(
          color: primaryColor,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '$partId',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$batchNumber   -   $machineId',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

