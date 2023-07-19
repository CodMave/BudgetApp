import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  // Variables
  final String transactionName;
  final int transactionAmount;
  final String transactionType;

  MyTransaction({
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: const Offset(4.0, 4.0),
              blurRadius: 10.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.grey[300],
            height: 65,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name
                  Text(
                    transactionName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),

                  // Amount
                  Text(
                    (transactionType == "Expence" ? "- " : "+ ") +
                        "\$ $transactionAmount",
                    style: TextStyle(
                      color: transactionType == "Expence"
                          ? Colors.red
                          : Colors.green,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
