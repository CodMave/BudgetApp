// import 'package:flutter/material.dart';
//
// class MessageWidget extends StatelessWidget {
//   final String message;
//   final String date;
//   final String time;
//   final Color color;
//
//   const MessageWidget({
//     Key? key,
//     required this.message,
//     required this.date,
//     required this.time,
//     required this.color,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 3,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               margin: EdgeInsets.all(10),
//               child: Center(
//                 child: Icon(
//                   Icons.mark_email_read_sharp,
//                   color: const Color(0xFF3AC6D5),
//                   size: 24,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: RichText(
//                       text: TextSpan(
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: const Color(0xFF03045E),
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: 'You have to pay your monthly ',
//                           ),
//                           TextSpan(
//                             text: 'Water bill ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           TextSpan(
//                             text: 'Rs.1500.00 ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           TextSpan(
//                             text: 'on or before ',
//                           ),
//                           TextSpan(
//                             text: '23rd of September',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         date,
//                         style: TextStyle(
//                           color: const Color(0xFF5C6C84),
//                         ),
//                       ),
//                       Text('  '), // Add spacing
//                       Text(
//                         time,
//                         style: TextStyle(
//                           color: const Color(0xFF5C6C84),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   List<MessageWidget> messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Add the other notification bars
//     messages.add(
//       MessageWidget(
//         message: 'You have to pay your monthly Water bill Rs.1500.00 on or before 23rd of September',
//         date: '11 Sep 2023',
//         time: '8.00 A.M',
//         color: const Color(0xFFF5F5F5),
//       ),
//     );
//     messages.add(
//       MessageWidget(
//         message: 'You have to pay your monthly Telephone bill Rs.4200.00 on or before 23rd of September',
//         date: '11 Sep 2023',
//         time: '8.00 A.M',
//         color: const Color(0xFFF5F5F5),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title:const Text('NOTIFICATION',
//         style: TextStyle(color: const Color(0xFF090950),
//         fontSize: 20),
//         ),
//         centerTitle: true,
//       ),
//
//       body: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 'New',
//                 style: TextStyle(
//                   color: const Color(0xFF090950),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return messages[index];
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }
