import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:lottie/lottie.dart';

import 'package:smart_container/navigation.dart';
import 'package:smart_container/assets/color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  runApp(StartApp());

}

// todo: think of some good name for the project

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => MyApp()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.PRIMARY_WHITE,
      body: Center(
        child: Container(
          color: Colors.white,
          child:     Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Container 4.0", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,fontFamily: "Raleway"),),
              Padding(
                padding:EdgeInsets.only(top:20),
                child:Lottie.network(
                  'https://assets1.lottiefiles.com/private_files/lf30_P3RxuC.json',
                  height: MediaQuery.of(context).size.height * 0.27,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NavBar(),
      ),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(

        primaryColor: Color(0xFF27AE60),
        accentColor: Color(0xFFF2C94C),
        scaffoldBackgroundColor: AppColor.PRIMARY_WHITE,
      ),
      // theme: new ThemeData(
      //   primaryColor: AppColor.PRIMARY_GREEN,
      //   brightness: Brightness.light,
      //   scaffoldBackgroundColor: AppColor.PRIMARY_LIGHT_YELLOW,
      // ),
    );
  }
}
