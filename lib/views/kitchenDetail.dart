import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lottie/lottie.dart';

import 'package:smart_container/model/kitchenContainer.dart';
import 'package:smart_container/assets/color.dart';
import 'package:smart_container/views/kitchen.dart';

class KitchenDetail extends StatefulWidget {
  @override
  final KitchenContainer kitchenCon;
  KitchenDetail(this.kitchenCon);
    _KitchenDetailState createState() => _KitchenDetailState(kitchenCon: kitchenCon);
}

class _KitchenDetailState extends State<KitchenDetail> {

  bool auto_order_bool = true;
  KitchenContainer kitchenCon;
  var _threshold = 2.0;
  List<double> store_prices_all = [120.5,118,101,104.5];
  List<String> store_list = [
  'Dmart - Dadar',
  'Dmart - Malad',
  'BigBazaar - Malad',
  'Super Market - Goregaon',
  ];
  String _selected_store;
  double _selected_store_price;
  final databaseRef = FirebaseDatabase.instance.reference().child("app").child("container").child("kitchen").child("container1");

  _KitchenDetailState({@required this.kitchenCon}) {
    this._threshold = kitchenCon.threshold;
    this._selected_store = kitchenCon.store;
    this._selected_store_price = kitchenCon.store_price;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.kitchenCon.food_type),
          backgroundColor: AppColor.PRIMARY_GREEN,
        ),
      body: Container(
                height:  MediaQuery.of(context).size.height * 0.87,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.025, left:10, right:10),
                child: Card(

                  shadowColor: AppColor.PRIMARY_GREY,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  elevation: 15.0,
                  color: AppColor.PRIMARY_WHITE,
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 17),
                          child: CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 14.0,
                            animation: true,
                            percent: (widget.kitchenCon.quantity/widget.kitchenCon.refill_quantity),
                            center: Text(
                              ((widget.kitchenCon.quantity/widget.kitchenCon.refill_quantity) * 100).toStringAsFixed(2) + "%",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Raleway',
                                  color: Colors.black),
                            ),
                            backgroundColor: Colors.grey[300],
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: AppColor.PRIMARY_GREEN,
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top:15),
                          child: Text(widget.kitchenCon.food_type, textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppColor.PRIMARY_GREEN,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width * 0.12,),)
                      ),
                      Padding(
                        padding: EdgeInsets.only(left:30, right: 30),
                        child: Divider(
                          color: AppColor.PRIMARY_BLACK,
                          thickness: 3,
                        ),
                      ),

                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top:30, left: 30),
                              child: Text("Available: ", textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.width * 0.062,
                                ),)
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:30, left: 10),
                              child: Text(widget.kitchenCon.quantity.toString() + " kg", textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.066,
                                ),)
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top:30, left: 30),
                              child: Text("Threshold (kg):", textAlign: TextAlign.center,
                                style: TextStyle(
                                color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.062,
                              ),)
                          ),
                          Padding(
                              padding: EdgeInsets.only(top:17, left: 0),
                              child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.green[400],
                                    inactiveTrackColor: Colors.green[100],
                                    trackShape: RoundedRectSliderTrackShape(),
                                    trackHeight: 12.0,
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0),
                                    thumbColor: Colors.greenAccent,
                                    overlayColor: Colors.green.withAlpha(32),
                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 15.0),
                                    tickMarkShape: RoundSliderTickMarkShape(),
                                    activeTickMarkColor: Colors.green[700],
                                    inactiveTickMarkColor: Colors.green[100],
                                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor: Colors.green[900],
                                    valueIndicatorTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                child: Slider(
                                  value: _threshold,
                                  min: 0,
                                  max: widget.kitchenCon.refill_quantity,
                                  divisions: 20,
                                  label: '$_threshold',
                                  onChanged: (value) {
                                    setState(() {
                                        _threshold = double.parse(value.toStringAsFixed(2));
                                      },
                                    );
                                  },
                                ),
                              )
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top:0, bottom: 0, right:84),
                            child: Text(
                              _threshold.toStringAsFixed(2) + " ",
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.044, fontWeight: FontWeight.w900, fontFamily: 'Raleway',),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top:15, left: 30),
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Text("Auto-Order:", textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.width * 0.062,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.05),
                                      child: CustomSwitch(
                                        activeColor: AppColor.PRIMARY_GREEN,
                                        value: auto_order_bool,
                                        onChanged: (value) {
                                          print("VALUE : $value");
                                          setState(() {
                                            auto_order_bool = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ]
                              ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:15, left: 30),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text("Store:", textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.063,
                                      ),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:14),

                                    child: DropdownButton<String>(
                                        value: _selected_store,
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                      items: store_list.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Please select a store!",
                                        style: TextStyle(
                                        color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.053,
                                      ),
                                      ),

                                      onChanged: (String value) {
                                            // print(store_list.indexOf(value));
                                            // print(value);
                                        setState(() {
                                          _selected_store = value;
                                          _selected_store_price = store_prices_all[store_list.indexOf(value)];
                                        });
                                      },
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:19, left: 30),
                            child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: Text("Price:   ₹", textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.062,
                                      ),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:1),
                                    child: Text(_selected_store_price.toString() + "/kg", textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColor.PRIMARY_BLACK, fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width * 0.066,
                                      ),),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top:5, left: 30),
                            child: ButtonTheme(
                              buttonColor: Colors.red,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(26.0),
                              ),
                              child: ButtonBar(
                                buttonPadding: EdgeInsets.only(left:23, right: 23, top: 13, bottom: 13),
                                alignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right:30),
                                    child: RaisedButton(
                                      color: AppColor.PRIMARY_ORANGE,
                                      child: Text('SAVE', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.068),),
                                      onPressed: () {

                                        //todo: push data to firebase and update!
                                        databaseRef.update({"auto_order":auto_order_bool, "store":_selected_store, "price":_selected_store_price, "threshold" : _threshold});

                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              Timer(Duration(seconds: 4),
                                                      ()=>Navigator.pop(context),
                                              );
                                              return FractionallySizedBox(
                                                alignment: Alignment.center,
                                                widthFactor: 0.6,
                                                heightFactor: 0.5,
                                                child: Container(
                                                  color: AppColor.PRIMARY_WHITE,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.all(16.0),
                                                        child:Text("Updated Successfully!", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.064, fontStyle: FontStyle.italic, color: AppColor.PRIMARY_GREEN),),
                                                      ),
                                                      Padding(
                                                        padding:EdgeInsets.only(top:20),
                                                        child:Lottie.network(
                                                          'https://assets8.lottiefiles.com/packages/lf20_jjmkyjsk.json',
                                                          repeat: true,
                                                          animate: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
