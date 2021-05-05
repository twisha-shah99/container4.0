
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:smart_container/assets/color.dart';
import 'package:firebase_database/firebase_database.dart';
import 'communitydetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class posts extends StatefulWidget {
  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {
  Query databaseRef;

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.reference()
        .child("app")
        .child("community")
        .child("users");
  }
  @override
  Widget _buildPostItem({Map post}) {
    return Container(
      margin: EdgeInsets.all(10),
      padding:EdgeInsets.all(10),
      height: 200,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.green,
            spreadRadius: 0.1,
            blurRadius: 7,
            offset: Offset(2,3),
          ), //BoxShadow
          //BoxShadow
        ],
      ),

      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.person,
                color: Color(0xFF27AE60),
                size: 20,),
              SizedBox(width: 6),

              Text(post['name'], style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
              SizedBox(width: 160,),
              Icon(Icons.phone_iphone,
                color: Color(0xFFEB5757),
                size: 20,),
              SizedBox(width:6),
              Text(post['number'], style: TextStyle(fontSize: 15,
                  color: Color(0xFFEB5757),
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
            ],
      ),
              SizedBox(height: 10,),

              Row(children: [
              Icon(Icons.food_bank_outlined,
              color: Color(0xFF27AE60),
              size: 20,),
              Text(" Category:" ,style: TextStyle(fontSize: 15,
                color: Colors.black,
                  fontFamily: "Raleway",
                fontWeight: FontWeight.w600),),
              SizedBox(width: 6),
              Text(post['type'], style: TextStyle(fontSize: 15,
              color: Colors.black,
                  fontFamily: "Raleway",
              fontWeight: FontWeight.w600),),

    ],
    ),
            SizedBox(height: 10,),
            Row(children: [
              Icon(Icons.assignment,
                color: Color(0xFF27AE60),
                size: 20,),
              Text(" Description:" ,style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
              SizedBox(width: 6),
              Text(post['description'], style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
            ],
            ),
            SizedBox(height: 10,),
            Row(children: [
              Icon(Icons.format_list_numbered_sharp,
                color: Color(0xFF27AE60),
                size: 20,),
              Text(" Quantity:" ,style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
              SizedBox(width: 6),
              Text(post['quantity'], style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
            ],
            ),
            SizedBox(height: 10,),
            Row(children: [
              Icon(Icons.money,
                color: Color(0xFF27AE60),
                size: 20,),
              Text(" Cost:" ,style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
              SizedBox(width: 6),
              Text(post['price'], style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
            ],
            ),
            SizedBox(height: 10,),
            Row(children: [
              Icon(Icons.location_on,
                color: Color(0xFF27AE60),
                size: 20,),
              Text(" Address:" ,style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w600),),
              SizedBox(width: 6),
              Text(post['address'], style: TextStyle(fontSize: 15,
                  color: Colors.black,
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.bold),),
            ],
            ),


          ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Food Community Support",style:TextStyle(
          fontFamily: "Raleway",
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 24,

        ),),
        backgroundColor: Color(0xFFF2C94C),
        toolbarOpacity: 1.0,
        centerTitle: true,
      ),
      body:Container(
        height:double.infinity,
        padding: EdgeInsets.symmetric(vertical: 11),

        child: FirebaseAnimatedList(query:databaseRef ,itemBuilder: (BuildContext context,
            DataSnapshot snapshot,Animation<double>animation,int index){
          Map post=snapshot.value;
          return _buildPostItem(post:post);
        } ,),
      ),
      floatingActionButton:FloatingActionButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder:(_){
          return add_posts();
        }));
      },
        child:Icon(Icons.add,color:Colors.white,
        ),
      ),
    );
  }
}



