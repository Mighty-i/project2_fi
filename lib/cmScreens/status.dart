import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar2.dart';
// import 'package:project2_fi/cmScreens/stcomfi.dart';

class MyStatus extends StatelessWidget {
  const MyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: statusmain(),
    );
  }
}

class statusmain extends StatefulWidget {
  @override
  State<statusmain> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<statusmain> {
  bool isConfirmed = false;

  void updateConfirmationStatus(bool status) {
    setState(() {
      isConfirmed = status;
    });
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
              'สถานะการซ่อม',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildVehicleInfo(),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Text(
                "ขั้นตอน",
                style: TextStyle(fontSize: 20),
              ),
            ),
            // Expanded(
            //     child: ListView(
            //   padding: EdgeInsets.all(16.0),
            // ))
            _step(context, isConfirmed, updateConfirmationStatus),
          ],
        ),
      ),
    );
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
              'ทะเบียนรถ\n1กด6444',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 20,
            ),
            Text("Toyota Corolla 2018",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text('กำหนดเสร็จสิ้น: 15 ม.ค. 2567'),
      ],
    ),
  );
}

Widget _step(BuildContext context, bool isConfirmed,
    Function(bool) updateConfirmationStatus) {
  return Expanded(
    child: ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: _container1(),
            );
          case 1:
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child:
                  _container2(context, isConfirmed, updateConfirmationStatus),
            );
          case 2:
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: _container3(),
            );
          case 3:
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              child: _container4(),
            );
          default:
            return Container();
        }
      },
    ),
  );
}

Widget _container1() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // SizedBox(
        //   width: 1,
        // ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1.ถอด',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'สถานะ: เสร็จสิ้น',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
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
      ],
    ),
  );
}

Widget _container2(BuildContext context, bool isConfirmed,
    Function(bool) updateConfirmationStatus) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2.โป๊ว',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'สถานะ: เสร็จสิ้น',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (!isConfirmed) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => commain(
                          onConfirm: updateConfirmationStatus,
                        ),
                      ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isConfirmed ? Colors.teal : Colors.yellow[400],
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
              child: Text(isConfirmed ? 'ยืนยัน' : 'ตรวจสอบ'),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _container3() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3.พ่นพื้น',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'สถานะ: รอดำเนินการ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
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
              child: Text('ตรวจสอบ'),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _container4() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4.พ่นจริง',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'สถานะ: รอดำเนินการ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
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
              child: Text('ตรวจสอบ'),
            ),
          ],
        ),
      ],
    ),
  );
}

class commain extends StatefulWidget {
  final Function(bool) onConfirm;

  const commain({required this.onConfirm, super.key});
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
              onPressed: () {
                widget.onConfirm(true);
                Navigator.pop(context);
              },
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
