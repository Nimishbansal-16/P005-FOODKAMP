import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orderDetails.dart';

class ExpiredOrders extends StatefulWidget {
  @override
  _ExpiredOrdersState createState() => _ExpiredOrdersState();
}

class _ExpiredOrdersState extends State<ExpiredOrders> {
  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(
        context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text(
            "Expired Orders",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'MuseoModerno',
            ),
            textAlign: TextAlign.left,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[myOrders(authNotifier.user.uid),],
          )
          ,)
    );
  }
}

// .orderBy("is_delivered").orderBy("placed_at", descending: true)

Widget myOrders(uid){
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('orders').where('placed_to', isEqualTo: uid).where('is_delivered', isEqualTo: 'Time Expired').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData && snapshot.data.documents.length > 0 ) {
        List<dynamic> orders = snapshot.data.documents;
        return Container(
          margin: EdgeInsets.only(top: 10.0),
          child:ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, int i) {
                return new GestureDetector(
                  child: Card(
                    child: ListTile(

                        title: Text("Order #${(i+1)}"),
                        subtitle: Text('Total Amount: ${orders[i]['total'].toString()} \u{20B9}'),
                        trailing: Column(
                          children: [
                            SizedBox(height: 10,),
                            Text('Status: ${orders[i]['is_delivered']}'),
                            Text( 'Reaching Time: ${orders[i]['time_of_arrival']}',style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                  onTap: () {
                    int t = 0;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(orders[i],t)));
                  },
                );
              }),
        );
      } else {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(""),
        );
      }
    },
  );
}