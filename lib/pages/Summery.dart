import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'homePage.dart';

class Pro extends StatefulWidget {
  @override
  _ProState createState() => _ProState();
}

class _ProState extends State<Pro> {
  bool showContainer1 = false;
  bool showContainer2 = false;
  bool showContainer3 = false;
  bool showTitle = false;

  Color dailyButtonColor = const Color.fromARGB(255, 24, 30, 170);

  void _showContainer(int containerNumber) {
    setState(() {
      showContainer1 = containerNumber == 1;
      showContainer2 = containerNumber == 2;
      showContainer3 = containerNumber == 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 25, right: 40),
                        child: IconButton(
                          icon: Icon(
                            weight: 10,
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF3AC6D5),
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
                      ),
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30, left: 80),
                              child: Text(
                                'S U M M A R Y',
                                style: TextStyle(
                                  color: const Color(0xFF090950),
                                  fontSize: 20,
                                  fontFamily: 'Lexend-VariableFont',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 90,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 25), // Add spacing between text and icon
                              child: Icon(
                                Icons.align_vertical_bottom_outlined,
                                size: 20,
                                color: Color(0xFF3AC6D5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showContainer(1),
                        style: ElevatedButton.styleFrom(
                          primary: showContainer1
                              ? Color.fromARGB(255, 113, 204, 250)
                              : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Weekly',
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _showContainer(2),
                        style: ElevatedButton.styleFrom(
                          primary: showContainer2
                              ? Color.fromARGB(255, 113, 204, 250)
                              : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Monthly'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _showContainer(3),
                        style: ElevatedButton.styleFrom(
                          primary: showContainer3
                              ? Color.fromARGB(255, 113, 204, 250)
                              : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('Yearly'),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'SEP 11,2023 - SEP 17,2023',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                Visibility(
                  visible: showContainer1,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 400,
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                        margin: EdgeInsets.only(left: 20, right: 20),
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
                  ),
                ),
                Visibility(
                  visible: showContainer2,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 400,
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                  ),
                ),
                Visibility(
                  visible: showContainer3,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 400,
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                  ),
                ),
                Visibility(
                  visible:
                      showContainer1, // Show the chart when Weekly is seleced
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 400,
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      reservedSize: 44, showTitles: true)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      reservedSize: 30, showTitles: true)),
                            ),
                            borderData: FlBorderData(show: true),
                            gridData: FlGridData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 1,
                                barRods: [BarChartRodData(toY: 15)],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [BarChartRodData(toY: 35)],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [BarChartRodData(toY: 17)],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [BarChartRodData(toY: 23)],
                              ),
                              BarChartGroupData(
                                x: 5,
                                barRods: [BarChartRodData(toY: 98)],
                              ),
                              BarChartGroupData(
                                x: 6,
                                barRods: [BarChartRodData(toY: 10)],
                              ),
                              BarChartGroupData(
                                x: 7,
                                barRods: [BarChartRodData(toY: 30)],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Food            Rs. 1 500.00          15%',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Travel           Rs. 3 200.00          35%',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      Container(
                        child: Text(
                          ' Health           Rs. 1 750.00         17%',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      Container(
                        child: Text(
                          ' Fuel              Rs. 2 500.00            23%',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
