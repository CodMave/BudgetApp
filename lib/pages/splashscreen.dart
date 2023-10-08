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
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF3AC6D5),Color(0xFF85B6FF)],
          ),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "lib/images/monkey.png",
                        height: 200.0,
                        width: 200.0,
                      ),
                      Text(
                        "\n \n \n Hello!!!\n Take control of your finances\n like never before with our powerful budget\ntracking app.Whether you're a seasoned\npro or just starting your financial journey.\nBudget tracker is here to simplify your money \n management and help you achieve your\nfinancial goals",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF090950),
                          fontWeight: FontWeight.bold,
                          fontFamily:'Lexend-VariableFont',
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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