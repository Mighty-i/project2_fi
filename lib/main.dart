import 'package:flutter/material.dart';
import 'package:project2_fi/navbar.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Loginpage(),
    );
  }
}

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    const url = 'https://bodyworkandpaint.pantook.com/api/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['message'] == 'Login successful') {
        final user = responseData['user'];
        final roleName = responseData['role_name'];
        final roleId = user['Role_ID'];
        final userId = user['User_ID'];

        if (roleId == 7) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => apppage(
                username: user['name'],
                roleName: roleName,
                roleId: roleId,
              ), // Navigate to specific page for Role_ID 7
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => apppageM(
                username: user['name'],
                roleName: roleName,
                roleId: roleId,
                userId: user['User_ID'],
              ), // Navigate to default page for other roles
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username or password'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to login. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(50),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'เข้าสู่ระบบ',
              style: TextStyle(fontSize: 30),
            ),
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: TextField(
                controller: _usernameController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'ป้อนชื่อผู้ใช้',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                controller: _passwordController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'ป้อนรหัสผ่าน',
                ),
                obscureText: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextButton(
                onPressed: _login,
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: Size.fromWidth(250)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
