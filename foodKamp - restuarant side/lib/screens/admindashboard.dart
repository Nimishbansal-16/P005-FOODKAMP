import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/button_widget.dart';
import 'package:canteen_food_ordering_app/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'orderDetails.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  // String _scanBarcode ="";
  //
  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //
  //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       "#42f5ef", "Cancel", true, ScanMode.QR);
  //   print(barcodeScanRes);
  //
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //   });
  // }
  String qrCode = 'abcdef';

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(
        context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }
  Future<void> scanQRCode(BuildContext context, String userid) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;


      int t=1;
      CollectionReference orderid = Firestore.instance.collection('orders');
      QuerySnapshot snap = await orderid.where(FieldPath.documentId, isEqualTo: qrCode).where('placed_to', isEqualTo: userid).getDocuments();
      if (snap.documents.isNotEmpty && snap.documents.length > 0 ) {
        List<dynamic> orders2 = snap.documents;
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => OrderDetailsPage(orders2[0],t)));
      }
      else {
        toast("Invalid QR code");
      }
      setState(() {
        this.qrCode = qrCode;

      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }

  }
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =Provider.of<AuthNotifier>(context, listen: false);
    String restaurantID2 = authNotifier.user.uid;


    return Scaffold(
      drawer: SideDrawer(),
        appBar:
        AppBar(
          title: Text(
            "Pending Orders",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'MuseoModerno',
            ),
            textAlign: TextAlign.left,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child : Icon(Icons.qr_code_scanner,),
          onPressed: () async{

            scanQRCode(context,authNotifier.user.uid);
            // print(qrCode);

            // orderReceived(qrCode,context);

          },
          backgroundColor: Colors.pinkAccent,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[myOrders(restaurantID2),

            ],

          )

          ,)

    );
  }
}

    // .orderBy("placed_at", descending: true)
void toast(String data){
  Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white
  );
}

Widget myOrders(uid){
  // AuthNotifier authNotifier =Provider.of<AuthNotifier>(context, listen: false);
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('orders').where('placed_to', isEqualTo: uid).where('is_delivered', isEqualTo: 'Pending').snapshots(),
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
                    int t2 = 0;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(orders[i],t2)));
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