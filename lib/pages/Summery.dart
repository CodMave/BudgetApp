import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'Profile.dart';
import 'Savings.dart';
import 'expenceAndIncome.dart';
import 'goals.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 3,
            ),
            child: GNav(
              backgroundColor: Colors.grey.shade300,
              //color: const Color(0xFF85B6FF),
              //activeColor: const Color.fromARGB(255, 31, 96, 192),
              tabBackgroundColor: Colors.grey.shade400,
              gap: 8,
              onTabChange: (Index) {
                //if the user click on the bottom navigation bar then it will move to the following pages
                if (Index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>HomePage()),
                  );
                } else if (Index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Expence(

                              nume: 0,
                             )),
                  );
                } else if (Index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pro(balance: savingbalance,)),
                  );
                } else if (Index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Savings(
                              balance:savingbalance,
                            )),
                  );
                } else if (Index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Goals()),
                  );
                } else if (Index == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }
              },
              padding: const EdgeInsets.all(15),
              tabs: [
                GButton(
                    icon: Icons.home,
                    iconActiveColor: Index == 0
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Colors.grey
                    //text: 'Home',
                    ),
                GButton(
                    icon: Icons.add_circle_outline_sharp,
                    iconColor: Index == 1
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Color(0xFF85B6FF)
                    //text: 'New',
                    ),
                GButton(
                    icon: Icons.align_vertical_bottom_outlined,
                    iconColor: Index == 2
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Color(0xFF85B6FF)
                    //text: 'Summary',
                    ),
                GButton(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Index == 3
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Color(0xFF85B6FF)
                    //text: 'Savings',
                    ),
                GButton(
                    icon: Icons.track_changes_rounded,
                    iconColor: Index == 4
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Color(0xFF85B6FF)
                    //text: 'Plans',
                    ),
                GButton(
                    icon: Icons.document_scanner_outlined,
                    iconColor: Index == 5
                        ? Color.fromARGB(255, 31, 96, 192)
                        : Color(0xFF85B6FF)
                    //text: 'Scan',
                    ),
              ],
            ),
          ),
        ),
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
                        onPressed: () => _showContainer(2),
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
                        onPressed: () => _showContainer(3),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff181EAA),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Yearly'),
                      ),
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
