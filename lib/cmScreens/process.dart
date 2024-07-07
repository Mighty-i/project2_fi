import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
// import 'package:get/get.dart';
import 'package:project2_fi/navbar2.dart';

class Process extends StatelessWidget {
  const Process({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mainPr(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class mainPr extends StatefulWidget {
  // const mainPr({super.key});

  @override
  State<mainPr> createState() => _mainPrState();
}

class _mainPrState extends State<mainPr> {
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
            Text('จัดการกระบวนการซ่อม', style: TextStyle(fontSize: 26)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
              child: Text("ขั้นตอนการซ่อม"),
            ),
            // ListView()

            GFIconButton(
              padding: EdgeInsets.symmetric(horizontal: 180, vertical: 7),
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24.0),
                ),
              ),
              onPressed: () {},
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
