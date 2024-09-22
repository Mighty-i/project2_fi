import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class History extends StatefulWidget {
  final int roleId;
  final String username;
  final String roleName;
  final int userId;

  History(
      {required this.username,
      required this.roleName,
      required this.roleId,
      required this.userId});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> repairProcesses = [];

  @override
  void initState() {
    super.initState();
    fetchRepairProcesses();
  }

  Future<void> fetchRepairProcesses() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/repair-processidCOM/${widget.roleId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        repairProcesses = data['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load repair processes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.center,
            // padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
            padding: const EdgeInsets.all(16.0),
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
            child: const Text(
              'ประวัติการซ่อม',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: repairProcesses.length,
            itemBuilder: (context, index) {
              return buildListItem(repairProcesses[index], context);
            },
          ),
        ),
      ],
    );
  }

  Widget buildListItem(dynamic repairProcess, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    'ทะเบียน\n${repairProcess['licenseplate']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Text(
                'สถานะ\n${repairProcess['Status']}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
