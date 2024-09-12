import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project2_fi/mScreens/end.dart';

import 'package:project2_fi/mScreens/start.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Statusrepair extends StatefulWidget {
  final String licensePlate;
  final String description;
  final int processId;
  final int userId;
  final String username;
  final String roleName;
  final int roleId;

  Statusrepair({
    required this.licensePlate,
    required this.description,
    required this.processId,
    required this.userId,
    required this.username,
    required this.roleName,
    required this.roleId,
  });

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
    _loadJobStatus();
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
          backgroundColor: Colors.white,
          title: Text('รายการอะไหล่ที่ต้องใช้'),
          content: SizedBox(
            height: 500,
            child: Column(
              children: [
                Container(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'ชื่ออะไหล่',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 120,
                      ),
                      Text(
                        'จำนวน',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    child: pu.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: pu.length,
                            itemBuilder: (context, index) {
                              var part = pu[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    width: 150,
                                    child: Text(
                                      part['Name'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Text('${part['Quantity']}',
                                            style:
                                                const TextStyle(fontSize: 18)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              );
                              // return ListTile(
                              //   title: Text(
                              //     part['Name'],
                              //     style: TextStyle(fontSize: 20),
                              //   ),
                              //   subtitle: Text(
                              //     'จำนวน: ${part['Quantity']}',
                              //     style: TextStyle(fontSize: 18),
                              //   ),
                              // );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadJobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedProcessId = prefs.getInt('processId');
    bool jobStarted = prefs.getBool('isJobStarted') ?? false;

    if (storedProcessId == widget.processId) {
      setState(() {
        isJobStarted = jobStarted;
      });
    }
  }

  Future<void> _updateJobStatus(bool started) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isJobStarted', started);
    await prefs.setInt('processId', widget.processId);
  }

  Future<void> _clearJobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedProcessId = prefs.getInt('processId');
    if (storedProcessId == widget.processId) {
      await prefs.remove('isJobStarted');
      await prefs.remove('processId');
    }
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
              'กระบวนการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
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
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),

                          //testค่าprocessid
                          Text(
                            widget.processId.toString(),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'รายละเอียดงาน',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 340,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 23),
                    ),
                    onPressed: _showPartUsagePopup,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'แสดงรายการอะไหล่',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isJobStarted) {
                        await _clearJobStatus();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => end(
                              processId: widget.processId,
                              userId: widget.userId,
                              roleId: widget.roleId,
                              username: widget.username,
                              roleName: widget.roleName,
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
                          await _updateJobStatus(true);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 130, vertical: 32),
                    ),
                    icon: const Icon(
                      Icons.camera_enhance,
                      color: Colors.white,
                    ),
                    label: Text(
                      isJobStarted ? 'ปิดงาน' : 'เริ่มงาน',
                      style: const TextStyle(
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
      ),
    );
  }
}
