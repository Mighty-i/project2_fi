import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar2.dart';

class Process extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: DynamicListPage(),
    );
  }
}

class DynamicListPage extends StatefulWidget {
  @override
  _DynamicListPageState createState() => _DynamicListPageState();
}

class _DynamicListPageState extends State<DynamicListPage> {
  List<Widget> _items = [];

  @override
  void initState() {
    super.initState();
    _addItem(); // Add initial item
  }

  void _addItem() {
    setState(() {
      _items.add(_buildListItem());
    });
  }

  Widget _buildListItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 10,
        //     spreadRadius: 5,
        //   ),
        // ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GFDropdown(
                  items: [
                    'ขั้นตอนการซ่อม 1',
                    'ขั้นตอนการซ่อม 2',
                    'ขั้นตอนการซ่อม 3'
                  ]
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) {},
                  hint: Text('ขั้นตอนการซ่อม'),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GFDropdown(
                  items: ['ช่าง 1', 'ช่าง 2', 'ช่าง 3']
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) {},
                  hint: Text('ช่าง'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GFDropdown(
                  items: ['ชื่อ 1', 'ชื่อ 2', 'ชื่อ 3']
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) {},
                  hint: Text('ชื่อ'),
                ),
              ),
            ],
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
          for (int i = 0; i < 3; i++)
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
                      'อะไหล่: กันชนหน้า',
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
          SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _addItem,
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
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 10,
        //     spreadRadius: 5,
        //   ),
        // ],
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
                "1กต6777",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Toyota Corolla 2018"),
          // RichText(text: Text("รายละเอียด"))
          const SizedBox(height: 8),
          const Text(
            'รายละเอียด: มีรอยด่านข้างกันชนซ้าย',
            style: TextStyle(fontSize: 14),
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
                  builder: (context) => apppage(),
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
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
              child: Text("ขั้นตอนการซ่อม"),
            ),
            ..._items,
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
