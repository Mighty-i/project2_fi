import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class end extends StatefulWidget {
  final int processId;
  final int userId;

  end({
    required this.processId,
    required this.userId,
  });
  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<end> {
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

  Future<void> _compressAndAddImage(XFile pickedFile) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      pickedFile.path + '_compressed.jpg',
      quality: 50, // Adjust quality to reduce size
    );

    if (compressedImage != null) {
      setState(() {
        _images.add(XFile(compressedImage.path));
      });
    }
  }

  Future<void> _EuploadImages(int userId, int processId) async {
    try {
      var uri = Uri.parse(
          'https://bodyworkandpaint.pantook.com/api/endupload-images'); // แก้ไขเป็น URL ของ API ของคุณ
      var request = http.MultipartRequest('POST', uri);

      // เพิ่มรูปภาพแต่ละรูปในคำขอ
      for (int i = 0; i < _images.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('image${i + 1}', _images[i].path),
        );
      }

      // เพิ่มข้อมูลเพิ่มเติมในคำขอ เช่น Process_ID และ User_ID
      request.fields['Process_ID'] =
          processId.toString(); // แก้ไขเป็น ID ที่ถูกต้อง
      request.fields['User_ID'] = userId.toString(); // แก้ไขเป็น ID ที่ถูกต้อง

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        // สามารถทำอะไรบางอย่างหลังจากอัปโหลดสำเร็จ
      } else {
        print('Failed to upload images');
        var responseData = await response.stream.bytesToString();
        print('Failed to upload images. Status code: ${response.statusCode}');
        print('Response: $responseData');
      }
    } catch (e) {
      print('Error uploading images: $e');
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
              onPressed: () async {
                int userId = widget.userId;
                int processId = widget.processId;
                // Handle confirmation logic
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Statusrepair()));
                await _EuploadImages(userId, processId);
                Navigator.pop(context);
                Navigator.pop(context);
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
