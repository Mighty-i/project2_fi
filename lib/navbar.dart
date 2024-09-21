import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/mScreens/dashboard.dart';
import 'package:project2_fi/mScreens/history.dart';

import 'package:project2_fi/profile.dart';

class apppageM extends StatelessWidget {
  final String username;
  // final String userlogin;
  final String roleName;
  final int roleId;
  final int userId;

  const apppageM({
    super.key,
    required this.username,
    required this.roleName,
    required this.roleId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Navbar(
        username: username,
        roleName: roleName,
        roleId: roleId,
        userId: userId,
      ),
    );
  }
}

class Navbar extends StatefulWidget {
  final String username;
  final String roleName;
  final int roleId;
  final int userId;

  Navbar(
      {required this.username,
      required this.roleName,
      required this.roleId,
      required this.userId});

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
        userId: widget.userId,
      ),
      History(
        roleId: widget.roleId,
        username: widget.username,
        roleName: widget.roleName,
        userId: widget.userId,
      ),
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
            Text(widget.username.toString(),
                style: const TextStyle(fontSize: 20)),
            // Text(widget.username, style: TextStyle(fontSize: 20)),
            // Text('ตำแหน่ง: ${widget.roleName}', style: TextStyle(fontSize: 20)),
            // const GFAvatar(
            //   size: GFSize.SMALL,
            // ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.account_circle, size: 30),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the drawer
                },
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   onPressed: () {
            //     _logout(context);
            //   },
            // ),
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
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              boxShadow: const [
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
                  label: 'ประวัติ',
                ),
              ],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(color: Colors.blue),
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildbottomNavigationBar() {
    return Container(
      color: Colors.white,
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
        selectedLabelStyle: const TextStyle(color: Colors.blue),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
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
