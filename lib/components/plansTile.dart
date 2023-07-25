import 'package:flutter/material.dart';

class PlanTile extends StatelessWidget {
  //const PlanTile({super.key, required this.firstText, required this.secondText});

  final String firstText;
  final String secondText;
  final String date;

  PlanTile({
    required this.firstText,
    required this.secondText,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 170,
      decoration: BoxDecoration(
        color: const Color(0xff90E0EF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            offset: const Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Text(
                firstText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                secondText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
