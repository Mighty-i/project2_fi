import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Start extends StatefulWidget {
  final int processId;
  final int userId;

  Start({
    required this.processId,
    required this.userId,
  });
  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<Start> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        // setState(() {
        // _images.add(pickedFile);
        // });
        await _compressAndAddImage(pickedFile);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _compressAndAddImage(XFile pickedFile) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      '${pickedFile.path}_compressed.jpg',
      quality: 50, // Adjust quality to reduce size
    );
    print('path imageStart: ${compressedImage!.path}');

    if (compressedImage != null) {
      setState(() {
        _images.add(XFile(compressedImage.path));
      });
    }
  }

  Future<void> _uploadImages(int userId, int processId) async {
    try {
      var uri = Uri.parse(
          'https://bodyworkandpaint.pantook.com/api/startupload-images'); // แก้ไขเป็น URL ของ API ของคุณ
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'เริ่มงาน',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        // color: Colors.black,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const Text(
                'เพิ่มภาพ 3 รูป',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true, // Always show the scrollbar
                thickness: 9.0, // Thickness of the scrollbar
                radius: const Radius.circular(10), // Rounded corners
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2 / 2,
                    mainAxisSpacing: 10,
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
                              backgroundColor: Colors.white,
                              title: const Text(
                                'ลบรูปภาพ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text('แน่ใจใช่ไหม'),
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    size: GFSize.SMALL,
                                  ),
                                ),
                                IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    size: GFSize.LARGE,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueGrey, // Border color
                                  width: 8.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    12.0), // Rounded corners
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.file(
                                  File(_images[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: const Text(
                  'ถ่ายรูป',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            // const SizedBox(height: 10),
            if (_images.length >= 3)
              ElevatedButton(
                onPressed: () async {
                  int userId = widget.userId;
                  int processId = widget.processId;
                  // Handle confirmation logic
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Statusrepair()));

                  Navigator.pop(context, 'job_started');
                  await _uploadImages(userId, processId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                ),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
