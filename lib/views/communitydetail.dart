import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class add_posts extends StatefulWidget {
  @override
  _add_postsState createState() => _add_postsState();
}

class _add_postsState extends State<add_posts> {


  TextEditingController _descriptioncontroller,_quantitycontroller,_priceController;
  String _typeSelected='';

  final databaseRef = FirebaseDatabase.instance.reference().child("app").child("community").child("users");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptioncontroller=TextEditingController();
    _quantitycontroller=TextEditingController();
    _priceController=TextEditingController();


  }

  Widget _buildfoodType(String title){
    return InkWell(
      child:Container(
        height:40,
        width:114,
        decoration: BoxDecoration(
          color:_typeSelected==title? Color(0xFFF2C94C): Color(0xFF27AE60),
          borderRadius: BorderRadius.circular(15),
        ),
        child:Center(child:Text(title,style:TextStyle(fontSize: 14,
            fontFamily: "Raleway",
            fontWeight: FontWeight.w600,
            color:Colors.white),
        ),),),

      onTap: (){
        setState(() {
          _typeSelected=title;
        });
      },

    );

  }
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(


        title:Text('Add Post',style:TextStyle(fontFamily: "Raleway",fontWeight: FontWeight.w600)),


      ),
      body:Container(
        margin: EdgeInsets.all(15),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children:[

            SizedBox(height:5,),
            Container(
              height:40,

              child:ListView(

                scrollDirection:Axis.horizontal,
                children:[
                  _buildfoodType('Fruit'),
                  SizedBox(width:20),
                  _buildfoodType('Vegetable'),
                  SizedBox(width:20),
                  _buildfoodType('Cooked Meal'),
                  SizedBox(width:20),


                ],
              ),


            ),


            SizedBox(height: 15),
            TextFormField(
              controller:_descriptioncontroller,
              decoration:
              InputDecoration(
                hintText:'Enter Description',
                hintStyle: TextStyle(fontFamily: "Raleway",fontWeight: FontWeight.bold),
                prefixIcon:Icon(Icons.notes,size:30,),
                fillColor:Colors.white,
                filled:true,
                contentPadding:EdgeInsets.all(15),

              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller:_quantitycontroller,
              decoration:
              InputDecoration(
                hintText:'Enter Quantity',
                hintStyle: TextStyle(fontFamily: "Raleway",fontWeight: FontWeight.bold),
                prefixIcon:Icon(Icons.format_list_numbered,size:30,),
                fillColor:Colors.white,
                filled:true,
                contentPadding:EdgeInsets.all(15),

              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller:_priceController,
              decoration:
              InputDecoration(
                hintText:'Enter Price',
                hintStyle: TextStyle(fontFamily: "Raleway",fontWeight: FontWeight.bold),

                prefixIcon:Icon(Icons.money,size:30,),
                fillColor:Colors.white,
                filled:true,
                contentPadding:EdgeInsets.all(15),

              ),
            ),



            SizedBox(height:30),
            Container(

              width: double.infinity,

              padding: EdgeInsets.symmetric(horizontal: 30),



              child:ElevatedButton(style:
              ElevatedButton.styleFrom(
                primary: Color(0xC6EB5757), // background
                onPrimary: Color(0xBEEB5757),
                onSurface: Color(0xB4EB5757),
                side: BorderSide(color: Color(0xB4EB5757), width: 2),
                elevation: 15,
                minimumSize: Size(150,50),
                shadowColor: Colors.redAccent,// foreground

              ),
              child: Text('Add Post',style:TextStyle(
                fontFamily: "Raleway",fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,

              ),
              ),

                onPressed: (){
                  SavePost();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  void  SavePost(){
    String description = _descriptioncontroller.text;
    String quantity = _quantitycontroller.text;
    String price = _priceController.text;




    Map<String,String> post={
      'name':"Antara",
      'number':'+91987654678',
      'type':_typeSelected,
      'description': description,
      'quantity':quantity,
      'price':'Rs.'+price,
      'address':'Vashi',

    };
    databaseRef.push().set(post).then((value) {
      Navigator.pop(context);
      
    });

  }
}









