import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project2_fi/cmScreens/dashboard.dart';
import 'package:project2_fi/cmScreens/history.dart';

void main() {
  runApp(apppage());
}

class apppage extends StatelessWidget {
  const apppage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Navbar(),
    );
  }
}

// class Navbar extends StatefulWidget {
//   const Navbar({super.key});

//   @override
//   State<Navbar> createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> {
//   late List<Widget> menu;
//   int index = 0;

//   @override
//   void initState() {
//     super.initState();
//     menu = [
//       dashboard(),
//       history(),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GFAppBar(
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('สมชาย ใจดี', style: TextStyle(fontSize: 20)),
//             Text('ตำแหน่ง: ช่างสี', style: TextStyle(fontSize: 20)),
//             GFAvatar(
//               size: GFSize.SMALL,
//             )
//           ],
//         ),
//       ),
//       body: menu[index],
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavigationBar(
//           currentIndex: index,
//           onTap: (value) {
//             setState(() {
//               index = value;
//             });
//           },
//           items: [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.car_repair_outlined), label: 'รายการซ่อม'),
//             BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History')
//           ]),
//     );
//   }
// }
class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    dashboard(),
    history(),
  ];

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
            Text('สมชาย ใจดี', style: TextStyle(fontSize: 20)),
            Text('ตำแหน่ง: ช่างสี', style: TextStyle(fontSize: 20)),
            GFAvatar(
              size: GFSize.SMALL,
            )
          ],
        ),
      ),
      body: Center(
          child: _pages.elementAt(_selectedIndex), _buildbottomNavigationBar()),
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
          // child: BottomNavigationBar(
          //   currentIndex: _selectedIndex,
          //   onTap: _onItemTapped,
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   type: BottomNavigationBarType.fixed,
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.car_repair_outlined,
          //           color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
          //       label: 'รายการซ่อม',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.history,
          //           color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
          //       label: 'รายการที่ดำเนินการอยู่',
          //     ),
          //   ],
          //   selectedItemColor: Colors.blue,
          //   unselectedItemColor: Colors.grey,
          //   selectedLabelStyle: TextStyle(color: Colors.blue),
          //   unselectedLabelStyle: TextStyle(color: Colors.grey),
          // ),
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
