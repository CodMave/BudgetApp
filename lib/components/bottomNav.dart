import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../pages/Profile.dart';
import '../pages/Savings.dart';
import '../pages/Summery.dart';
import '../pages/expenceAndIncome.dart';
import '../pages/goals.dart';
import '../pages/homePage.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  List pages = [
    HomePage(),
    Pro(),
    Goals(),
    Profile(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: BottomNavigationBar(
            unselectedFontSize: 0,
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey,
            onTap: onTap,
            currentIndex: currentIndex,
            selectedItemColor: const Color.fromARGB(255, 31, 96, 192),
            unselectedItemColor: const Color(0xFF85B6FF),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.align_vertical_bottom_outlined),
                  label: 'Summary'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.track_changes_rounded), label: 'Goals'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.document_scanner_outlined), label: 'Scan')
            ]),
      ),
    );
  }
}
