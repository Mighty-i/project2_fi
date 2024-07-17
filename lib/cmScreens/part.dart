import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/process2.dart';

class Mypart extends StatelessWidget {
  const Mypart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic List Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Partmain(),
    );
  }
}

class Partmain extends StatefulWidget {
  @override
  State<Partmain> createState() => _PartmainState();
}

class _PartmainState extends State<Partmain> {
  Widget partListview(BuildContext context) {
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
              Text('กันชนหน้า'),
              SizedBox(
                width: 20,
              ),
              Text('จำนวน: 10 ชิ้น'),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Process()));
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
                children: List.generate(10, (index) => partListview(context))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
