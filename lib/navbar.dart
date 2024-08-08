import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/mScreens/dashboard.dart';
import 'package:project2_fi/mScreens/history.dart';
import 'package:project2_fi/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class apppageM extends StatelessWidget {
  final String username;
  final String roleName;
  final int roleId;

  const apppageM(
      {super.key,
      required this.username,
      required this.roleName,
      required this.roleId});

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

  // static List<Widget> _pages = <Widget>[
  //   MYdashboard(
  //     roleId: widget.roleId,
  //     username: widget.username,
  //     roleName: widget.roleName,
  //   ),
  //   History(),
  // ];
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      MYdashboard(
        roleId: widget.roleId,
        username: widget.username,
        roleName: widget.roleName,
      ),
      History(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.username, style: TextStyle(fontSize: 20)),
            Text('ตำแหน่ง: ${widget.roleName}', style: TextStyle(fontSize: 20)),
            GFAvatar(
              size: GFSize.SMALL,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
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
    );
  }

  Widget _buildbottomNavigationBar() {
    return Container(
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Loginpage()), // Navigate back to login page
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

//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0), // Adjust padding as needed
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(30.0),
//           child: Container(
//             color: Colors.transparent,
//             child: BottomNavigationBar(
//               currentIndex: _selectedIndex,
//               onTap: _onItemTapped,
//               backgroundColor:
//                   Colors.white.withOpacity(0.8), // Set to semi-transparent
//               elevation: 0,
//               type: BottomNavigationBarType.fixed,
//               items: [
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.car_repair_outlined,
//                       color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
//                   label: 'รายการซ่อม',
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.history,
//                       color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
//                   label: 'รายการที่ดำเนินการอยู่',
//                 ),
//               ],
//               selectedItemColor: Colors.blue,
//               unselectedItemColor: Colors.grey,
//               selectedLabelStyle: TextStyle(color: Colors.blue),
//               unselectedLabelStyle: TextStyle(color: Colors.grey),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
