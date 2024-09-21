import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project2_fi/cmScreens/status.dart';

class history extends StatefulWidget {
  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  List<dynamic> quotations = [];
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    fetchQuotationsInProgress();
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

  Future<void> fetchQuotationsInProgress() async {
    final response = await http.get(Uri.parse(
        'https://bodyworkandpaint.pantook.com/api/quotationsInProgress'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quotations = data['data'];
      });
    } else {
      throw Exception('Failed to load quotations data');
    }
  }

  double calculateProgress(List<dynamic> repairProcesses) {
    int total = repairProcesses.length;
    int completed = repairProcesses
        .where((process) => process['Status'] == 'Completed')
        .length;
    return completed / total;
  }

  Future<void> _refresh() async {
    await fetchQuotationsInProgress(); // รีเฟรชข้อมูลใหม่
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  const BoxShadow(
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
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 5),
            child: const Text(
              'รายการที่ดำเนินการซ่อม',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                return buildListItem(quotations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(dynamic quotation) {
    List<dynamic> repairProcesses = quotation['repair_processes'];
    double progress = calculateProgress(repairProcesses);

    print('Repair Processes: $repairProcesses');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'ทะเบียน\n${quotation['licenseplate']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              // Column(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('รอตรวจสอบ'),
              //     // Check if the last step's status is 'verification'
              //     Align(
              //       alignment: const AlignmentDirectional(0, 0),
              //       child: Text(
              //         ': ${repairProcesses.lastWhere((process) => process['Status'] == 'verification', orElse: () => null)?['StepName'] ?? 'ไม่มีขั้นตอนรอตรวจสอบ'}',
              //       ),
              //     ),
              //     // Check if the second-to-last step's status is 'In Progress'
              //     const Text('ล่าสุด'),
              //     Align(
              //       alignment: const AlignmentDirectional(0, 0),
              //       child: Text(
              //         ': ${repairProcesses.firstWhere((process) => process['Status'] == 'In Progress', orElse: () => null)?['StepName'] ?? 'ไม่มีขั้นตอนล่าสุด'}',
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyStatus(
                        quotationId: quotation['Quotation_ID'],
                        licenseplate: quotation['licenseplate'],
                        brand: quotation['Brand'],
                        model: quotation['Model'],
                        year: quotation['Year'],
                        quotationDate: quotation['QuotationDate'],
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chevron_right_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                hoverColor: Colors.blue,
                style: IconButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  backgroundColor: Colors.blueAccent,
                  shape: const RoundedRectangleBorder(
                    // ใช้ปรับให้เป็นเหลี่ยม
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ), // ปรับให้มุมเป็น 0
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Text('รอตรวจสอบ'),
                  // Check if the last step's status is 'verification'
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Text(
                      ': ${repairProcesses.lastWhere((process) => process['Status'] == 'verification', orElse: () => null)?['StepName'] ?? 'ไม่มีขั้นตอนรอตรวจสอบ'}',
                    ),
                  ),
                ],
              ),
              // Check if the second-to-last step's status is 'In Progress'
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Text('ล่าสุด'),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Text(
                      ': ${repairProcesses.firstWhere((process) => process['Status'] == 'In Progress', orElse: () => null)?['StepName'] ?? 'ไม่มีขั้นตอนล่าสุด'}',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          GFProgressBar(
            percentage: progress,
            lineHeight: 30,
            backgroundColor: Colors.black12,
            progressBarColor: Colors.greenAccent.shade400,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2.5, 5, 5),
              child: Text(
                '${(progress * 100).toInt()}%',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
