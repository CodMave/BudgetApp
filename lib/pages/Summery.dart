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

  DateTime currentDate = DateTime.now();
  void initState() {
    super.initState();
    decrementWeek();
  }

  void decrementWeek() async {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 7));
    });
    print(currentDate);
  }

  void counting() {
    if (count == 7) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Icon(
            Icons.align_vertical_bottom_outlined,
            size: 30,
            color: Color(0xFF3AC6D5),
          ),
        ],
        title: const Text('S U M M E R Y',
            style: TextStyle(
              color: const Color(0xFF090950),
              fontSize: 20,
              fontFamily: 'Lexend-VariableFont',
            )),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                      onPressed: () {
                        _showContainer(1);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Weekly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _showContainer(2);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _showContainer(3);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.grey,
                        onSurface: Color.fromARGB(255, 113, 120, 222),
                      ),
                      child: Text(
                        'Yearly',
                        style: TextStyle(
                          fontFamily: 'Lexend-VariableFont',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showContainer1,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.add_card_rounded,
                                  color: const Color(0xFF090950)),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rs. 35 000.00',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: 400,
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 238, 238, 238),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.add_card_rounded,
                                  color: const Color(0xFF3AC6D5)),
                              Text(
                                'Expense',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rs. 33 500.00',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF090950),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      // Add a Divider here
                      height: 3, // You can adjust the height of the divider
                      thickness:
                          1, // You can adjust the thickness of the divider
                      color:
                          Colors.grey, // You can set the color of the divider
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 30),
                        child: Text('Over View',
                            style: TextStyle(
                              fontFamily: 'Lexend-VariableFont',
                              fontSize: 15,
                              color: const Color(0xFF090950),
                            )),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 200,
                          width: 400,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: BarChart(
                            BarChartData(
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(show: false),
                              barGroups: [
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 35,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 15,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 35,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 0,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 17,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 80,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 23,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 50,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 98,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 100,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 10,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 70,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 7,
                                  barRods: [
                                    BarChartRodData(
                                        toY: 30,
                                        width: 15,
                                        color: const Color(0xFF090950),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                    BarChartRodData(
                                        toY: 88,
                                        width: 15,
                                        color:
                                            Color.fromARGB(255, 134, 209, 249),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF090950),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Savings',
                                    style: const TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 0),
                                  width:
                                      10, // Adjust the width and height as needed
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 134, 209, 249),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      left: 5), // Adjust top padding here
                                  child: Text(
                                    'Expenses',
                                    style: TextStyle(
                                      fontFamily: 'Lexend-VariableFont',
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 150,
                          width: 400,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Food',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF090950),
                                      ),
                                    ),
                                    Text(
                                      'Rs. 1 500.00',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(236, 97, 183, 226),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 183, 203, 250),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '15%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFC0095F2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                // Add a Divider here
                                height:
                                    3, // You can adjust the height of the divider
                                thickness:
                                    1, // You can adjust the thickness of the divider
                                color: Colors
                                    .grey, // You can set the color of the divider
                              ),
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Travel',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF090950),
                                      ),
                                    ),
                                    Text(
                                      'Rs. 3 200.00',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(236, 97, 183, 226),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 183, 203, 250),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '35%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFC0095F2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                // Add a Divider here
                                height:
                                    3, // You can adjust the height of the divider
                                thickness:
                                    1, // You can adjust the thickness of the divider
                                color: Colors
                                    .grey, // You can set the color of the divider
                              ),
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Health',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF090950),
                                      ),
                                    ),
                                    Text(
                                      'Rs. 1 750.00',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(236, 97, 183, 226),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 183, 203, 250),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '17%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFC0095F2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                // Add a Divider here
                                height:
                                    3, // You can adjust the height of the divider
                                thickness:
                                    1, // You can adjust the thickness of the divider
                                color: Colors
                                    .grey, // You can set the color of the divider
                              ),
                              Container(
                                height: 35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Fuel',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF090950),
                                      ),
                                    ),
                                    Text(
                                      'Rs. 2 500.00',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(236, 97, 183, 226),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 183, 203, 250),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '23%',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFC0095F2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}
