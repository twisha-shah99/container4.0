import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:smart_container/views/community.dart';
import 'package:smart_container/views/fridgeDetailnew.dart';

import 'package:smart_container/views/kitchen.dart';


import 'package:smart_container/views/kitchen.dart';
import 'package:smart_container/assets/color.dart';



class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int _selectedIndex = 0; //by default -> Home
  List<Widget>__navBarOptions = <Widget>[
    KitchenInventory(),
    FridgeInventory(),
    posts(),
    Text("Settings")];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Container 4.0", style: TextStyle(color: AppColor.PRIMARY_BLACK, fontFamily: "Raleway", fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.0697),),
        centerTitle: true,
      ),
      body: Center(
        child: __navBarOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:Theme(
        data: Theme.of(context).copyWith(
        canvasColor: AppColor.PRIMARY_WHITE,
        primaryColor: AppColor.PRIMARY_GREEN,
        textTheme: Theme.of(context).textTheme.copyWith(
        caption: TextStyle(color: AppColor.PRIMARY_BLACK)
        )
        ),
        child:  BottomNavigationBar( type: BottomNavigationBarType.fixed, items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.battery70,),
              title: Text("Inventory",style:TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.bold,
              )),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.fridge),
              title: Text("Fridge",style:TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.bold,
              )),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text("Community",style:TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.bold,
              )),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings",style:TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.bold,
              )),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      )


    );
  }
}
