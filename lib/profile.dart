import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project2_fi/main.dart';

class Myprofile extends StatelessWidget {
  final String username;
  final String roleName;
  const Myprofile({
    super.key,
    required this.username,
    required this.roleName,
  });

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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60.0, // ขนาดของรูปภาพ
                              backgroundImage: AssetImage(
                                  'images/profile1.jpg'), // เส้นทางไปยังรูปภาพ
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
                          username,
                          style: TextStyle(fontSize: 26),
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
                          roleName,
                          style: TextStyle(fontSize: 20),
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
                      padding: EdgeInsets.all(14.0),
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
                          onPressed: () {},
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
                          onPressed: () {},
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
                      padding: EdgeInsets.all(16.0),
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
    // Handle successful logout
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
        (Route<dynamic> route) => false // Navigate back to login page
        );
  } else {
    // Handle logout failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('แก้ไขชื่อผู้ใช้'),
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
