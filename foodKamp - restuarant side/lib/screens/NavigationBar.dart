import 'package:canteen_food_ordering_app/screens/ExpiredOrders.dart';
import 'package:canteen_food_ordering_app/screens/cartPage.dart';
import 'package:canteen_food_ordering_app/screens/orderbook.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavigationBarPage extends StatefulWidget {
  int selectedIndex;
  NavigationBarPage({@required this.selectedIndex});
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  final List<Widget> _children = [
    OrderBook(),
    ExpiredOrders(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[widget.selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(255, 63, 111, 1),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color.fromRGBO(255, 63, 111, 1),
        height: 50,
        index: widget.selectedIndex,
        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
        items: <Widget>[
          Column(
            children: [
              Icon(
                Icons.assignment_turned_in_sharp,
                size: 26,
                color: Colors.white,
              ),
              // Text('Delivered')
            ],
          ),
          Icon(
            Icons.assignment_late,
            size: 26,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}


// class NavigationBarPage extends StatefulWidget {
//   @override
//   _NavigationBarPageState createState() => _NavigationBarPageState();
// }
//
// class _NavigationBarPageState extends State<NavigationBarPage> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [OrderBook(),ExpiredOrders()];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: _children[_currentIndex], // newy
//       bottomNavigationBar: BottomNavigationBar(
//         iconSize: 38.0,
//         elevation: 5,
//         selectedItemColor: Colors.black,
//
//         onTap: onTabTapped, // new
//         currentIndex: _currentIndex, // new
//         backgroundColor: Color.fromRGBO(255, 63, 111, 1),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.restaurant_menu_rounded),
//             title: Text('Menu'),
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               title: Text('Cart')
//           )
//         ],
//       ),
//     );
//
//   }
//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
// }