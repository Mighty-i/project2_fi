import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/mScreens/StatusRepair.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MYdashboard extends StatefulWidget {
  final int roleId;
  final String username;
  final String roleName;
  final int userId;

  MYdashboard(
      {required this.username,
      required this.roleName,
      required this.roleId,
      required this.userId});

  @override
  State<MYdashboard> createState() => _MYdashboardState();
}

class _MYdashboardState extends State<MYdashboard> {
  List<dynamic> repairProcesses = [];
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    fetchRepairProcesses();
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

  Future<void> fetchRepairProcesses() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/repair-processid/${widget.roleId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        repairProcesses = data['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load repair processes')),
      );
    }
  }

  Future<void> _refresh() async {
    await fetchRepairProcesses(); // รีเฟรชข้อมูลใหม่
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
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
                formattedDate,
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
            child: const Text(
              'รายการซ่อม',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: repairProcesses.length,
              itemBuilder: (context, index) {
                return buildListItem(repairProcesses[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(dynamic repairProcess, BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'ทะเบียนรถ\n${repairProcess['licenseplate']}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'สถานะ\n${repairProcess['Status']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Statusrepair(
                            licensePlate: repairProcess['licenseplate'],
                            description: repairProcess['Description'],
                            processId: repairProcess['Process_ID'],
                            userId: widget.userId,
                            username: widget.username,
                            roleName: widget.roleName,
                            roleId: widget.roleId,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  ),
                  child: Text(
                    'งาน',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class RepairProcess {
//   final String licensePlate;
//   final String status;
//   final String description; // Add this field
//   final int processId; // Add this field
//   final int userId; // Add this field

//   RepairProcess({
//     required this.licensePlate,
//     required this.status,
//     required this.description,
//     required this.processId,
//     required this.userId,
//   });

//   factory RepairProcess.fromJson(Map<String, dynamic> json) {
//     return RepairProcess(
//       licensePlate: json['licenseplate'] ?? 'Unknown',
//       status: json['Status'] ?? 'Unknown',
//       description: json['Description'] ?? 'No Description', // Add this
//       processId: json['Process_ID'] ?? 0, // Add this
//       userId: json['User_ID'] ?? 0, // Add this
//     );
//   }
// }
