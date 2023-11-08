import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  const PlusButton({super.key, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        //color: const Color(0xff90E0EF),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Color(0xFF85B6FF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "+",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
