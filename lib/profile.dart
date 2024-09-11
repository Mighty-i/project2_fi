import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project2_fi/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';

class Myprofile extends StatefulWidget {
  final String username;
  final String roleName;
  const Myprofile({
    super.key,
    required this.username,
    required this.roleName,
  });

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  String? image;

  @override
  void initState() {
    super.initState();
    _loadimage(); // Load username from SharedPreferences
  }

  // ฟังก์ชันสำหรับดึงข้อมูลจาก SharedPreferences
  Future<void> _loadimage() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      image = logindata.getString('image') ?? ''; // ดึงค่าชื่อผู้ใช้
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              // padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 280,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60.0, // ขนาดของรูปภาพ
                              backgroundImage: NetworkImage(
                                  'https://bodyworkandpaint.pantook.com/storage/$image'),
                              // เส้นทางไปยังรูปภาพ
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          widget.username,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'ตำแหน่ง ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          widget.roleName,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(20.0),
                        // boxShadow: const [
                        //   BoxShadow(
                        //     color: Colors.black12,
                        //     blurRadius: 10,
                        //     spreadRadius: 5,
                        //   )
                        // ],
                      ),
                      child: const Text(
                        'แก้ไขข้อมูล',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 28,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Editusername(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person, color: Colors.blue),
                          label: const Text(
                            'ชื่อผู้ใช้',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditPassword(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.lock, color: Colors.blue),
                          label: const Text(
                            'รหัสผ่าน',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            final result = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ),
                            );
                            if (result == true) {
                              // Update the image or any other state
                              _loadimage();
                            }
                          },
                          icon: const Icon(Icons.photo, color: Colors.blue),
                          label: const Text(
                            'รูปโปรไฟล์',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Background color
                          ),
                          onPressed: () {
                            _logout(
                                context); // Make sure to define _logout method
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  final url = 'https://bodyworkandpaint.pantook.com/api/logout';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      // Add necessary headers for authentication, e.g., token
      // 'Authorization': 'Bearer YOUR_TOKEN',
    },
  );

  if (response.statusCode == 200) {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    await logindata.clear(); // ลบข้อมูลทั้งหมดที่เก็บไว้ใน SharedPreferences
    // Handle successful logout
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginpage()),
        (Route<dynamic> route) => false // Navigate back to login page
        );
  } else {
    // Handle logout failure
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to logout. Please try again.'),
      ),
    );
  }
}

class Editusername extends StatefulWidget {
  const Editusername({super.key});

  @override
  State<Editusername> createState() => _EditusernameState();
}

class _EditusernameState extends State<Editusername> {
  String? username = '';
  int? userID;
  String? new_username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username from SharedPreferences
  }

  // ฟังก์ชันสำหรับดึงข้อมูลจาก SharedPreferences
  Future<void> _loadUsername() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? ''; // ดึงค่าชื่อผู้ใช้
      userID = logindata.getInt('user_id');
    });
  }

  Future<void> _updateUsername() async {
    // URL ของ API ที่ใช้สำหรับแก้ไขชื่อผู้ใช้
    final url =
        'https://bodyworkandpaint.pantook.com/api/update-usernameMobile';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'User_ID': userID, // ดึงค่า User_ID จาก SharedPreferences
          'new_username': new_username, // ส่งชื่อผู้ใช้ใหม่
        }),
      );

      if (response.statusCode == 200) {
        // ถ้าอัปเดตสำเร็จ ให้เก็บชื่อผู้ใช้ใหม่ใน SharedPreferences
        SharedPreferences logindata = await SharedPreferences.getInstance();

        await logindata.remove('username');

        await logindata.setString('username', new_username!);

        setState(() {
          Navigator.pop(context);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('อัปเดตชื่อผู้ใช้เรียบร้อย')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถอัปเดตชื่อผู้ใช้ได้')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        title: const Text('แก้ไขชื่อผู้ใช้'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ชื่อผู้ใช้เดิม',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  username != '' ? username! : 'ไม่มีชื่อผู้ใช้',
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            // อาจจะมี TextField ให้แก้ไขชื่อผู้ใช้ที่นี่
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'แก้ไขชื่อผู้ใช้',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    new_username = value; // อัปเดตค่าชื่อผู้ใช้ใหม่ในตัวแปร
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                await _updateUsername();
                // อัปเดตชื่อผู้ใช้ใหม่ใน SharedPreferences
                SharedPreferences logindata =
                    await SharedPreferences.getInstance();
                await logindata.setString('username', username!);

                // ทำสิ่งที่ต้องการเมื่อแก้ไขชื่อผู้ใช้เสร็จ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('อัปเดตชื่อผู้ใช้เรียบร้อย')),
                );
              },
              child: const Text(
                'บันทึก',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  int? userID;

  @override
  void initState() {
    super.initState();
    _loadUser_ID(); // Load username from SharedPreferences
  }

  Future<void> _loadUser_ID() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      userID = logindata.getInt('user_id'); // ดึงค่าชื่อผู้ใช้
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      final url =
          'https://bodyworkandpaint.pantook.com/api/update-passwordMobile';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'User_ID': userID,
          'current_password': _currentPasswordController.text,
          'new_password': _newPasswordController.text,
          'confirm_password': _confirmPasswordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        await _logout(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        title: const Text('แก้ไขรหัสผ่าน'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16.0),
              const Text(
                'รหัสผ่านเดิม',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              // ช่องกรอกรหัสผ่านเดิม
              Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _currentPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'รหัสผ่านเดิม',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านเดิม';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'รหัสผ่านใหม่',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              // ช่องกรอกรหัสผ่านใหม่
              Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'รหัสผ่านใหม่',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่านใหม่';
                    }
                    if (value.length < 6) {
                      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              // ช่องกรอกรหัสผ่านยืนยัน
              Container(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'ยืนยันรหัสผ่านใหม่',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณายืนยันรหัสผ่าน';
                    }
                    if (value != _newPasswordController.text) {
                      return 'รหัสผ่านใหม่ไม่ตรงกัน';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _updatePassword,
                child: const Text(
                  'บันทึกรหัสผ่านใหม่',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  int? userID;

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username from SharedPreferences
  }

  // ฟังก์ชันสำหรับดึงข้อมูลจาก SharedPreferences
  Future<void> _loadUsername() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      userID = logindata.getInt('user_id');
    });
  }

  Future<void> _pickImagegallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _pickImagecamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
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
        _selectedImage = XFile(compressedImage.path);
      });
    }
  }

  Future<void> updateImagesprofile() async {
    try {
      var uri = Uri.parse(
          'https://bodyworkandpaint.pantook.com/api/update-profile'); // แก้ไขเป็น URL ของ API ของคุณ
      var request = http.MultipartRequest('POST', uri);

      // เพิ่มรูปภาพแต่ละรูปในคำขอ

      request.files.add(
        await http.MultipartFile.fromPath(
            'profile_picture', _selectedImage!.path),
      );

      request.fields['User_ID'] = userID.toString(); // แก้ไขเป็น ID ที่ถูกต้อง

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        String imagePath = jsonResponse['data']['image'];

        SharedPreferences logindata = await SharedPreferences.getInstance();
        await logindata.remove('image');
        await logindata.setString('image', imagePath);
        print(imagePath);

        setState(() async {
          Navigator.pop(context, true);
        });

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
        title: const Text('แก้ไขรูปโปรไฟล์'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Center(
                child: _selectedImage == null
                    ? const Text('No images selected.')
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: _selectedImage != null ? 1 : 0,
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                              _selectedImage = null;
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
                                          color:
                                              Colors.blueGrey, // Border color
                                          width: 8.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12.0), // Rounded corners
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: Image.file(
                                          File(_selectedImage!.path),
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
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 23),
                  ),
                  onPressed: _pickImagegallery,
                  icon: const Icon(
                    Icons.file_open,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'เลือกรูป',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 23),
                  ),
                  onPressed: _pickImagecamera,
                  icon: const Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'ถ่ายรูป',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 160, vertical: 23),
              ),
              onPressed: updateImagesprofile,
              child: const Text(
                'ยืนยัน',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
