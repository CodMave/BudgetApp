import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Expence extends StatefulWidget {
  const Expence({Key? key}) : super(key: key);

  @override
  _ExpenceState createState() => _ExpenceState();
}

class _ExpenceState extends State<Expence> {
  //variables

  late final String userCurrency;
  late final int expence;
  late final int income;
  late final int balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor:
            Colors.grey[100], // Set the background color of the App Bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // Set the color of the back arrow
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        centerTitle: true, // Center the title
        elevation: 0.0, // Removes the shadow
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Show balance

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              //color: Colors.grey[100],
              height: 190,
              child: Expanded(
                child: Column(
                  children: [
                    // Balance text

                    const SizedBox(height: 20),

                    Text(
                      "B A L A N C E",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Balance amount

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // currency symbol
                        Text(
                          "\$",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                          ),
                        ),

                        SizedBox(width: 3),

                        // amount

                        Text(
                          "10,000",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Show expence and income

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //income

                          Row(
                            children: [
                              // up icon
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                                size: 28,
                              ),

                              const SizedBox(width: 5),

                              // income
                              Column(
                                children: [
                                  //income text
                                  Text(
                                    "Income",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    ),
                                  ),

                                  //income amount
                                  Row(
                                    children: [
                                      //currency symbol
                                      Text(
                                        "\$",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),

                                      // amount
                                      Text(
                                        "200",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          //expence

                          Row(
                            children: [
                              // down icon
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: 28,
                              ),

                              // expence
                              Column(
                                children: [
                                  //expence text
                                  Text(
                                    "Expence",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 18,
                                    ),
                                  ),

                                  //expence amount
                                  Row(
                                    children: [
                                      //currency symbol
                                      Text(
                                        "\$",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),

                                      // amount
                                      Text(
                                        "200",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff90E0EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.7),
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                ],
              ),
            ),
          ),

          // Show recent transactions

          Expanded(
            child: Container(
              color: Colors.grey[100],
            ),
          ),

          // Button to add new transaction
        ],
      ),
    );
  }
}
