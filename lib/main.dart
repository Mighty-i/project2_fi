import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  int _failedLoginAttempts = 0; // ตัวแปรเก็บจำนวนครั้งที่ล็อกอินผิด

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
        setState(() {
          _failedLoginAttempts = 0; // รีเซ็ตจำนวนครั้งที่ล็อกอินผิด
        });
        final user = responseData['user'];
        final roleName = responseData['role_name'];
        final roleId = user['Role_ID'];
        // final Image = user['image'];

        final logindata = await SharedPreferences.getInstance();
        await logindata.setInt('user_id', user['User_ID']);
        await logindata.setString('username', user['username']);
        await logindata.setString('image', user['image']);

        if (roleId == 7) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => apppage(
                username: user['name'],
                // userlogin: user['username'],
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
                // userlogin: user['username'],
                roleName: roleName,
                roleId: roleId,
                userId: user['User_ID'],
              ), // Navigate to default page for other roles
            ),
          );
        }
      } else {
        setState(() {
          _failedLoginAttempts++; // เพิ่มจำนวนครั้งที่ล็อกอินผิด
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ชื่อผู้ใช้หรือเบอร์โทรหรือรหัสผ่านผิดพลาด'),
          ),
        );
      }
    } else {
      setState(() {
        _failedLoginAttempts++; // เพิ่มจำนวนครั้งที่ล็อกอินผิด
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เข้าสู่ระบบใหม่อีกครั้ง'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(50),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'เข้าสู่ระบบ',
              style: TextStyle(fontSize: 30),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'ป้อนชื่อผู้ใช้ หรือ เบอร์โทร',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                controller: _passwordController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: 'ป้อนรหัสผ่าน',
                ),
                obscureText: true,
              ),
            ),
            if (_failedLoginAttempts >= 2)
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()));
                },
                child: const Text('ลืมรหัสผ่านหรือไม่'),
              ),
            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextButton(
                onPressed: _login,
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: const Size.fromWidth(250)),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameOrPhoneController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _resetPassword() async {
    const url = 'https://bodyworkandpaint.pantook.com/api/reset-password';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': _usernameOrPhoneController.text,
        'new_password': _newPasswordController.text,
        'new_password_confirmation': _confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful.'),
        ),
      );
      // นำผู้ใช้ไปที่หน้าเข้าสู่ระบบ
      Navigator.pop(context);
    } else {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message'] ?? 'An error occurred.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        title: const Text('รีเซ็ต รหัสผ่าน'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        height: 850,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                const Text(
                  'ชื่อผู้ใช้ หรือ เบอร์โทร',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _usernameOrPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อผู้ใช้ หรือ เบอร์โทร',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'รหัสผ่านใหม่',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'รหัสผ่านใหม่',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'ยืนยันรหัสผ่านใหม่',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 26.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _resetPassword,
                  child: const Text(
                    'บันทึกรหัสผ่านใหม่',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
