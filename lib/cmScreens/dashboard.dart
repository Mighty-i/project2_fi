import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project2_fi/cmScreens/process2.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Quotation> _quotations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchQuotations();
  }

  Future<void> _fetchQuotations() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/quotations');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        print('API Response: $jsonData'); // Debug print
        if (jsonData != null && jsonData.isNotEmpty) {
          setState(() {
            _quotations =
                jsonData.map((json) => Quotation.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No data received';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load quotations: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
        print(e);
      });
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
            child: const Text(
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
          child: const Text(
            'รายการรถเข้าซ่อม',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: _quotations.length,
                      itemBuilder: (context, index) {
                        return buildListItem(
                            index, context, _quotations[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget buildListItem(int index, BuildContext context, Quotation quotation) {
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
                  'ทะเบียนรถ\n${quotation.licenseplate}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'ความเสียหาย: ${quotation.damageassessment}',
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
                          builder: (context) => Process(),
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

class Quotation {
  final int id;
  final String licenseplate;
  final String damageassessment;
  final String description;

  Quotation({
    required this.id,
    required this.licenseplate,
    required this.damageassessment,
    required this.description,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'] ?? 0, // ใช้ค่าเริ่มต้นเป็น 0 ถ้าค่า id เป็น null
      licenseplate: json['licenseplate'] ??
          '', // ใช้ค่าเริ่มต้นเป็น empty string ถ้าค่า licenseplate เป็น null
      damageassessment: json['damageassessment'] ??
          '', // ใช้ค่าเริ่มต้นเป็น empty string ถ้าค่า damageassessment เป็น null
      description: json['description'] ??
          '', // ใช้ค่าเริ่มต้นเป็น empty string ถ้าค่า description เป็น null
    );
  }
}
