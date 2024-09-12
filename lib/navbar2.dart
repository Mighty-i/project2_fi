import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/dashboard.dart';
import 'package:project2_fi/cmScreens/OngoingList.dart';
// import 'package:project2_fi/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:project2_fi/profile.dart';

class apppage extends StatelessWidget {
  final String username;
  // final String userlogin;
  final String roleName;
  final int roleId;

  const apppage({
    super.key,
    required this.username,
    required this.roleName,
    required this.roleId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Navbar(username: username, roleName: roleName, roleId: roleId),
    );
  }
}

class Navbar extends StatefulWidget {
  final String username;
  final String roleName;
  final int roleId;

  Navbar(
      {required this.username, required this.roleName, required this.roleId});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  // static List<Widget> _pages = <Widget>[
  //   dashboard(),
  //   history(),
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _pages = <Widget>[
      dashboard(
        roleId: widget.roleId,
        username: widget.username,
        roleName: widget.roleName,
      ),
      history(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget.username, style: TextStyle(fontSize: 20)),
            // Text('ตำแหน่ง: ${widget.roleName}', style: TextStyle(fontSize: 20)),
            // GFAvatar(
            //   size: GFSize.SMALL,
            // ),
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   onPressed: () {
            //     _logout(context);
            //   },
            // ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.account_circle, size: 30),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Myprofile(
        username: widget.username,
        roleName: widget.roleName,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 2,
                )
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_repair_outlined,
                      color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
                  label: 'รายการซ่อม',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history,
                      color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
                  label: 'รายการที่ดำเนินการอยู่',
                ),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(color: Colors.blue),
              unselectedLabelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _logout(BuildContext context) async {
  //   final url = 'https://bodyworkandpaint.pantook.com/api/logout';
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // Add necessary headers for authentication, e.g., token
  //       // 'Authorization': 'Bearer YOUR_TOKEN',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // Handle successful logout
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Loginpage()), // Navigate back to login page
  //     );
  //   } else {
  //     // Handle logout failure
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to logout. Please try again.'),
  //       ),
  //     );
  //   }
  // }
}

  // Widget _buildbottomNavigationBar() {
  //   return Container(
  //     child: BottomNavigationBar(
  //       currentIndex: _selectedIndex,
  //       onTap: _onItemTapped,
  //       backgroundColor: Colors.transparent,
  //       elevation: 0,
  //       type: BottomNavigationBarType.fixed,
  //       items: [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.car_repair_outlined,
  //               color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
  //           label: 'รายการซ่อม',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.history,
  //               color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
  //           label: 'รายการที่ดำเนินการอยู่',
  //         ),
  //       ],
  //       selectedItemColor: Colors.blue,
  //       unselectedItemColor: Colors.grey,
  //       selectedLabelStyle: TextStyle(color: Colors.blue),
  //       unselectedLabelStyle: TextStyle(color: Colors.grey),
  //     ),
  //   );
  // }

