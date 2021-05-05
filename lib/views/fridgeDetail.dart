import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';
import "package:sms/sms.dart";

import 'package:smart_container/assets/color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_container/model/fridgeContainer.dart';
//import 'package:smart_container/views/fridgeDetailnew.dart';


class FridgeInventory extends StatefulWidget {
  FridgeInventory(val1, val2, val3, val4, val5);


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
          title: Text("Fridge Inventory",
            style: TextStyle(fontFamily: 'Raleway',
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),),
          backgroundColor: Color(0xFFF2C94C),
          toolbarOpacity: 1.0,
          centerTitle: true,
        ),


        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [if (friCon[0].temp <=33)
              (Padding(
             padding: EdgeInsets.only(top: 30.0, left: 15.0),
             )
              ),
              if (friCon[0].temp <=33)
                (Row(
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [SizedBox(width: 90),
                CircleAvatar(
                  backgroundColor: AppColor.PRIMARY_GREEN,
                  radius: MediaQuery.of(context).size.width * 0.034,
                ),
                Text("    Fridge door is closed :)",
                  style: TextStyle(
                    color: Colors.black, fontFamily: 'Raleway',
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
            ],
          )
                ),
              //indication for fridge door open
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [if (friCon[0].temp >=34)
              (Padding(
              padding: EdgeInsets.only(top: 30.0, left: 15.0),
    )),
               if (friCon[0].temp >=34)
              (Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [SizedBox(width: 90),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: MediaQuery.of(context).size.width * 0.034,
                  ),
                  Text("    Fridge door is open!",
                    style: TextStyle(
                      color: Colors.black, fontFamily: 'Raleway',
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                ],

    )
              ),
                SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                height: 80,
                width: 400,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(2,3),
                    ), //BoxShadow
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                  child: Text("Food item : Banana",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),),
                ),
              ),
              SizedBox(height: 2),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 6),
                height: 80,
                width: 400,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(2,3),
                    ), //BoxShadow
                    //BoxShadow
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                  child: Text("Temperature : " + friCon[0].temp.toString() + "°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),),
                ),
              ),
              SizedBox(height: 2),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 6),
                height: 80,
                width: 400,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(2,3),
                    ), //BoxShadow
                    //BoxShadow
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                  child: Text("Humidity : " + friCon[0].humidity.toString() + "%",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),),
                ),
              ),
              SizedBox(height:2),
                Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 6),
                height: 140,
                width: 400,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(2,3),
                    ), //BoxShadow
                    //BoxShadow
                  ],
                ),
                child: Column(
                children: [
                Container(
                //Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 12.0, 3.0, 12.0),
                  child: Text("Freshness",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,
                        color: Colors.black,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600),),
                ),
             // ),
                  if (friCon[0].status == 'Fresh')
                (Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:<Widget>[
                   Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.66,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    leading: new Text("Expired"),
                    trailing: new Text("Fresh"),
                    percent: 1.0,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.green,
                  ),
                ),
              ],
             )
                ),

              if (friCon[0].status == 'Expired')
                (Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.66,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20.0,
                        leading: new Text("Expired"),
                        trailing: new Text("Fresh"),
                        percent: 0.3,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.red,
                      ),
                    ),
                  ],
                )
                ),

              if (friCon[0].status == 'Consume Soon')
                (Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * 0.66,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20.0,
                        leading: new Text("Expired"),
                        trailing: new Text("Fresh"),
                        percent: 0.5,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.yellow,
                      ),
                    ),
                    Container(
                     child: Text("                                          Consume Soon!",
                     textAlign: TextAlign.center,
                     )
                   ),
                  ],
                )
                ),
                ],
                ),
                ),
               ],
                ),
    ],
        ),
    );

  }
}