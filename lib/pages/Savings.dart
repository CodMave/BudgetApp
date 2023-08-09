import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';

class Savings extends StatefulWidget {
  int balance=0;
  Savings({Key?key,required int balance}) :super(key: key){
    this.balance=balance;
  }

  @override
  State<Savings> createState() => _SavingsState(
    savingbalance:balance,
  );
}

class _SavingsState extends State<Savings> {
  SharedPreferences? _prefs;
  String? selectedyear = "23";
  int savingbalance=0;
  List<int>balanceList=[];
  final items = [
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    // ADD MORE
  ];
  _SavingsState({required this.savingbalance
  }
  );
  void initState(){
    super.initState();
    loadbalance();
    Timer.periodic(Duration(minutes: 5),
        (Timer timer){
      updateBalance();
        });

  }

  void updateBalance(){

    balanceList.add(savingbalance);
    saveBalanceList();
  }
  Future<void> loadbalance() async {
    _prefs = await SharedPreferences.getInstance();
    final savedbalancelist=_prefs?.getStringList('balanceList')??[];
    setState(() {
      balanceList = savedbalancelist.map((balanceStr) => int.parse(balanceStr)).toList();
    });
  }
  Future<void> saveBalanceList() async {
    _prefs = await SharedPreferences.getInstance();
    // Convert the balanceList to a list of strings before saving
    final balanceStrList = balanceList.map((balance) => balance.toString()).toList();
    await _prefs?.setStringList('balanceList', balanceStrList);
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String>buildMenuItem(String item)=>
    DropdownMenuItem(
      value:item,
      child: Text(
        item,
        style:TextStyle(fontWeight:FontWeight.bold,fontSize:60) ,
      ),
    );
    print(this.savingbalance);
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
                  //alignment: Alignment.center,
                  margin:EdgeInsets.only(top:10,left:20,right:20),
                  height:700,
                  width:400,
                  decoration: BoxDecoration(
                    color: const  Color(0xff86D5FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin:EdgeInsets.only(top:20,left:80),

                            height:80,
                            width:100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text('20',
                              style: TextStyle(
                                fontSize:60,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                          Container(
                            margin:EdgeInsets.only(top:20,left:5),

                            height:80,
                            width:115,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:Padding(
                              padding: const EdgeInsets.only(left:15),

                              child: DropdownButton<String>(

                                value: selectedyear,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedyear = newValue!;
                                  });
                                },
                                underline: Container(),
                                //isExpanded: true, // Make the dropdown list take up the maximum available height
                                itemHeight: 70,

                                items:items.map(buildMenuItem).toList(),

                              ),
                            ),
                          ),


                        ],
                      ),
                      Container(
                        margin:EdgeInsets.only(top:20),

                        height:580,
                        width:320,
                        decoration: BoxDecoration(
                          color:Color(0xff90E0EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:ListView.builder(
                          itemCount: balanceList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Container(
                                width:100,
                                height:40,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Balance: ${balanceList[index]}',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),


                      ),
                    ],
                  ),
                ),

            ],
          ),
        )
      ),
    );
  }
}
