import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/mScreens/StatusRepair.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MYdashboard extends StatefulWidget {
  final int roleId;
  final String username;
  final String roleName;
  MYdashboard(
      {required this.username, required this.roleName, required this.roleId});

  @override
  State<MYdashboard> createState() => _MYdashboardState();
}

class _MYdashboardState extends State<MYdashboard> {
  late Future<List<RepairProcess>> repairProcesses;

  @override
  void initState() {
    super.initState();
    repairProcesses = fetchRepairProcesses();
  }

  Future<List<RepairProcess>> fetchRepairProcesses() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/repair-processid/${widget.roleId}'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RepairProcess.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load repair processes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                'รายการซ่อม',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<RepairProcess>>(
                future: repairProcesses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No repair processes found'));
                  } else {
                    return ListView(
                      padding: EdgeInsets.all(10.0),
                      children: snapshot.data!
                          .map((repairProcess) =>
                              buildListItem(context, repairProcess))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(BuildContext context, RepairProcess repairProcess) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(10.0),
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
                  'ทะเบียนรถ\n${repairProcess.licensePlate}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'สถานะ\n${repairProcess.status}',
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
                          builder: (context) => Statusrepair(),
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
                    'รับงาน',
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

class RepairProcess {
  final String licensePlate;
  final String status;

  RepairProcess({required this.licensePlate, required this.status});

  factory RepairProcess.fromJson(Map<String, dynamic> json) {
    return RepairProcess(
      licensePlate: json['licenseplate'] ?? 'Unknown',
      status: json['Status'] ?? 'Unknown',
    );
  }
}
