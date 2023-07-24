import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: const Text(
          'G O A L S',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }
}
