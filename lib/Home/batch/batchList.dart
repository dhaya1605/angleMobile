import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobcard/Home/batch/batchProcess.dart';
import 'package:jobcard/Home/batch/editBatch.dart';
import 'package:jobcard/Home/batch/initialDetail.dart';
import 'package:jobcard/Home/batch/moulding.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class batchList extends StatefulWidget {
  @override
  _batchListState createState() => _batchListState();
}

class _batchListState extends State<batchList> {
  bool batches = false;
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: textFieldBackgroundColor,
      appBar: Platform.isAndroid
          ? AppBar(
              title: Text("Batches"),
              backgroundColor: primaryColor,
            )
          : CupertinoNavigationBar(
              middle: Text(
                "Batches",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: primaryColor,
            ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
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
              batches?
              StreamBuilder(
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
                        if(status=="batchcard") {
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
                        if(status=="batchcard") {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: primaryColor,
        ),
        backgroundColor: secondaryColor,
        onPressed: ()  {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>initialDetail()));
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>createNewMaterial()));
        },
      ),
    );
  }
}


class batchCard extends StatelessWidget {
  batchCard(this.id,this.partId,this.machineId,this.batchNumber);
  var id,partId,machineId,batchNumber;
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                '$batchNumber  -  $machineId',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              trailing: Container(
                width: mwidth*0.3,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>editBatch(id)));
                        },
                        child: Icon(Icons.note,
                        color: secondaryColor,
                          size: mwidth*0.08,
                        )),
                    SizedBox(
                      width: mwidth*0.05,
                    ),

                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>moulding(id)));
                        },
                        child: Icon(Icons.check_circle,
                          color: secondaryColor,
                          size: mwidth*0.08,
                        )                    ),
                  ],
                ),
              ),
            ),
            // ButtonBar(
            //   alignment: MainAxisAlignment.start,
            //   children: [
            //     FlatButton(
            //       textColor: secondaryColor,
            //       onPressed: () {
            //         // Perform some action
            //         Navigator.push(context, MaterialPageRoute(builder: (context)=>editBatch(id)));
            //       },
            //       child: const Text('Operations'),
            //     ),
            //     FlatButton(
            //       textColor: secondaryColor,
            //       onPressed: () {
            //         // Perform some action
            //         Navigator.push(context, MaterialPageRoute(builder: (context)=>moulding(id)));
            //       },
            //       child: const Text('Complete'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
