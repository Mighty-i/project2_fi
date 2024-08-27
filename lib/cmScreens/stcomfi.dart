// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class commain extends StatefulWidget {
//   final int processId;

//   commain({
//     required this.processId,
//   });

//   @override
//   State<commain> createState() => _commainState();
// }

// class _commainState extends State<commain> {
//   List<String> imagesBefore = [];
//   List<String> imagesAfter = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchImages();
//   }

//   Future<void> _fetchImages() async {
//     final url =
//         'https://bodyworkandpaint.pantook.com/api/repair_statusPID?Process_ID=${widget.processId}';
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final statusData = data['data'] as List;

//       setState(() {
//         for (var item in statusData) {
//           final statusType = item['StatusType'];
//           final images = [item['Image1'], item['Image2'], item['Image3']];

//           if (statusType == 'ก่อน') {
//             imagesBefore = images;
//           } else if (statusType == 'หลัง') {
//             imagesAfter = images;
//           }
//         }
//       });
//     } else {
//       // Handle error
//       print('Failed to load images');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GFAppBar(
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
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
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('ก่อนทำงาน'),
//                     ...imagesBefore.map((imageUrl) => Padding(
//                           padding: EdgeInsets.symmetric(vertical: 4.0),
//                           child: Image.network(
//                             'https://bodyworkandpaint.pantook.com/storage/$imageUrl',
//                             height: 100,
//                             width: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         )),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('หลังทำงาน'),
//                     ...imagesAfter.map((imageUrl) => Padding(
//                           padding: EdgeInsets.symmetric(vertical: 4.0),
//                           child: Image.network(
//                             'https://bodyworkandpaint.pantook.com/storage/$imageUrl',
//                             height: 100,
//                             width: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         )),
//                   ],
//                 ),
//               ],
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle the confirmation action
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

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class commain extends StatefulWidget {
  final int processId;

  commain({
    required this.processId,
  });

  @override
  State<commain> createState() => _commainState();
}

class _commainState extends State<commain> {
  List _data = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/repair_statusPID?Process_ID=${widget.processId}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _data = jsonData['data'];
      });
    } else {
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'ตรวจสอบสถานะการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: 100,
              child: Center(
                child: Text(
                  'ขั้นตอนที่ ${widget.processId}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _data.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(_data[index]['StatusType'] == 'ก่อน'
                                        ? 'ก่อนทำงาน'
                                        : 'หลังทำงาน'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              children: [
                                Image.network(
                                  'https://bodyworkandpaint.pantook.com/storage/${_data[index]['Image1']}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Error loading image');
                                  },
                                ),
                                SizedBox(height: 8),
                                Image.network(
                                  'https://bodyworkandpaint.pantook.com/storage/images/${_data[index]['Image2']}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Error loading image');
                                  },
                                ),
                                SizedBox(height: 8),
                                Image.network(
                                  'https://bodyworkandpaint.pantook.com/storage/images/${_data[index]['Image3']}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Error loading image');
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('ยืนยัน'),
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
