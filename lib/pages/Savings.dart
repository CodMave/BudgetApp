import 'package:flutter/material.dart';

import 'homePage.dart';

class Savings extends StatefulWidget {
  int balance=0;
  Savings({Key?key, required int balance}) :super(key: key){
    this.balance=balance;
  }

  @override
  State<Savings> createState() => _SavingsState(
    savingbalance:balance,
  );
}

class _SavingsState extends State<Savings> {
  int savingbalance = 0;
  _SavingsState({required this.savingbalance});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  AppBar(
          backgroundColor: Colors.grey[100],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          title: const Text('S A V I N G S',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body:SingleChildScrollView(
          child: Column(
            children: [
                Container(
                  margin:EdgeInsets.only(top:10,left:20,right:20),
                  height:400,
                  width:400,
                  decoration: BoxDecoration(
                    color: const Color(0xff039EF0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        )
      ),
    );
  }
}
