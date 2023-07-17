import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  PlusButton({required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        //color: const Color(0xff90E0EF),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: const Color(0xff90E0EF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "+",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
