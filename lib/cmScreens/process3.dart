import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
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
  List<List<Map<String, dynamic>>> _selectedParts = [];
  List<dynamic> repairSteps = [];
  late int processId;
  List<dynamic> selectedParts = [];
  List<dynamic> partsData = [];

  Map<String, Map<String, dynamic>> selectedTasks = {};
  final Set<int> _submittedStepIds = {};
  // final List<String> _submittedStepIds = [];

  @override
  void initState() {
    super.initState();
    _fetchRepairSteps();
  }

  Future<void> _submitRepairProcess() async {
    final url = 'https://bodyworkandpaint.pantook.com/api/repair_processes';

    Map<int, int> processIds = {};

    for (var entry in selectedTasks.entries) {
      final stepId = entry.value['Step_ID'];

      // ตรวจสอบว่าถ้า Step_ID นี้ยังไม่เคยถูกบันทึกมาก่อน
      if (entry.value['selected'] == true &&
          !_submittedStepIds.contains(stepId)) {
        try {
          final response = await http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'Quotation_ID': widget.quotationId,
              'licenseplate': widget.licenseplate,
              'Step_ID': stepId,
              // เพิ่มฟิลด์อื่น ๆ ที่ต้องการส่งไปยัง API
            }),
          );

          if (response.statusCode == 201) {
            final responseBody = jsonDecode(response.body);
            final processId = responseBody['Process_ID'];
            final responseStepId = responseBody['Step_ID'];
            print("Successfully submitted repair process for Step_ID: $stepId");
            print(
                "บันทึกข้อมูลการซ่อมสำเร็จพร้อมกับ Process_ID: $processId&Step_ID: $responseStepId");

            processIds[responseStepId] = processId;
            print(processIds);
            setState(() {
              _submittedStepIds.add(stepId); // เก็บ Step_ID ที่บันทึกสำเร็จ
              _selectedParts
                  .add({'Process_ID': processId} as List<Map<String, dynamic>>);
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
    }
    // อัปเดต selectedTasks ด้วย Process_ID ที่ได้
    setState(() {
      for (var key in selectedTasks.keys) {
        final stepId = selectedTasks[key]?['Step_ID'];
        if (processIds.containsKey(stepId)) {
          selectedTasks[key]?['Process_ID'] = processIds[stepId];
        } else if (selectedTasks[key]?['selected'] == false) {
          // เคลียร์ Process_ID เมื่อ selected = false
          selectedTasks[key]?['Process_ID'] = null;
        }
      }
    });
    print("Updated selectedTasks: $selectedTasks");
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
          repairSteps = responseBody['data'] as List<dynamic>;
          print('Repair steps: $repairSteps'); // Debugging
          // ตั้งค่าเริ่มต้นให้ทุกงานเป็น false (ยังไม่ได้เลือก)
          for (var step in repairSteps) {
            selectedTasks[step['StepName']] = {
              'selected': false,
              'Step_ID': step['Step_ID']
            };
          }
        });
      } else if (responseBody is List<dynamic>) {
        setState(() {
          repairSteps = responseBody;
          print('Repair steps: $repairSteps'); // Debugging
          // ตั้งค่าเริ่มต้นให้ทุกงานเป็น false (ยังไม่ได้เลือก)
          for (var step in repairSteps) {
            selectedTasks[step['StepName']] = {
              'selected': false,
              'Step_ID': step['Step_ID']
            };
          }
        });
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load repair steps');
    }
  }

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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => apppage(
                    roleId: widget.roleId,
                    username: widget.username,
                    roleName: widget.roleName,
                  ),
                ));
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
      body: repairSteps.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: 16),
                _buildVehicleInfo(),
                SizedBox(height: 16),
                Text(
                  'เลือกขั้นตอนการซ่อม',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                // แสดงรายการงานซ่อมทั้งหมดพร้อม Checkbox
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    children: repairSteps.map((step) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            step['StepName'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: selectedTasks[step['StepName']]?['selected'],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedTasks[step['StepName']]?['selected'] =
                                  value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // ปุ่มสำหรับดำเนินการต่อ
                ElevatedButton(
                  child: const Text(
                    "ถัดไป",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  onPressed: () async {
                    await _submitRepairProcess();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          selectedTasks: selectedTasks,
                          roleId: widget.roleId,
                          username: widget.username,
                          roleName: widget.roleName,
                          quotationId: widget.quotationId,
                        ),
                      ),
                    );
                    // print(selectedTasks);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}

class TaskDetailScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> selectedTasks;
  final int roleId; // Accept roleId
  final String username;
  final String roleName;
  final int quotationId;

  TaskDetailScreen({
    required this.selectedTasks,
    required this.roleId,
    required this.username,
    required this.roleName,
    required this.quotationId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Map<int, String> taskDetails = {};

  void _confirmAndSubmit() async {
    for (var entry in widget.selectedTasks.entries) {
      if (entry.value['selected']) {
        final processId = entry.value['Process_ID'] ?? 0;
        final taskDetail = taskDetails[processId] ?? '';

        // Send the taskDetail to the API for the given processId
        await _submitTaskDetail(processId, taskDetail);
        await _updatequotationId(widget.quotationId);
      }
    }

    // After submission, navigate back or show a confirmation
    Navigator.pop(context, true);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => apppage(
            roleId: widget.roleId,
            username: widget.username,
            roleName: widget.roleName,
          ),
        ));
  }

  Future<void> _submitTaskDetail(int processId, String taskDetail) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://bodyworkandpaint.pantook.com/api/repair-processUpdate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'Process_ID': processId,
            'Description': taskDetail,
          },
        ),
      );
      if (response.statusCode == 200) {
        print("บันทึกขั้นตอนสำเร็จ");
      } else {
        print("บันทึกขั้นตอนไม่สำเร็จ: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  Future<void> _updatequotationId(int quotationId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://bodyworkandpaint.pantook.com/api/quotationsupdateStatus'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'Quotation_ID': quotationId,
          },
        ),
      );
      if (response.statusCode == 200) {
        print("ใบเสนอสำเร็จ");
      } else {
        print("ใบเสนอไม่สำเร็จ: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // กรองเฉพาะงานที่ถูกเลือก
    final selectedTaskList = widget.selectedTasks.entries
        .where((entry) => entry.value['selected'])
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดงานที่เลือก"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: selectedTaskList.map((entry) {
                final taskName = entry.key;
                final stepId = entry.value['Step_ID'];
                final processId = entry.value['Process_ID'] ?? 'ไม่มีการบันทึก';

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                taskName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text("Step ID: $stepId"),
                              Text("Process ID: $processId"),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                16), // Use SizedBox instead of Expanded here
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                          child: Text(
                            'เลือกอะไหล่ที่ต้องใช้',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),

                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              SelectedPartsManager.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Partmain(processId: processId),
                                ),
                              );
                              SelectedPartsManager.clearPartsForProcessId(
                                  processId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
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
                            initialValue: taskDetails[processId] ?? '',
                            decoration:
                                InputDecoration(labelText: 'กรอกรายละเอียดงาน'),
                            onChanged: (value) {
                              setState(() {
                                taskDetails[processId] = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _confirmAndSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: Text(
              'ยืนยัน',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

// Widget _buildListItem(int index) {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: 8.0),
//     padding: EdgeInsets.all(16.0),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16.0),
//     ),
//     child: Column(
//       children: [
//         SizedBox(height: 16), // Use SizedBox instead of Expanded here
//         Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
//           child: Text(
//             'เลือกอะไหล่ที่ต้องใช้',
//             style: TextStyle(fontSize: 14),
//           ),
//         ),

//         SizedBox(height: 16),
//         Align(
//           alignment: Alignment.center,
//           child: ElevatedButton(
//             onPressed: () async {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.withOpacity(0.5),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             child: Icon(Icons.add),
//           ),
//         ),
//         SizedBox(height: 16),
//         Container(
//           alignment: Alignment.center,
//           child: Text("รายละเอียดงาน"),
//         ),
//         Container(
//           child: TextFormField(
//             decoration: InputDecoration(labelText: 'รายละเอียดงาน'),
//           ),
//         ),
//       ],
//     ),
//   );
// }

class Partmain extends StatefulWidget {
  final int processId;

  Partmain({required this.processId});

  @override
  State<Partmain> createState() => _PartmainState();
}

class _PartmainState extends State<Partmain> {
  List<dynamic> partsData = [];
  List<dynamic> filteredParts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    print("Navigated to Partmain with index: ${widget.processId}");
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
        filteredParts = partsData;
      });
    } else {
      throw Exception('Failed to load parts data');
    }
  }

  // void _filterPartsData() {
  //   setState(() {
  //     if (searchQuery.isEmpty) {
  //       filteredParts = partsData; // ถ้าไม่มีการค้นหา แสดงผลทั้งหมด
  //     } else {
  //       filteredParts = partsData
  //           .where((part) =>
  //               part['Name'].toLowerCase().contains(searchQuery.toLowerCase()))
  //           .toList(); // กรองข้อมูลตามคำค้นหา
  //     }
  //   });
  // }

  void _filterPartsData(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredParts = partsData; // ถ้าไม่มีคำค้นหาแสดงรายการทั้งหมด
      } else {
        filteredParts = partsData.where((part) {
          final partName = part['Name'].toLowerCase();
          return partName
              .contains(searchQuery.toLowerCase()); // ค้นหาโดยไม่สนตัวเล็กใหญ่
        }).toList();
      }
    });
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 5,
                )
              ],
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
              SelectedPartsManager.addPart(selectedPart, widget.processId);
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
              // children: [
              //   Expanded(
              //     child: TextField(
              //       onChanged: (value) {
              //         setState(() {
              //           searchQuery = value; // อัปเดตคำค้นหาเมื่อพิมพ์
              //         });
              //       },
              //       decoration: InputDecoration(
              //         labelText: 'ค้นหา',
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //     ),
              //   ),
              //   SizedBox(width: 10),
              //   IconButton(
              //     icon: Icon(Icons.search),
              //     onPressed: _filterPartsData,
              //   ),
              // ],
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'ค้นหา',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterPartsData, // ค้นหาเมื่อพิมพ์ข้อความ
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // อัพเดตรายการเมื่อกดปุ่มค้นหา
                    _filterPartsData(searchQuery);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredParts.length,
                itemBuilder: (context, index) {
                  final part = filteredParts[index];
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
              onPressed: () {
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
  void _removePart(int processId, int partIndex) {
    setState(() {
      SelectedPartsManager.removePart(processId, partIndex);
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
                _removePart(widget.processId, index);
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
