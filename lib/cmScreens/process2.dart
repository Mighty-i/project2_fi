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
  late int quotationId;
  late String licenseplate;
  List<Widget> _items = [];
  List<String?> _dropdownRepair = [];
  // List<Map<String, dynamic>> _selectedParts = [];
  List<List<Map<String, dynamic>>> _selectedParts = [];
  List<List<int>> quantities = [];
  List<List<int>> _quantities = [];
  List<dynamic> repairSteps = [];

  @override
  void initState() {
    super.initState();
    quotationId = widget.quotationId;
    licenseplate = widget.licenseplate;
    // _fetchRepairSteps();
    // _addItem(); // Add initial item
    _fetchRepairSteps().then((_) {
      _addItem(); // Add initial item after data is fetched
    });
  }

  // void _updateSelectedParts(
  //     int index, List<Map<String, dynamic>> selectedParts) {
  //   setState(() {
  //     if (_selectedParts.length > index) {
  //       _selectedParts[index] = selectedParts[index];
  //     } else {
  //       // กรณีที่รายการ _selectedParts ว่างหรือตำแหน่งนั้นอยู่นอกขอบเขต
  //       // คุณสามารถเพิ่มสมาชิกใหม่เข้าไปในรายการ _selectedParts ได้
  //       _selectedParts.add(selectedParts[index]);
  //     }
  //     print('_selectedParts updated at index $index: $selectedParts');
  //   });
  // }
  // void _updateSelectedParts(
  //     int index, List<Map<String, dynamic>> selectedParts) {
  //   setState(() {
  //     if (_selectedParts.length > index) {
  //       // Update the existing selected parts at the given index
  //       _selectedParts[index] = selectedParts;
  //     } else {
  //       // Add the entire List<Map<String, dynamic>> to _selectedParts
  //       _selectedParts.add(selectedParts);
  //     }
  //     print('_selectedParts updated at index $index: $selectedParts');
  //     // print(
  //     //     'Selected Parts at index $index: ${_selectedParts[index]}'); // Debugging
  //   });
  // }
  void _updateSelectedParts(
      int index, List<Map<String, dynamic>> selectedParts) {
    // ใช้ข้อมูลที่ได้รับจาก Partmain อัปเดต _selectedParts
    if (index < _selectedParts.length) {
      _selectedParts[index] = selectedParts;
    }
  }

  void _clearSelectedParts() {
    setState(() {
      _selectedParts.clear(); // Clear the list of selected parts
      print('Selected parts cleared');
      _quantities.clear(); // Clear the list of quantities
    });
  }

  // void _handleSelectedParts(
  //     int index, List<Map<String, dynamic>>? selectedParts) {
  //   setState(() {
  //     if (selectedParts != null) {
  //       _updateSelectedParts(index,
  //           selectedParts); // Update the selected parts for the specific index
  //     }
  //   });
  // }

  // void _updateQuantities(int index, int partIndex, int newQuantity) {
  //   setState(() {
  //     quantities[index][partIndex] = newQuantity;
  //     print(
  //         '_quantities updated at index $index, partIndex $partIndex: $newQuantity');
  //   });
  // }
  void _updateQuantities(int index, int partIndex, int newQuantity) {
    setState(() {
      // Ensure the index and partIndex are within bounds
      if (_quantities.length > index && _quantities[index].length > partIndex) {
        _quantities[index][partIndex] = newQuantity;
        print(
            '_quantities updated at index $index, partIndex $partIndex: $newQuantity');
      } else {
        // Handle out-of-bounds cases if necessary
        print('Index or partIndex out of bounds');
      }
    });
  }

  Future<void> _navigateToPartMain(BuildContext context, int index) async {
    final selectedPartsJson = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Partmain(index: index),
      ),
    );

    if (selectedPartsJson != null) {
      // ตรวจสอบว่า `selectedPartsJson` เป็น JSON ที่ถูกต้อง
      try {
        final List<dynamic> jsonList = jsonDecode(selectedPartsJson);
        final List<Map<String, dynamic>> selectedParts =
            jsonList.map((item) => item as Map<String, dynamic>).toList();

        setState(() {
          // ตรวจสอบว่า index อยู่ในช่วงที่ถูกต้อง
          if (index < _selectedParts.length) {
            setState(() {
              _selectedParts[index] = selectedParts;
            });
          } else {
            // เพิ่มความยืดหยุ่นในการจัดการกรณีที่ index เกินขอบเขต
            _selectedParts.add(selectedParts);
            print('Index out of range: $index');
          }
        });
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    }
  }

  void _addItem() {
    setState(() {
      _dropdownRepair.add(null);

      _items.add(_buildListItem(_items.length));
      // quantities.add([]);
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

  Future<void> _submitRepairProcess(int index) async {
    final url =
        Uri.parse('https://bodyworkandpaint.pantook.com/api/repair_processes');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'Quotation_ID': widget.quotationId,
        'licenseplate': licenseplate,
      }),
    );

    if (response.statusCode == 201) {
      print("Successfully submitted repair process");
    } else {
      print("Failed to submit repair process: ${response.reasonPhrase}");
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _submitRepairProcess(index);
    });
    if (index >= _dropdownRepair.length) {
      return Container(); // Handle invalid index appropriately
    }

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

          // Use ListView.builder to display selected parts
          if (index < _selectedParts.length && _selectedParts[index].isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _selectedParts[index].length,
                itemBuilder: (context, i) {
                  final part = _selectedParts[index][i];
                  final quantities =
                      _quantities.length > index ? _quantities[index] : [];

                  return Container(
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
                            'อะไหล่: ${part['Name'] ?? 'Unknown Part'}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (quantities.length > i &&
                                      quantities[i] > 0) {
                                    quantities[i]--;
                                    _updateQuantities(index, i, quantities[i]);
                                  }
                                });
                              },
                            ),
                            Text('${quantities[i]}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (quantities.length > i) {
                                    quantities[i]++;
                                    _updateQuantities(index, i, quantities[i]);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          else
            Center(
              child: Text('ไม่มีรายการอะไหล่'),
            ),

          Column(
            children: [Text('iiiiii')],
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                final selectedPartsJson = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Partmain(index: index),
                  ),
                );

                if (selectedPartsJson != null) {
                  try {
                    final List<dynamic> jsonList =
                        jsonDecode(selectedPartsJson);
                    final List<Map<String, dynamic>> selectedParts = jsonList
                        .map((item) => item as Map<String, dynamic>)
                        .toList();

                    setState(() {
                      if (index < _selectedParts.length) {
                        _selectedParts[index] = selectedParts;
                      } else {
                        _selectedParts.add(selectedParts);
                      }
                    });
                  } catch (e) {
                    print('Error decoding JSON: $e');
                  }
                }
                // final selectedParts = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Partmain(index: index),
                //   ),
                // );
                // _handleSelectedParts(index,
                // selectedParts); // Update or clear parts based on the result
                // if (selectedParts != null) {
                //   _updateSelectedParts(index,
                //       selectedParts); // Update the selected parts for the specific index
                // } else {
                //   _clearSelectedParts(); // Optional: Handle clearing of parts if needed
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

class Partmain extends StatefulWidget {
  final int index; // Add index parameter

  Partmain({required this.index});

  @override
  State<Partmain> createState() => _PartmainState();
}

class _PartmainState extends State<Partmain> {
  List<Map<String, dynamic>> _selectedParts = [];
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
                    Text('คงเหลือ: $quantity ชิ้น'),
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
              if (!_selectedParts.any((part) => part['Part_ID'] == partId)) {
                _selectedParts.add(selectedPart);
              }
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
              onPressed: () {
                // แปลง _selectedParts เป็น JSON
                final selectedPartsJson = jsonEncode(_selectedParts);

                // ส่ง JSON กลับไปยังหน้าจอหลัก
                Navigator.pop(context, selectedPartsJson);
              },
              child: Text('ยืนยัน'),
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.green,
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
