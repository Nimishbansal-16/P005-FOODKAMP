import 'package:canteen_food_ordering_app/screens/cartPage.dart';
import 'package:canteen_food_ordering_app/screens/menu.dart';
import 'package:canteen_food_ordering_app/screens/profilePage.dart';
import 'package:canteen_food_ordering_app/screens/user_dashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavBar2 extends StatefulWidget {
  int selectedIndex;
  String restaurantID;
  NavBar2({@required this.selectedIndex, this.restaurantID});
  @override
  _NavBar2State createState() => _NavBar2State();
}

class _NavBar2State extends State<NavBar2> {
  final List<Widget> _children = [
    // HomePage(restaurantID2: restaurantID),
    HomePage(),

    CartPage(),
  ];

  // static get restaurantID => restaurantID;
  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      extendBody: true,
      body: _children[widget.selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.brown[900],
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.brown[900],
        height: 50,
        index: widget.selectedIndex,

        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
            // widget.restaurantID= restaurantID;
          });
        },
        items: <Widget>[

          Icon(
            Icons.menu,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.add_shopping_cart,
            size: 26,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
