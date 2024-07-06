import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class Part extends StatefulWidget {
  const Part({super.key});

  @override
  State<Part> createState() => _PartState();
}

class _PartState extends State<Part> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        leading: GFIconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {},
        ),
        title: Text("รายการอะไหล่"),
      ),
    );
  }
}
