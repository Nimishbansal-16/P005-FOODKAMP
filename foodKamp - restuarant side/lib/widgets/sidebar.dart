import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/screens/NavigationBar.dart';
import 'package:canteen_food_ordering_app/screens/adminHome.dart';
import 'package:canteen_food_ordering_app/screens/admindashboard.dart';
import 'package:canteen_food_ordering_app/screens/orderbook.dart';
import 'package:canteen_food_ordering_app/screens/profile.dart';
import 'package:canteen_food_ordering_app/screens/tandc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
    Provider.of<AuthNotifier>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text("${authNotifier.user.displayName}\n \n${authNotifier.user.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 138, 120, 1),
                    Color.fromRGBO(255, 114, 117, 1),
                    Color.fromRGBO(255, 63, 111, 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text('Profile'),
              onTap: () => {
              // Navigator.pushAndRemoveUntil(
              // context,
              // MaterialPageRoute(builder: (context) => ProfilePage()),
              // (Route<dynamic> route) => false,
              // )
              showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
              return ProfilePage();
              }
              )
              //
              },
            ),
            ListTile(
              leading: Icon(Icons.pending),
              title: Text('Pending Orders'),
              onTap: () => {Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return OrderHistory();
                }),
              )},
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Past Orders'),
              onTap: () => {Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return NavigationBarPage(selectedIndex: 0,);
                }),
              )},
            ),
            ListTile(
              leading: Icon(Icons.menu_book),
              title: Text('Menu'),
              onTap: () => {Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
              return AdminHomePage();
              }),
              )},
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Terms and Conditions'),
              onTap: () => { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TandC()),
              )
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {

    if (authNotifier.user != null) {
    signOut(authNotifier, context)
    }
    },
            ),
          ],
        ),
      ),
    );
  }
}
