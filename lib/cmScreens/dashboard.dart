import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/process2.dart';
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
        SnackBar(content: Text('Failed to load quotations')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            'รายการรถเข้าซ่อม',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: quotations.length,
            itemBuilder: (context, index) {
              return buildListItem(quotations[index], context);
            },
          ),
        ),
      ],
    );
  }

  Widget buildListItem(dynamic quotation, BuildContext context) {
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
                  'ทะเบียนรถ\n${quotation['licenseplate']}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'ความเสียหาย: ${quotation['damageassessment']}',
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
                        builder: (context) => Process(
                          roleId: widget.roleId,
                          username: widget.username,
                          roleName: widget.roleName,
                          quotationId: quotation['Quotation_ID'],
                          licenseplate: quotation['licenseplate'],
                          problemdetails: quotation['problemdetails'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  ),
                  child: Text(
                    'Plan',
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
