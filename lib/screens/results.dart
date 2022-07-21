import 'dart:ffi';

import 'package:body_measurement/screens/home.dart';
import 'package:flutter/material.dart';

class twk extends StatelessWidget {
  final double title;

  // const twk({Key? key}) : super(key: key);
  const twk(
      // this.posted,
      this.title);

  @override
  Widget build(BuildContext context) {
    return Text("$title");
  }
}

// class two extends StatefulWidget {
//   const two({Key? key}) : super(key: key);

//   @override
//   State<two> createState() => _twoState();
// }

// class _twoState extends State<two> {
//   @override
//   Widget build(BuildContext context) {
//     var heightx = MediaQuery.of(context).size.height;
//     var widthx = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
//               //   child: Center(
//               //     child: CircleAvatar(
//               //       backgroundImage: AssetImage("assets/images/new.png"),
//               //     ),
//               //   ),
//               // ),

//               // GestureDetector(
//               //     onTap: (() => {
//               //           Navigator.push(
//               //             context,
//               //             MaterialPageRoute(
//               //               builder: (context) => MyApp(),
//               //             ),
//               //           ),
//               //         }),
//               //     child: box("Last Updated 25-06-2022", "Web Developer")),
//               box(
//                 "Last Updated 25-06-2022",
//                 // "Python Developer"
//               ),

//               // box()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class box extends StatelessWidget {
  // const box({Key? key}) : super(key: key);
  const box(
      // this.posted,
      this.title);
  // final String posted;
  final String title;

  @override
  Widget build(BuildContext context) {
    var heightx = MediaQuery.of(context).size.height;
    var widthx = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: heightx * 0.15,
            width: widthx * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xFFD6FCF7)),
            child: Column(children: [
              // Flexible(
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "$posted",
              //       //   style: TextStyle(
              //       //       fontSize: 10.0, fontWeight: FontWeight.bold),
              //       // ),

              //       // style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              //     ),
              //   ),
              // ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$title",
                    textAlign: TextAlign.left,
                    //   style: TextStyle(
                    //       fontSize: 10.0, fontWeight: FontWeight.bold),
                    // ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
