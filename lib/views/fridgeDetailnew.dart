import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import "package:sms/sms.dart";

import 'package:smart_container/assets/color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_container/model/fridgeContainer.dart';
//import 'package:smart_container/views/fridgeDetailnew.dart';


class FridgeInventory extends StatefulWidget {
  // FridgeInventory(val1, val2, val3, val4, val5);


  @override
  _FridgeInventoryState createState() => _FridgeInventoryState();
}

class _FridgeInventoryState extends State<FridgeInventory> {
  final databaseRef = FirebaseDatabase.instance.reference().child("app");
  List<Fridge> friCon = [];

  @override
  void initState() {
    super.initState();
    getFirebaseFridgeContainerData();
  }

  void getFirebaseFridgeContainerData() {
    databaseRef
        .child('container')
        .child('fridge')
        .onValue
        .listen((event) {
      friCon.clear();
      var snapshot = event.snapshot;
      var keys = snapshot.value.keys;
      var vals = snapshot.value;
      for (var key in keys) {
        Fridge F = new Fridge(
          vals[key]['temp'],
          vals[key]['humidity'], vals[key]['status'],
        );
        friCon.add(F);
      }

      //print(friCon[0].status);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Fridge Inventory", style: TextStyle(color: AppColor.PRIMARY_BLACK, fontFamily: "Raleway", fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.068),),
        backgroundColor: Color(0xFFF2C94C),
        toolbarOpacity: 1.0,
        centerTitle: true,
      ),

      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(4),
        child: Card(
          elevation: 10.0,
          shadowColor: AppColor.PRIMARY_GREY,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          child:
          friCon.length == 0
              ? Container(
            decoration: new BoxDecoration(
              color: AppColor.PRIMARY_WHITE,
            ),
          )

              : ListView.builder(
              itemCount: friCon.length,
              itemBuilder: (BuildContext context, int index) {
                return UI(
                    friCon[index]
                );
              }
          ),
        ),
      ),
    );
  }

  Widget UI(Fridge widget_friCon) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                    child: Text("Food type: Banana", style: TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                      child: Text(
                        "Temperature: " + friCon[0].temp.toString() + "°C",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                  SizedBox(height: 10,),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                      child: Text(
                        "Humidity: " + friCon[0].humidity.toString() + "%",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      )
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                    child: Expanded(
                      child: Container(width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.85,
                        child: Text("Freshness: " + friCon[0].status.toString(),
                          overflow: TextOverflow.ellipsis, style: TextStyle(
                              fontFamily: 'Raleway',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                          maxLines: 3,
                        ),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
class MyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text('Show alert'),
        onPressed: () {
          showAlertDialog(context);
        },
      ),
    );
  }
}


  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Fridge door is open."),
      //content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

