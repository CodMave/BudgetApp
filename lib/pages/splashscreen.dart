import 'dart:async';
import 'package:budgettrack/pages/homePage.dart';
import 'package:flutter/material.dart';

import '../components/bottomNav.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigation())));
=======

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
>>>>>>> edba0451ccf784baa02a58e68f13be75e7083be9
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
<<<<<<< HEAD
                colors: [
                  Color(0xFFFF800B),
                  Color(0xFFCE1010),
                ]),
=======

                colors: [Color(0xFFFF800B),Color(0xFFCE1010),]
            ),
>>>>>>> edba0451ccf784baa02a58e68f13be75e7083be9
          ),
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
<<<<<<< HEAD
                  Text(
                    "\n \n \n Hello!!!\n Take control of your finances\n like never before with our powerful budget\ntracking app.Whether you're a seasoned\npro or just stating uour financial journey.\nBudget tracker is here to simplify your money \n management and help you achieve your\nfinancial goals",
                    textAlign: TextAlign.center,
=======
                  Text("\n \n \n Hello!!!\n Take control of your finances\n like never before with our powerful budget\ntracking app.Whether you're a seasoned\npro or just stating uour financial journey.\nBudget tracker is here to simplify your money \n management and help you achieve your\nfinancial goals",textAlign:TextAlign.center,
>>>>>>> edba0451ccf784baa02a58e68f13be75e7083be9
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
<<<<<<< HEAD
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
=======

              CircularProgressIndicator(
                valueColor:  AlwaysStoppedAnimation<Color>(Colors.red),
>>>>>>> edba0451ccf784baa02a58e68f13be75e7083be9
              ),
            ],
          ),
        ),
      ),
    );
  }
}
