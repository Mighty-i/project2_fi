import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

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
  const mainPr({super.key});

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('จัดการกระบวนการซ่อม', style: TextStyle(fontSize: 26)),
          ],
        ),
      ),
    );
  }
}
