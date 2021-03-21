import 'package:flutter/material.dart';

import 'package:smart_container/navigation.dart';
import 'package:smart_container/assets/color.dart';

void main() {
  runApp(MyApp());
}

// todo: think of some good name for the app
// todo: splash screen

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Container4.0",
      home: NavBar(),
      theme: new ThemeData(
        primaryColor: AppColor.PRIMARY_GREEN,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColor.PRIMARY_LIGHT_YELLOW,
      ),
    );
  }
}
