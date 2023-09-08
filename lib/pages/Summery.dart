import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
import '../components/bottomNav.dart';
import 'homePage.dart';

class Pro extends StatefulWidget {
  int balance=0;
  Pro({
    required int balance
}){
    this.balance=balance;
  }

  @override
  _ProState createState() => _ProState(
      savingbalance:balance,
  );
}

class _ProState extends State<Pro> {
  int savingbalance=0;
  _ProState({required this.savingbalance});
  bool showContainer1 = false;
  bool showContainer2 = false;
  bool showContainer3 = false;

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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'S U M M E R Y',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        //bottomNavigationBar:
        //bottomNavigationBar: BottomNavigation(),

        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showContainer(1),
                        style: ElevatedButton.styleFrom(
                          primary: showContainer1 ? Colors.green : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Daily'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _showContainer(2),
                        style: ElevatedButton.styleFrom(
                          primary:showContainer2 ? Colors.green : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Weekly'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _showContainer(3),
                        style: ElevatedButton.styleFrom(
                          primary: showContainer3 ? Colors.green : Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Yearly'),
                      )

                    ],
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
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    width: 200,
                    height: 200,
                    color: Colors.red,
                    child: Text('Container 3'),
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
