import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MyTransaction extends StatelessWidget {
  // Variables
  final String transactionName;
  final int transactionAmount;
  final String transactionType;
  final DateTime timestamp;
  final String currencySymbol;

  const MyTransaction({
    super.key,
    required this.transactionName,
    required this.transactionAmount,
    required this.transactionType,
    required this.timestamp,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.jm().format(timestamp);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Colors.blueGrey[100],
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blueGrey.shade100,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: Icon(
                            Icons.add_card_rounded,
                            color: transactionType == "Expence"
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Amount
                  Text(
                    transactionType == "Expence"
                        ? "-$currencySymbol$transactionAmount"
                        : "+$currencySymbol$transactionAmount",
                    style: TextStyle(
                      color: transactionType == "Expence"
                          ? Colors.red
                          : Colors.green,
                      fontSize: 25,
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
