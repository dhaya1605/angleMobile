import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobcard/Home/Part/newPart.dart';
import 'dart:io' show Platform;
import 'package:jobcard/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editPart.dart';



class partsList extends StatefulWidget {
  @override
  _partsListState createState() => _partsListState();
}

class _partsListState extends State<partsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        Platform.isAndroid?
        AppBar(
          title: Text("Parts"),
          backgroundColor: primaryColor,
        ):
        CupertinoNavigationBar(
          middle: Text("Parts",style: TextStyle(
              color: Colors.white
          ),),
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            // color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('parts').snapshots(),
                    builder: (context,snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {

                        //listItem = snapshot.data.documents;
                        List<Widget> partsWidgets = [];
                        final parts = snapshot.data.docs.reversed;
                        for(var part in parts){
                          // print(Class.data()['money']);
                          String name = part.data()['name'];
                          String code = part.data()['code'];
                          String id = part.data()['id'];

                          //gettingImage(classroom_id);

                          final classCardWidget = listCard(name,code,id);
                          partsWidgets.add(classCardWidget);

                        }
                        return Column(
                          children: partsWidgets,
                        );
                      }
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: primaryColor,),
        backgroundColor: secondaryColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>createNewPart()));
        },
      ),
      backgroundColor: textFieldBackgroundColor,
    );
  }
}



class listCard extends StatelessWidget {
  listCard(this.name,this.code,this.id);
  var name,code,id;

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Platform.isAndroid?
          AlertDialog(
          backgroundColor: primaryColor,
          title: Text('Are you sure?',style: TextStyle(
            color: Colors.white,
          ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this part?',style: TextStyle(
                  color: Colors.white,
                ),)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',style: TextStyle(
                color: secondaryColor,
              ),),
              onPressed: () {
                deleteDoc();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel',style: TextStyle(
                color: secondaryColor,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ):
        CupertinoAlertDialog(
          // backgroundColor: primaryColor,
          title: Text('Are you sure?',style: TextStyle(
            color: primaryColor,
          ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to delete this part?',style: TextStyle(
                  color: primaryColor,
                ),)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes',style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              onPressed: () {
                deleteDoc();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel',style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
        ;
      },
    );
  }

  deleteDoc() async{
    await FirebaseFirestore.instance.collection('parts').doc(id).delete();
  }
  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>editPart(id)));
        },
        child: Container(
          height: mHeight*0.08,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor
          ),
          child: ListTile(
            title: Text('$name',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text('$code',style: TextStyle(
              color: formLabelColor,
            ),),
            trailing: Platform.isAndroid?
            GestureDetector(
                onTap: (){
                  // deleteDoc();
                  _showMyDialog(context);
                },
                child: Icon(Icons.close,color: secondaryColor,)):
            GestureDetector(
                onTap: (){
                  // deleteDoc();
                  _showMyDialog(context);
                },
                child: Icon(CupertinoIcons.clear_circled,color: secondaryColor,)),
          ),
        ),
      ),
    );
  }
}
