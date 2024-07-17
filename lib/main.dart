// import 'package:flutter/material.dart';
// // import 'package:getwidget/getwidget.dart';
// import 'package:project2_fi/navbar2.dart';

// void main() {
//   runApp(const MainPage());
// }

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Loginpage(),
//     );
//   }
// }

// class Loginpage extends StatefulWidget {
//   const Loginpage({super.key});

//   @override
//   State<Loginpage> createState() => _LoginpageState();
// }

// class _LoginpageState extends State<Loginpage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(),
//       body: Container(
//         padding: EdgeInsets.all(50),
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'เข้าสู่ระบบ',
//               style: TextStyle(fontSize: 30),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20, bottom: 20),
//               child: TextField(
//                 style: TextStyle(fontSize: 20),
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'ป้อนชื่อผู้ใช้',
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20, bottom: 20),
//               child: TextField(
//                 style: TextStyle(fontSize: 20),
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'ป้อนรหัสผ่าน',
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 20, bottom: 20),
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Navbar(),
//                       ));
//                 },
//                 child: Text(
//                   'LOGIN',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: TextButton.styleFrom(backgroundColor: Colors.blue),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/navbar2.dart';
import 'package:project2_fi/mScreens/dashboard.dart';

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
      home: Loginpage(),
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
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextField(
                controller: _usernameController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                  hintText: 'ป้อนรหัสผ่าน',
                ),
                obscureText: true,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: TextButton(
                onPressed: () {
                  if (_usernameController.text == 'หน' &&
                      _passwordController.text == '1') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => apppage(),
                        ));
                  } else if (_usernameController.text == 'ช' &&
                      _passwordController.text == '2') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MYdashboard(),
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid username or password'),
                      ),
                    );
                  }
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
