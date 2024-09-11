import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project2_fi/cmScreens/stcomfi.dart';

class MyStatus extends StatefulWidget {
  final int quotationId;
  final String licenseplate;
  final String brand;
  final String model;
  final String year;

  const MyStatus({
    super.key,
    required this.quotationId,
    required this.licenseplate,
    required this.brand,
    required this.model,
    required this.year,
  });
  @override
  State<MyStatus> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyStatus> {
  List<dynamic> repairSteps = [];

  @override
  void initState() {
    super.initState();
    _fetchRepairSteps();
  }

  Future<void> _fetchRepairSteps() async {
    final url =
        'https://bodyworkandpaint.pantook.com/api/repair-processQID?Quotation_ID=${widget.quotationId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        repairSteps = data['data'];
      });
    } else {
      // Handle error
      print('Failed to load repair steps');
    }
  }

  Widget _buildVehicleInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ทะเบียนรถ",
                      style: TextStyle(fontSize: 16, fontFamily: 'Maitree'),
                    ),
                    Text(
                      widget.licenseplate,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.brand,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.model,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.year,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Text("Toyota Corolla 2018",
              //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('กำหนดเสร็จสิ้น: 15 ม.ค. 2567'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: GFIconButton(
          color: Colors.blue,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'สถานะการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildVehicleInfo(),
            const SizedBox(height: 4),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "ขั้นตอน",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(6.0),
                itemCount: repairSteps.length,
                itemBuilder: (context, index) {
                  return _step(repairSteps[index], context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _step(dynamic process, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            Text(
              '${process['StepName']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              textAlign: TextAlign.center,
              'สถานะ\n${process['Status']}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: process['Status'] == 'verification'
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => commain(
                              processId: process['Process_ID'],
                              stepname: process['StepName'],
                            ),
                          ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: process['Status'] == 'Completed'
                    ? Colors.green
                    : process['Status'] == 'verification'
                        ? Colors.yellow[700]
                        : Colors.grey,
                foregroundColor: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                process['Status'] == 'Completed'
                    ? 'เสร็จสิ้น'
                    : process['Status'] == 'verification'
                        ? 'ตรวจสอบ'
                        : 'รอตรวจสอบ',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
 

// Widget _step(BuildContext context, bool isConfirmed,
//     Function(bool) updateConfirmationStatus) {
//   return Expanded(
//     child: ListView.builder(
//       itemCount: 4,
//       itemBuilder: (context, index) {
//         switch (index) {
//           case 0:
//             return Container(
//               margin: EdgeInsets.only(bottom: 16),
//               child: _container1(),
//             );
//           case 1:
//             return Container(
//               margin: EdgeInsets.only(bottom: 16),
//               child:
//                   _container2(context, isConfirmed, updateConfirmationStatus),
//             );
//           case 2:
//             return Container(
//               margin: EdgeInsets.only(bottom: 16),
//               child: _container3(),
//             );
//           case 3:
//             return Container(
//               margin: EdgeInsets.only(bottom: 16),
//               child: _container4(),
//             );
//           default:
//             return Container();
//         }
//       },
//     ),
//   );
// }

// Widget _container1() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         // SizedBox(
//         //   width: 1,
//         // ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '1.ถอด',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'สถานะ: เสร็จสิ้น',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 textStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('ยืนยัน'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _container2(BuildContext context, bool isConfirmed,
//     Function(bool) updateConfirmationStatus) {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '2.โป๊ว',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'สถานะ: เสร็จสิ้น',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 if (!isConfirmed) {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => commain(
//                           onConfirm: updateConfirmationStatus,
//                         ),
//                       ));
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isConfirmed ? Colors.teal : Colors.yellow[400],
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 textStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(isConfirmed ? 'ยืนยัน' : 'ตรวจสอบ'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _container3() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '3.พ่นพื้น',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'สถานะ: รอดำเนินการ',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Column(
//           children: [
//             ElevatedButton(
//               onPressed: null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 textStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('ตรวจสอบ'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _container4() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.2),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '4.พ่นจริง',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'สถานะ: รอดำเนินการ',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//         SizedBox(
//           width: 10,
//         ),
//         Column(
//           children: [
//             ElevatedButton(
//               onPressed: null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.grey,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 textStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('ตรวจสอบ'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// class commain extends StatefulWidget {
//   final Function(bool) onConfirm;

//   const commain({required this.onConfirm, super.key});
//   @override
//   State<commain> createState() => _commainState();
// }

// class _commainState extends State<commain> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GFAppBar(
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
//         // leading: GFIconButton(
//         //   color: Colors.blue,
//         //   icon: Icon(
//         //     Icons.arrow_back_rounded,
//         //     color: Colors.white,
//         //   ),
//         //   onPressed: () {},
//         // ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               'ตรวจสอบสถานะการซ่อม',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.0),
//               ),
//               height: 100,
//               child: Center(
//                 child: Text(
//                   'ขั้นตอนที่ 2.โป๊ว',
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Column(
//                   children: [
//                     Text('ก่อนทำงาน'),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Text('หลังทำงาน'),
//                   ],
//                 ),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 widget.onConfirm(true);
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 textStyle: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('ยืนยัน'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
