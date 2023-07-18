import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/plusButton.dart';
import '../components/tranaction.dart';

class Expence extends StatefulWidget {
  const Expence({Key? key}) : super(key: key);

  @override
  _ExpenceState createState() => _ExpenceState();
}

class _ExpenceState extends State<Expence> {
  //variables

  final TextEditingController transactionName = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool is_income = false;
  final formKey = GlobalKey<FormState>();

  //new transaction dialog box
  void newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text("N E W   T R A N S A C T I O N"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Expensce",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                            ),
                          ),

                          //toggle button

                          Switch(
                            value: is_income,
                            onChanged: (newValue) {
                              setState(() {
                                is_income = newValue;
                              });
                            },
                          ),

                          Text(
                            "Income",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter the Amount",
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please enter the amount";
                                  }
                                  return null;
                                },
                                controller: amountController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter the Transaction Name",
                              ),
                              controller: transactionName,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[],
              );
            },
          );
        });
  }

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
                                    color: Colors.grey[600],
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
                                    color: Colors.grey[600],
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff90E0EF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    offset: const Offset(4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 0.25,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
          // Show recent transactions
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      MyTransaction(
                        transactionName: "Name",
                        transactionAmount:
                            int.tryParse(amountController.text) ?? 0,
                        transactionType: "expence",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Button to add new transaction

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: PlusButton(
                function: newTransaction,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
