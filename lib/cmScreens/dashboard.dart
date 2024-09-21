import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/process3.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class dashboard extends StatefulWidget {
  final int roleId;
  final String username;
  final String roleName;
  dashboard(
      {required this.username, required this.roleName, required this.roleId});
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<dynamic> quotations = [];
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    fetchQuotations();
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

  Future<void> fetchQuotations() async {
    final url = 'https://bodyworkandpaint.pantook.com/api/quotations';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quotations = data['data'];
      });
    } else {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load quotations')),
      );
    }
  }

  Future<void> _refresh() async {
    await fetchQuotations(); // รีเฟรชข้อมูลใหม่
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 3,
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
            padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
            child: const Text(
              'รายการรถเข้าซ่อม',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                return buildListItem(quotations[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(dynamic quotation, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      // padding: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 36, vertical: 10),

                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  // padding:
                  //     const EdgeInsets.symmetric(horizontal: 44, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'ทะเบียน: ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        ' ${quotation['licenseplate']}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'ความเสียหาย\n${quotation['damageassessment']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                width: 80,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Process(
                          roleId: widget.roleId,
                          username: widget.username,
                          roleName: widget.roleName,
                          quotationId: quotation['Quotation_ID'],
                          licenseplate: quotation['licenseplate'],
                          problemdetails: quotation['problemdetails'],
                          brand: quotation['Brand'],
                          model: quotation['Model'],
                          year: quotation['Year'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                  ),
                  child: const Text(
                    'ตรวจสอบ',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
