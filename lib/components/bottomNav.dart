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

  List<Widget> pages = [
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Color.fromARGB(255, 11, 126, 221),
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[500]!,
                color: Colors.blue,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.align_vertical_bottom_outlined,
                    text: 'Summary',
                  ),
                  GButton(
                    icon: Icons.track_changes_rounded,
                    text: 'Goals',
                  ),
                  GButton(
                    icon: Icons.document_scanner_outlined,
                    text: 'Scan',
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
