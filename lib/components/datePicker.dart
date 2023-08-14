import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePick extends StatefulWidget {
  final String hintText;
  final DateTime? selectedDate;

  const DatePick({
    super.key,
    required this.hintText,
    this.selectedDate,
  });

  @override
  State<DatePick> createState() => _DatePickState();
}

class _DatePickState extends State<DatePick> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SizedBox(height: 10),
          Text(
            widget.selectedDate != null
                ? DateFormat.MMMd().format(widget.selectedDate!).toUpperCase()
                : "",
            style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Icon(
            Icons.calendar_today,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
