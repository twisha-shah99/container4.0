import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
<<<<<<< HEAD
import 'package:smart_container/views/community.dart';

import 'package:smart_container/views/kitchen.dart';
=======

import 'package:smart_container/views/kitchen.dart';
import 'package:smart_container/assets/color.dart';
>>>>>>> bf9b4c9b341d048e1c1bcbaa0c06115192e5f064


class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int _selectedIndex = 0; //by default -> Home
  List<Widget>__navBarOptions = <Widget>[
    KitchenInventory(),
    Text("Fridge Containers"),
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
        title: Text("Container 4.0"),
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
              title: Text("Inventory",),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.fridge),
              title: Text("Fridge"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text("Community"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      )


    );
  }
}
