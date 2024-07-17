import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';

class MYstcom extends StatelessWidget {
  const MYstcom({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: commain(),
    );
  }
}

class commain extends StatefulWidget {
  const commain({super.key});

  @override
  State<commain> createState() => _commainState();
}

class _commainState extends State<commain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        // leading: GFIconButton(
        //   color: Colors.blue,
        //   icon: Icon(
        //     Icons.arrow_back_rounded,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'ตรวจสอบสถานะการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              height: 100,
              child: Center(
                child: Text(
                  'ขั้นตอนที่ 2.โป๊ว',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('ก่อนทำงาน'),
                  ],
                ),
                Column(
                  children: [
                    Text('หลังทำงาน'),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ยืนยัน'),
            ),
          ],
        ),
      ),
    );
  }
}
