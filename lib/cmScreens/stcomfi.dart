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
  // List _data = [];
  Map<int, List> groupedData = {};

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
        // _data = jsonData['data'];
        _groupByUser(jsonData['data']);
      });
    } else {
      print('Failed to load data');
    }
  }

  void _groupByUser(List<dynamic> data) {
    for (var item in data) {
      var userId = item['User_ID'];
      var userName = item['name']; // Assuming 'name' is returned in API data

      if (!groupedData.containsKey(userId)) {
        groupedData[userId] = [];
      }
      groupedData[userId]?.add({
        'name': userName, // Store name here
        ...item, // Store other data as usual
      });
    }
  }

  // void _groupByUser(List<dynamic> data) {
  //   for (var item in data) {
  //     var userId = item['User_ID'];

  //     if (!groupedData.containsKey(userId)) {
  //       groupedData[userId] = [];
  //     }
  //     groupedData[userId]?.add(item);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'ตรวจสอบสถานะการซ่อม',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(16.0),
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
              child: Scrollbar(
                thumbVisibility: true, // Optionally set thumb visibility
                thickness: 9.0, // Adjust thickness if needed
                radius: Radius.circular(10),
                child: ListView.builder(
                  itemCount: groupedData.keys.length,
                  itemBuilder: (context, index) {
                    var key = groupedData.keys.elementAt(index);
                    var group = groupedData[key]!;

                    var userName = group[0]['name'];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(8.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    // 'User ID: $key',
                                    '$userName',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: group.map<Widget>((item) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        item['StatusType'] == 'ก่อน'
                                            ? 'ก่อนทำงาน'
                                            : 'หลังทำงาน',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.network(
                                            'https://bodyworkandpaint.pantook.com/storage/${item['Image1']}',
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Text(
                                                  'Error loading image');
                                            },
                                          ),
                                          Image.network(
                                            'https://bodyworkandpaint.pantook.com/storage/${item['Image2']}',
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Text(
                                                  'Error loading image');
                                            },
                                          ),
                                          Image.network(
                                            'https://bodyworkandpaint.pantook.com/storage/${item['Image3']}',
                                            width: 100,
                                            height: 100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Text(
                                                  'Error loading image');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
          ],
        ),
      ),
    );
  }
}
