import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MYdashboard extends StatelessWidget {
  const MYdashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: mainM(),
    );
  }
}

class mainM extends StatefulWidget {
  const mainM({super.key});

  @override
  State<mainM> createState() => _mainMState();
}

class _mainMState extends State<mainM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('สมชาย ใจดี', style: TextStyle(fontSize: 20)),
            Text('ตำแหน่ง: ช่างสี', style: TextStyle(fontSize: 20)),
            GFAvatar(
              size: GFSize.SMALL,
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
              child: Text(
                'รายการซ่อม',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10.0),
                children: List.generate(10, (index) => buildListItem(context))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildListItem(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.0),
    padding: EdgeInsets.all(10.0),
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
                'ทะเบียนรถ\n1กด6444',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'สถานะ\nรอดำเนินการ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                ),
                child: Text(
                  'รับงาน',
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
