import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project2_fi/mScreens/end.dart';
import 'package:project2_fi/mScreens/start.dart';

class Statusrepair extends StatefulWidget {
  final String licensePlate;
  final String description;
  final int processId;
  final int userId;

  Statusrepair(
      {required this.licensePlate,
      required this.description,
      required this.processId,
      required this.userId});

  @override
  State<Statusrepair> createState() => _StatusrepairState();
}

class _StatusrepairState extends State<Statusrepair> {
  bool isJobStarted = false;
  List<dynamic> pu = [];
  String formattedDate = '';

  void initState() {
    super.initState();
    fetchPartUsage();
    initializeDateFormatting('th_TH', null).then((_) {
      setState(() {
        DateTime now = DateTime.now();
        var thaiDateFormatter = DateFormat('d MMMM yyyy', 'th_TH');
        String thaiDate = thaiDateFormatter.format(now);

        // เพิ่มปีเป็นพ.ศ.
        int buddhistYear = now.year + 543;
        formattedDate = thaiDate.replaceAll('${now.year}', '$buddhistYear');
      });
    });
  }

  Future<void> fetchPartUsage() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/part_usage?Process_ID=${widget.processId}'));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Parsed data: $data');
      setState(() {
        pu = data['data'];
      });
    } else {
      throw Exception('Failed to load part usage data');
    }
  }

  void _showPartUsagePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('รายการอะไหล่ที่ต้องใช้'),
          content: Container(
            width: double.maxFinite,
            child: pu.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: pu.length,
                    itemBuilder: (context, index) {
                      var part = pu[index];
                      return ListTile(
                        title: Text(part['Name']),
                        subtitle: Text('จำนวน: ${part['Quantity']}'),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: GFIconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            // color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'กระบวนการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Container(
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
                  // '1 ม.ค. 2567',
                  formattedDate,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ทะเบียนรถ ',
                      // widget.licensePlate,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.licensePlate,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    //testค่าprocessid
                    Text(
                      widget.processId.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                child: Column(
                  children: [
                    const Text(
                      'รายละเอียดงาน',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              Align(
                child: ElevatedButton(
                  onPressed: _showPartUsagePopup,
                  child: Text('แสดงรายการอะไหล่'),
                ),
              ),
              SizedBox(height: 40),
              // Align(
              //   alignment: Alignment.center,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => Start(
              //             processId: widget.processId,
              //             userId: widget.userId,
              //           ),
              //         ),
              //       );

              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       padding:
              //           EdgeInsets.symmetric(horizontal: 150, vertical: 32),
              //     ),
              //     child: Text(
              //       'เริ่มงาน',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isJobStarted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => end(
                            processId: widget.processId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    } else {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Start(
                            processId: widget.processId,
                            userId: widget.userId,
                          ),
                        ),
                      );
                      // ถ้าเริ่มงานเสร็จแล้ว เปลี่ยนสถานะปุ่ม
                      if (result == 'job_started') {
                        setState(() {
                          isJobStarted = true;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 150, vertical: 32),
                  ),
                  child: Text(
                    isJobStarted ? 'ปิดงาน' : 'เริ่มงาน',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
