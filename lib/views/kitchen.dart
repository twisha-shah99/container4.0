import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_sms/flutter_sms.dart';
import "package:sms/sms.dart";

import 'package:firebase_database/firebase_database.dart';

import 'package:smart_container/model/kitchenContainer.dart';
import 'package:smart_container/assets/color.dart';
import 'package:smart_container/views/kitchenDetail.dart';

class KitchenInventory extends StatefulWidget {
  @override
  _KitchenInventoryState createState() => _KitchenInventoryState();
}

class _KitchenInventoryState extends State<KitchenInventory> {
  final databaseRef = FirebaseDatabase.instance.reference().child("app");
  List<KitchenContainer> kitCon = [];
  // List<String>

  @override
  void initState() {
    super.initState();
    getFirebaseKitchenContainerData();
  }

  void _sendSMS(String msg, String recipients, String food) async {

    SmsSender sender = new SmsSender();
    String address = recipients;

    SmsMessage message = new SmsMessage(address, msg);
    sender.sendSms(message);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
        createAlertDialog(context, 'Success', 'The order has been placed for: ' + food + ". The shopkeeper will soon contact you for suitable delivery date.");
      }
    });
  }

    void getFirebaseKitchenContainerData()  {
    // kitCon.clear();
    databaseRef
        .child('container')
        .child('kitchen')
        .onValue
        .listen((event) {
      kitCon.clear();
      var snapshot = event.snapshot;
      var keys = snapshot.value.keys;
      var vals = snapshot.value;
      for (var key in keys) {
        // use double.parse() incase data in firebase DB is string type
        KitchenContainer k = new KitchenContainer(
            vals[key]['type'], vals[key]['quantity'],
            vals[key]['refill_quantity'], vals[key]['threshold'],
            vals[key]['store'], vals[key]['store_price'],
            vals[key]['last_refill'], vals[key]['auto_order'],
          vals[key]['contact'],
        );
        kitCon.add(k);
      }
      setState(() { });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: Text("Kitchen Inventory", style: TextStyle(color: AppColor.PRIMARY_BLACK, fontFamily: "Raleway", fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.068),),
        backgroundColor: AppColor.PRIMARY_CHROME_YELLOW,
        toolbarOpacity: 1.0,
        centerTitle: true,
      ),
      body: Container(
        child:
          kitCon.length == 0
            ?  Container(
                  decoration: new BoxDecoration(
                    color: AppColor.PRIMARY_WHITE,
                  ),
                  child: Center(
                    child: SpinKitFadingCircle(
                        color: AppColor.PRIMARY_GREEN,
                        size: 150.0,
                    ),
                  ),
          )
              : ListView.builder(
                  itemCount: kitCon.length ,
                  itemBuilder:(BuildContext context, int index){
                      return UI(
                        kitCon[index]
                      );
                  }
              ),
      ),
    );
  }

  Widget UI(KitchenContainer widget_kitCon){

     String food_type = widget_kitCon.food_type;
     double quantity = widget_kitCon.quantity;
     double refill_quantity = widget_kitCon.refill_quantity;
     bool autoOrder = widget_kitCon.auto_order;

     if(widget_kitCon.quantity <=  widget_kitCon.threshold){
       if(autoOrder == true){
         String message = "Order:"+food_type+"-"+widget_kitCon.refill_quantity.toString()+"kg,deliver to Antara" ;
         // String recipents = "xxxxxxxxxx";
         _sendSMS(message, widget_kitCon.contact, widget_kitCon.food_type);
         print("Sending SMS to:"+ widget_kitCon.contact);
       }
     }

    return InkWell(
      child: Container(
          height:  MediaQuery.of(context).size.height * 0.27,
          padding: EdgeInsets.only(top:10, left:10, right:10),
              child: Card(
                elevation: 10.0,
                shadowColor: AppColor.PRIMARY_GREEN,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                color: AppColor.PRIMARY_WHITE,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                        backgroundColor: AppColor.PRIMARY_GREEN,
                        radius: MediaQuery.of(context).size.width * 0.024,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                            padding: EdgeInsets.only(top: 41.0, left: 15.0),
                            child:  Text(food_type, style: TextStyle(
                            color: Colors.black, fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.12,
                            ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 7.0, left: 15.0),
                            child: Text("Available: $quantity kg",style: TextStyle(
                            color: Colors.black, fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.058
                            ),
                            )
                            )
                        ],
                      ),
                    Spacer(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 14.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height:MediaQuery.of(context).size.height * 0.20,
                              decoration: BoxDecoration(
                                color: AppColor.PRIMARY_GREY,
                                border: Border.all(color: AppColor.PRIMARY_BLACK, width: 3),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    child:  AnimatedContainer(
                                        duration: Duration(seconds: 5),
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        height: (quantity/refill_quantity) * MediaQuery.of(context).size.height * 0.20,
                                        // color: AppColor.PRIMARY_GREEN,
                                        curve: Curves.fastOutSlowIn,
                                        decoration: BoxDecoration(
                                          // todo: change color based on quantity! :P
                                            borderRadius: BorderRadius.circular(9),
                                            color: AppColor.PRIMARY_GREEN,
                                        ),
                                    ),
                                  ),
                                ],
                              ),
                              ),
                        )
                        ],
                    ),
              ],
              ),
              ),
              ),
          ),
      onTap: () {
        Navigator.push(context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 1),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                  animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
                  return ScaleTransition(
                    alignment: Alignment.center,
                    scale: animation,
                    child: child,
                  );
                },
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                  return KitchenDetail(widget_kitCon);
                }
            )
        );
      },
    );
  }

  // todo: implement push notifications using FCM.
  createPushNotification(BuildContext context, String title, String msg) {

  }

  createAlertDialog(BuildContext context, String ttl, String msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: <Widget>[
              RaisedButton(
                color: AppColor.PRIMARY_ORANGE,
                child: Text('Ok', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.068, fontFamily: "Raleway"),),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

}
