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
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
                  : widget.hintText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
