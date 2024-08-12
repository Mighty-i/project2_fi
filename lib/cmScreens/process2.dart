import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/dashboard.dart';
// import 'package:project2_fi/cmScreens/part.dart';
import 'package:project2_fi/navbar2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Widget> _items = [];
  List<String?> _dropdownRepair = [];
  List<String> _selectedParts = [];
  List<dynamic> repairSteps = [];

  @override
  void initState() {
    super.initState();
    // _fetchRepairSteps();
    // _addItem(); // Add initial item
    _fetchRepairSteps().then((_) {
      _addItem(); // Add initial item after data is fetched
    });
  }

  void _updateSelectedParts(List<String> parts) {
    setState(() {
      _selectedParts = parts;
      print('_selectedParts: part = $parts');
    });
  }

  void _clearSelectedParts() {
    setState(() {
      _selectedParts.clear(); // Clear the list of selected parts
    });
  }

  void _addItem() {
    setState(() {
      _dropdownRepair.add(null);
      _items.add(_buildListItem(_items.length));
    });
  }
  // void _addItem() {
  //   setState(() {
  //     // Check if this is the first item being added and repairSteps is not empty
  //     if (_items.isEmpty && repairSteps.isNotEmpty) {
  //       _dropdownRepair.add(repairSteps[0]['Step_ID'].toString());
  //     } else {
  //       _dropdownRepair.add(null);
  //     }
  //     _items.add(_buildListItem(_items.length));
  //   });
  // }

  void _updateDropdownRepair(int index, String? newValue) {
    setState(() {
      if (newValue != null) {
        _dropdownRepair[index] = newValue;
      } else {
        _dropdownRepair[index] = null; // Reset to null to show the hint
      }
      print('_updateDropdownRepair: index = $index, newValue = $newValue');
    });
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
          SizedBox(height: 16), // ใช้ SizedBox แทน Expanded ที่นี่
          Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(_dropdownRepair[index] ?? 'ขั้นตอนการซ่อม'),
                    value: _dropdownRepair[index],

                    items: repairSteps.map<DropdownMenuItem<String>>(
                      (step) {
                        final stepId = step['Step_ID']?.toString() ?? '';
                        final stepName = step['StepName'] ?? 'Unknown Step';
                        return DropdownMenuItem<String>(
                          value: stepId,
                          child:
                              Text(stepName, style: TextStyle(fontSize: 20.0)),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      print(
                          'Dropdown Changed: Index = $index, New Value = $newValue'); // Debug
                      setState(() {
                        _updateDropdownRepair(index, newValue);
                      });
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    borderRadius: BorderRadius.circular(12.0),
                    // border: const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                );
              },
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
          Column(
            children: [
              for (String part in _selectedParts)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'อะไหล่: $part',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {},
                          ),
                          Text('0'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                final selectedParts = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Partmain(),
                    ));

                if (selectedParts != null) {
                  _updateSelectedParts(selectedParts);
                } else {
                  _clearSelectedParts();
                }
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
  @override
  State<Partmain> createState() => _PartmainState();
}

class _PartmainState extends State<Partmain> {
  List<String> _selectedParts = [];
  Widget partListview(BuildContext context, String partName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
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
              ]),
          child: Row(
            children: [
              Text(partName),
              SizedBox(
                width: 20,
              ),
              Text('จำนวน: 10 ชิ้น'),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              if (!_selectedParts.contains(partName)) {
                _selectedParts.add(partName);
              }
              print('addpart: $partName');
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
            Navigator.pop(context, _selectedParts); // Return selected parts
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
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: List.generate(
                        10, (index) => partListview(context, 'อะไหล่ $index'))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
