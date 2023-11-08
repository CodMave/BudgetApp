import 'dart:async';
import 'package:budgettrack/pages/homePage.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget{

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Use a local variable to capture the context.
    final currentContext = context;

    Timer(
      Duration(seconds: 5),
          () {
        if (mounted) {
          Navigator.pushReplacement(
            currentContext,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color:Colors.white
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top:160.0,left:20.0,right:20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "lib/images/Logo.png",
                        height: 200.0,
                        width: 200.0,
                      ),
                      Text(
                        "M BUDDY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090950),
                          fontWeight: FontWeight.bold,
                          fontFamily:'Lexend-VariableFont',
                          fontSize:40.0,
                        ),
                      ),
                      Text(
                        "The easiest way to track your spending and save money.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:Color(0xFF316F9B),
                          fontFamily:'Lexend-VariableFont',
                          fontSize:20,
                        ),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF316F9B)),
                  ),
                  SizedBox(height:220),
                  Text(
                    "Powered By MPSMACK.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:Color(0xFF5C6C84),
                      fontFamily:'Lexend-VariableFont',
                      fontSize:20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}