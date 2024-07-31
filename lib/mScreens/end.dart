import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:project2_fi/mScreens/StatusRepair.dart';

class end extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TakePicturePage(),
    );
  }
}

class TakePicturePage extends StatefulWidget {
  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _images.add(pickedFile);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'ปิดงาน',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'เพิ่มภาพ 3 รูป',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('ลบรูปภาพ'),
                          content: Text('แน่ใจใช่ไหม'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        child: Center(
                          child: Image.file(
                            File(_images[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          if (_images.length < 3)
            ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text(
                'ถ่ายรูป',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(height: 20),
          if (_images.length >= 3)
            ElevatedButton(
              onPressed: () {
                // Handle confirmation logic
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Statusrepair()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
