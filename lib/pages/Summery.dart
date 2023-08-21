import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'homePage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Pro(),
    );
  }
}

class Pro extends StatefulWidget {
  @override
  _ProState createState() => _ProState();
}

class _ProState extends State<Pro> {
  bool showContainers1 = false;
  bool showContainers2 = false;
  bool showChart = false;

  void toggleContainersVisibility() {
    setState(() {
      showContainers1 = !showContainers1;
    });
  }

  void handleWeeklyButtonPressed() {
    setState(() {
      showContainers2 = !showContainers2;
      showChart = !showChart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ContainerWithDecoration(),
              SizedBox(
                height: 40,
              ),
              HorizontalButtonRow(
                onDailyPressed: toggleContainersVisibility,
                onWeeklyPressed: handleWeeklyButtonPressed,
              ),
              SizedBox(
                height: 20,
              ),
              if (showContainers1) ...[
                Container(
                  height: 80,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 134, 209, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Received: Rs. 00.00',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Paid: Rs: 1000.00',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 134, 209, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Total balance :  Rs. 1000.00',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              if (showContainers2) ...[
                Container(
                  height: 80,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 134, 209, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Received: Rs. 00.00',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Paid: Rs: 1000.00',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 400,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 134, 209, 249),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Total balance :  Rs. 1000.00',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
              //  if (showChart) chart()
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerWithDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 400,
      margin: EdgeInsets.only(
        left: 20,
        right: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xff181EAA),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          ),
          Center(
            child: Text(
              'Summary',
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalButtonRow extends StatelessWidget {
  final VoidCallback? onDailyPressed;
  final VoidCallback? onWeeklyPressed;

  const HorizontalButtonRow(
      {Key? key, this.onDailyPressed, this.onWeeklyPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onDailyPressed,
          style: ElevatedButton.styleFrom(
            primary: Color(0xff181EAA),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Daily'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: onWeeklyPressed,
          style: ElevatedButton.styleFrom(
            primary: Color(0xff181EAA),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Weekly'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Color(0xff181EAA),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Monthly'),
        ),
      ],
    );
  }
}
