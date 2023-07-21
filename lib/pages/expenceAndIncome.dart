import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../components/transaction.dart';

import '../components/plusButton.dart';
import '../components/tranaction.dart';

class Expence extends StatefulWidget {
  const Expence({Key? key}) : super(key: key);

  @override
  _ExpenceState createState() => _ExpenceState();
}

class _ExpenceState extends State<Expence> {
  //variables

  List<MyTransaction> transactions = [];

  final TextEditingController transactionName = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool is_income = false;
  final formKey = GlobalKey<FormState>();

  //Fetching user selected currency from firebase

  //variable to store user selected currency
  late String userSelecterCurrency = 'USD';

  //symbol user selected currency
  late String currencySymbol = '\$';

  //two variables to fetch the latest expence and income
  MyTransaction? lastIncomeTransaction;
  MyTransaction? lastExpenseTransaction;

  //get document Ids
  Future getDocIds() async {
    await FirebaseFirestore.instance
        .collection('userDatails')
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userSelecterCurrency = snapshot.docs[0].get('currency');
        });
        currencySymbolAssign();
      }
    });
  }

  void currencySymbolAssign() {
    if (userSelecterCurrency == 'USD') {
      currencySymbol = '\$';
    } else if (userSelecterCurrency == 'EUR') {
      currencySymbol = '€';
    } else if (userSelecterCurrency == 'INR') {
      currencySymbol = '₹';
    } else if (userSelecterCurrency == 'SLR') {
      currencySymbol = 'Rs';
    } else if (userSelecterCurrency == 'GBP') {
      currencySymbol = '£';
    } else if (userSelecterCurrency == 'AUD') {
      currencySymbol = 'A\$';
    } else if (userSelecterCurrency == 'CAD') {
      currencySymbol = 'C\$';
    }
  }

  //method to get currently signed in user's uid
  Future<String> getCurrentUserId() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      return user!.uid;
    } catch (ex) {
      print('current user fetchimg failed');
      return '';
    }
  }

  //method to add new expence to the expenceID collection
  Future<void> addExpenceToFireStore(
    String userId,
    String transactionName,
    int transactionAmount,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference expenceCollection = firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID');
      ;

      await expenceCollection.add({
        'transactionName': transactionName,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });
    } catch (ex) {
      print('expence adding failed');
    }
  }

  //method to add new income to the incomeID collection
  Future<void> addIncomeToFireStore(
    String userId,
    String transactionName,
    int transactionAmount,
  ) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final CollectionReference incomeCollection = firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID');
      ;

      await incomeCollection.add({
        'transactionName': transactionName,
        'transactionAmount': transactionAmount,
        'timestamp': DateTime.now(),
      });
    } catch (ex) {
      print('income adding failed');
    }
  }

  //fettching latest exoence and income from firestore
  Future<void> fetchLatestTransactions(String userId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      //fetch the latest income
      final incomeSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('incomeID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (incomeSnapshot.docs.isNotEmpty) {
        final income = incomeSnapshot.docs[0];
        setState(() {
          lastIncomeTransaction = MyTransaction(
            transactionName: income.get('transactionName'),
            transactionAmount: income.get('transactionAmount'),
            transactionType: 'Income',
          );
        });
      }

      //fetch the latest expence
      final expenceSnapshot = await firestore
          .collection('userDetails')
          .doc(userId)
          .collection('expenceID')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (expenceSnapshot.docs.isNotEmpty) {
        final expence = expenceSnapshot.docs[0];
        setState(() {
          lastExpenseTransaction = MyTransaction(
            transactionName: expence.get('transactionName'),
            transactionAmount: expence.get('transactionAmount'),
            transactionType: 'Expence',
          );
        });
      }
    } catch (ex) {
      print('fetching latest transactions failed');
    }
  }

  @override
  void initState() {
    super.initState();
    getDocIds();

    //fetch latest transactions
    getCurrentUserId().then((userId) {
      fetchLatestTransactions(userId);
    });
  }

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
                          const Text(
                            "Expence",
                            style: TextStyle(
                              color: Colors.blueGrey,
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

                          const Text(
                            "Income",
                            style: TextStyle(
                              color: Colors.blueGrey,
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
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.grey[600],
                    child: const Text(
                      'Enter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        String transactionType =
                            is_income ? "Income" : "Expence";
                        int transactionAmount =
                            int.parse(amountController.text) ?? 0;

                        //get the user id
                        String? userId = getCurrentUserId() as String?;

                        //add transaction to the list
                        setState(() {
                          transactions.add(
                            MyTransaction(
                              transactionName: transactionName.text,
                              transactionAmount: transactionAmount,
                              transactionType: transactionType,
                            ),
                          );
                        });

                        transactionName.clear();
                        amountController.clear();
                        Navigator.of(context).pop();

                        if (is_income) {
                          addIncomeToFireStore(
                            userId!,
                            transactionName.text,
                            transactionAmount,
                          );
                        } else {
                          addExpenceToFireStore(
                            userId!,
                            transactionName.text,
                            transactionAmount,
                          );
                        }
                      }
                    },
                  ),
                ],
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
              // ignore: sort_child_properties_last
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // currency symbol
                      Text(
                        currencySymbol,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                        ),
                      ),

                      const SizedBox(width: 3),

                      // amount

                      Text(
                        "10,000", //TODO: get balance from firebase
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
                            const Icon(
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
                                      currencySymbol,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),

                                    // amount
                                    Text(
                                      "${lastIncomeTransaction?.transactionAmount ?? '0'}",
                                      style: const TextStyle(
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
                            const Icon(
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
                                      currencySymbol,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),

                                    // amount
                                    Text(
                                      "${lastExpenseTransaction?.transactionAmount ?? '0'}",
                                      style: const TextStyle(
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

          const SizedBox(height: 15),
          // Show recent transactions
          Expanded(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, Index) {
                          return MyTransaction(
                            transactionName:
                                transactions[Index].transactionName,
                            transactionAmount:
                                transactions[Index].transactionAmount,
                            transactionType:
                                transactions[Index].transactionType,
                          );
                        }),
                  ),
                ],
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
