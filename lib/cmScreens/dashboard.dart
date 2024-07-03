import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

// class dashboard extends StatefulWidget {
//   const dashboard({super.key});

//   @override
//   State<dashboard> createState() => _dashboardState();
// }

// class _dashboardState extends State<dashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   borderRadius: BorderRadius.circular(16.0)),
//               child: Text(
//                 "1 ม.ค. 2567",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
//               child: Text(
//                 "รายการรถเข้าซ่อม",
//                 style: TextStyle(fontSize: 14),
//               ),
//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }

class dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              '1 ม.ค. 2567',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
          child: Text(
            'รายการรถเข้าซ่อม',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children:
                List.generate(10, (index) => buildListItem(index)).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'ทะเบียนรถ\n1กด6444',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'ความเสียหาย: หนัก',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
