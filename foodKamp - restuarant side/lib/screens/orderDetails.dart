import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailsPage extends StatefulWidget {

  final dynamic orderdata;
  final int t;
  OrderDetailsPage(this.orderdata,this.t);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = widget.orderdata['items'];
    AuthNotifier authNotifier =Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30, right: 10),
                ),
              ],
            ),
            Text(
              "Order Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, int i) {
              return Card(
                child: new ListTile(
                  title: Text("${items[i]["item_name"]}", style: TextStyle(fontSize: 18),),
                  subtitle: Text("Quantity: ${items[i]["count"]}"),
                  trailing: Text("Price: ${items[i]["count"]} * ${items[i]["price"]} = ${items[i]["price"] * items[i]["count"]} \u{20B9}"),
                ),
              );
            }),
            SizedBox(
              height: 20,
            ),
            Text(
              "Total Amount: ${widget.orderdata['total'].toString()} \u{20B9}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Status: ${widget.orderdata['is_delivered']}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
              ),
            ),
            SizedBox(
              height: 20,
            ),

            Text(
              "Arrival Time: ${widget.orderdata['time_of_arrival']}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'MuseoModerno',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),

            (widget.orderdata['is_delivered']== 'Pending' && widget.t==1 )? GestureDetector(
              onTap: () {
                orderReceived(widget.orderdata.documentID, context);
                print(widget.orderdata.documentID);
              },
              child:  CustomRaisedButton(buttonText: 'Received'),
            ): Text(""),
          ],
        ),
      ),
    );
  }
}