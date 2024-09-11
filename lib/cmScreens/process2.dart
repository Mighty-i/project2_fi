import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/dashboard.dart';
// import 'package:project2_fi/cmScreens/part.dart';
import 'package:project2_fi/navbar2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'selected_parts.dart';

class Process extends StatelessWidget {
  final int roleId;
  final String username;
  final String roleName;
  final int quotationId;
  final String licenseplate;
  final String problemdetails;
  Process({
    required this.roleId,
    required this.username,
    required this.roleName,
    required this.quotationId,
    required this.licenseplate,
    required this.problemdetails,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: DynamicListPage(
        roleId: roleId,
        username: username,
        roleName: roleName,
        quotationId: quotationId,
        licenseplate: licenseplate,
        problemdetails: problemdetails,
      ),
    );
  }
}

class DynamicListPage extends StatefulWidget {
  final int roleId; // Accept roleId
  final String username;
  final String roleName;
  final int quotationId; // Accept quotationId
  final String licenseplate;
  final String problemdetails;

  DynamicListPage({
    required this.roleId,
    required this.username,
    required this.roleName,
    required this.quotationId,
    required this.licenseplate,
    required this.problemdetails,
  });
  @override
  _DynamicListPageState createState() => _DynamicListPageState();
}

class _DynamicListPageState extends State<DynamicListPage> {
  late int quotationId;
  late String licenseplate;
  List<Widget> _items = [];
  final List<String?> _dropdownRepair = [];
  final List<String?> _selectedStepNames = [];
  List<List<Map<String, dynamic>>> _selectedParts = [];
  List<dynamic> repairSteps = [];
  late int processId;
  List<dynamic> selectedParts = [];
  List<dynamic> partsData = [];

  @override
  void initState() {
    super.initState();
    _fetchRepairSteps().then((_) {
      _addItem(); // Add initial item after data is fetched
    });
  }

  void _addItem() {
    SelectedPartsManager.clear();
    setState(() {
      _dropdownRepair.add(null);
      _selectedStepNames.add(null);
      _selectedParts.add([]);
      _items.add(_buildListItem(_items.length));
      // quantities.add([]);
    });
  }

  void _updateDropdownRepair(int index, String? newValue) {
    setState(() {
      if (newValue != null) {
        _dropdownRepair[index] = newValue;
      } else {
        _dropdownRepair[index] = null;
      }
    });
  }
  // _submitRepairProcess(index, newValue);

  String _getStepNameById(String? stepId) {
    if (stepId == null) {
      return 'Unknown Step';
    }

    if (repairSteps.isEmpty) {
      return 'No repair steps available';
    }

    final step = repairSteps.firstWhere(
      (step) => step['Step_ID']?.toString() == stepId,
      orElse: () => null,
    );

    final stepName =
        step != null ? step['StepName'] ?? 'Unknown Step' : 'Unknown Step';
    print('_getStepNameById: stepId = $stepId, stepName = $stepName'); // Debug
    return stepName;
  }

  Future<void> _submitRepairProcess(int index, String? newValue) async {
    final url = 'https://bodyworkandpaint.pantook.com/api/repair_processes';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Quotation_ID': widget.quotationId,
          'licenseplate': widget.licenseplate,
          'Step_ID': newValue,
          // เพิ่มฟิลด์อื่น ๆ ที่ต้องการส่งไปยัง API
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        processId = responseBody['Process_ID'];
        print("Successfully submitted repair process");
        print("บันทึกข้อมูลการซ่อมสำเร็จพร้อมกับ Process_ID: $processId");
        // await _fetchPartsByProcessId(processId);
        setState(() {
          if (index >= _selectedParts.length) {
            _selectedParts.add([]);
          }
          _selectedParts[index].add({'Process_ID': processId});
        });
      } else {
        print("Failed to submit repair process: ${response.reasonPhrase}");
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> _fetchRepairSteps() async {
    final response = await http.get(
      Uri.parse('https://bodyworkandpaint.pantook.com/api/repair_steps'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Response body: $responseBody'); // Debugging

      if (responseBody is Map<String, dynamic> &&
          responseBody.containsKey('data')) {
        setState(() {
          repairSteps = responseBody['data'] as List<
              dynamic>; // Adjust according to the actual response structure
          print('Repair steps: $repairSteps'); // Debugging
        });
      } else if (responseBody is List<dynamic>) {
        setState(() {
          repairSteps = responseBody;
          print('Repair steps: $repairSteps'); // Debugging
        });
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load repair steps');
    }
  }

  Widget _buildListItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 16), // Use SizedBox instead of Expanded here
          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(_selectedStepNames[index] ?? 'ขั้นตอนการซ่อม'),
                // hint: Text(_dropdownRepair[index] ?? 'ขั้นตอนการซ่อม'),อันเดิม
                value: _dropdownRepair[index],
                items: repairSteps.map<DropdownMenuItem<String>>(
                  (step) {
                    final stepId = step['Step_ID']?.toString() ?? '';
                    final stepName = step['StepName'] ?? 'Unknown Step';
                    return DropdownMenuItem<String>(
                      value: stepId,
                      child: Text(stepName, style: TextStyle(fontSize: 20.0)),
                    );
                  },
                ).toList(),
                onChanged: (String? newValue) {
                  print(
                      'Dropdown Changed: Index = $index, New Value = $newValue'); // Debug
                  setState(() {
                    _updateDropdownRepair(index, newValue);
                    _selectedStepNames[index] = _getStepNameById(newValue);
                    print('_selectedStepNames $_selectedStepNames');
                    // _dropdownRepair[index] = newValue;
                  });
                  // _updateDropdownRepair(index, newValue);
                },
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Text(
              'รายการอะไหล่',
              style: TextStyle(fontSize: 14),
            ),
          ),
          // Container(
          //   height: 200.0, // กำหนดความสูงที่ต้องการ
          //   child: partsData == null
          //       ? Center(child: CircularProgressIndicator())
          //       : ListView.builder(
          //           itemCount: partsData.length,
          //           itemBuilder: (context, index) {
          //             final part = partsData[index];
          //             return _buildPartItem(part);
          //           },
          //         ),
          // ),

          SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                // final result = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         Partmain(index: index, processId: processId),
                //   ),
                // );
                // SelectedPartsManager.clearPartsForIndex(index);
                SelectedPartsManager.clear();
                final currentProcessId = _selectedParts[index].isNotEmpty
                    ? _selectedParts[index].last['Process_ID']
                    : null;

                if (currentProcessId != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Partmain(index: index, processId: currentProcessId),
                    ),
                  );
                  print(
                      'Navigating to Partmain with Process_ID: $currentProcessId');
                } else {
                  print('Process ID not found for index $index');
                }
                // if (result == true) {
                //   await _fetchPartsByProcessId(processId); // Update parts data
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            child: Text("รายละเอียดงาน"),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'รายละเอียดงาน'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPartItem(Map<String, dynamic> part) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 8.0),
  //     padding: EdgeInsets.all(16.0),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16.0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 10,
  //           spreadRadius: 5,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //             'Part: ${part['Name'] ?? 'Unknown Part'}',
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildVehicleInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ทะเบียนรถ: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                widget.licenseplate,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Toyota Corolla 2018"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'รายละเอียด: ',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                widget.problemdetails,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: GFIconButton(
          color: Colors.blue,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => apppage(
            //         roleId: widget.roleId,
            //         username: widget.username,
            //         roleName: widget.roleName,
            //       ),
            //     ));
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'จัดการกระบวนการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildVehicleInfo(),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
              child: Text("ขั้นตอนการซ่อม"),
            ),
            ..._items,
            SizedBox(height: 16),
            GFIconButton(
              padding: EdgeInsets.symmetric(horizontal: 180, vertical: 7),
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24.0),
                ),
              ),
              onPressed: _addItem,
              icon: Icon(
                Icons.add,
                size: 24,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Partmain extends StatefulWidget {
  final int index; // Add index parameter
  final int processId;

  Partmain({required this.index, required this.processId});

  @override
  State<Partmain> createState() => _PartmainState();
}

class _PartmainState extends State<Partmain> {
  List<dynamic> partsData = [];

  @override
  void initState() {
    super.initState();
    print("Navigated to Partmain with index: ${widget.index}");
    _fetchPartsData();
  }

  Future<void> _fetchPartsData() async {
    final response = await http.get(
      Uri.parse('https://bodyworkandpaint.pantook.com/api/parts'),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      setState(() {
        partsData = responseBody['data'];
      });
    } else {
      throw Exception('Failed to load parts data');
    }
  }

  Widget partListview(BuildContext context, int partId, String partName,
      String description, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(36.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 10,
              //     spreadRadius: 5,
              //   )
              // ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 8),
                    // Text('รายละเอียด: $description'),
                    Text(
                      'รายละเอียด: \n${description.length > 29 ? '${description.substring(0, 29)}...' : description}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text('คงเหลือ: $quantity'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              final selectedPart = {
                'Part_ID': partId,
                'Name': partName,
              };
              // SelectedPartsManager.addPart(
              //     selectedPart, widget.index, widget.processId);
              print('Added part: $selectedPart');
            });
          },
          child: Icon(Icons.add, size: 36, color: Colors.black),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(22.0),
            foregroundColor: Color.fromARGB(255, 247, 24, 255),
            backgroundColor: Color.fromARGB(255, 134, 199, 252),
            side: BorderSide(color: Color.fromARGB(255, 0, 104, 189)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: GFIconButton(
          color: Colors.blue,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Return selected parts
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'รายการอะไหล่',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                "Toyota Corolla 2018",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'ค้นหา',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Handle search button press
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: partsData.length,
                itemBuilder: (context, index) {
                  final part = partsData[index];
                  return partListview(
                    context,
                    part['Part_ID'],
                    part['Name'] ?? 'Unknown',
                    part['Description'] ?? 'No description available',
                    part['Quantity'] ?? 0,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PartSummary(processId: widget.processId),
                  ),
                );
              },
              child: Text('สรุป'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartSummary extends StatefulWidget {
  final int processId;

  PartSummary({required this.processId});

  @override
  _PartSummaryState createState() => _PartSummaryState();
}

class _PartSummaryState extends State<PartSummary> {
  void _removePart(int index, int partIndex) {
    setState(() {
      SelectedPartsManager.removePart(index, partIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedParts = SelectedPartsManager.getSelectedParts();

    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปรายการอะไหล่ที่เลือก'),
      ),
      body: ListView.builder(
        itemCount: selectedParts.length,
        itemBuilder: (context, index) {
          final part = selectedParts[index];
          return ListTile(
            title: Text(part['Name']),
            subtitle: Text('Process ID: ${part['Process_ID']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (part['index'] != null) {
                  // ใช้ index จาก part ถ้ามี
                  SelectedPartsManager.removePart(part['index'], index);
                } else {
                  // ถ้า part['index'] เป็น null ให้ใช้ index ของ ListView.builder
                  SelectedPartsManager.removePart(index, index);
                }
                setState(() {
                  selectedParts.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // กลับไปที่ Partmain
              },
              child: Text('เพิ่มอะไหล่'),
            ),
            ElevatedButton(
              onPressed: () async {
                for (var part in selectedParts) {
                  await _savePartUsage(part['Part_ID'], part['Process_ID']);
                }
                // Navigator.pop(context, true); // กลับไปที่หน้าจอก่อนหน้า
                // Navigator.popUntil(context, ModalRoute.withName('/Process'));
                Navigator.pop(context); // กลับไปที่หน้าจอ Partmain
                Navigator.pop(context); // กลับไปที่หน้าจอ Process
              },
              child: Text('ยืนยันและบันทึก'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePartUsage(int partId, int processId) async {
    final url = 'https://bodyworkandpaint.pantook.com/api/part_usage';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Part_ID': partId,
          'Process_ID': processId,
        }),
      );

      if (response.statusCode == 201) {
        print("บันทึกการใช้อะไหล่สำเร็จ");
      } else {
        print("บันทึกการใช้อะไหล่ไม่สำเร็จ: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
  }
}


// class PartsListView extends StatefulWidget {
//   final List<Map<String, dynamic>> selectedParts;
//   final List<int> quantities;
//   final ValueChanged<int> onQuantityChanged;

//   PartsListView({
//     required this.selectedParts,
//     required this.quantities,
//     required this.onQuantityChanged,
//   });

//   @override
//   _PartsListViewState createState() => _PartsListViewState();
// }

// class _PartsListViewState extends State<PartsListView> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: List.generate(widget.selectedParts.length, (i) {
//           final part = widget.selectedParts[i];
//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 8.0),
//             padding: EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'อะไหล่: ${part['Name'] ?? 'Unknown Part'}',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           if (widget.quantities.length > i &&
//                               widget.quantities[i] > 0) {
//                             widget.quantities[i]--;
//                             widget.onQuantityChanged(i);
//                           }
//                         });
//                       },
//                     ),
//                     Text('${widget.quantities[i]}'),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         setState(() {
//                           if (widget.quantities.length > i) {
//                             widget.quantities[i]++;
//                             widget.onQuantityChanged(i);
//                           }
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }