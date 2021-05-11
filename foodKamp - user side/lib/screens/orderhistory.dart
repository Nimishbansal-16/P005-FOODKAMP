import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orderDetails.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
      appBar: AppBar(
        title: Text(
          "Order History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'MuseoModerno',
          ),
          textAlign: TextAlign.left,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
    child: Column(
    children: <Widget>[myOrders(authNotifier.userDetails.uuid),],
    )
    ,)
    );
  }
}



Widget myOrders(uid){
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('orders').where('placed_by', isEqualTo: uid).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData && snapshot.data.documents.length > 0 ) {
        List<dynamic> orders = snapshot.data.documents;
        orders.sort((b,a){
          return a['placed_at'].compareTo(b['placed_at']);
        });
        return Container(
          margin: EdgeInsets.only(top: 10.0),
          child:ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, int i) {
                // TimeOfDay _arrivaltime = TimeOfDay(hour:int.parse(orders[i]['time_of_arrival'].split(":")[0]),minute: int.parse(orders[i]['time_of_arrival'].split(":")[1].split(" ")[0]));
                int hh = 0;
                if (orders[i]['time_of_arrival'].endsWith('PM') && !orders[i]['time_of_arrival'].startsWith('12')) hh = 12;
               String time = orders[i]['time_of_arrival'].split(' ')[0];
                TimeOfDay _arrivaltime =  TimeOfDay(
                  hour: hh + int.parse(time.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
                  minute: int.parse(time.split(":")[1]) % 60,
                );
                TimeOfDay nowTime = TimeOfDay.now();
                // TimeOfDay nowTime = TimeOfDay(hour: 20, minute: 50);
                // int nowinhour = nowTime.hour;
                // int arrivalinhour = _arrivaltime.hour;
                // int nowinminute= nowTime.minute;
                // int arrivalinminute= _arrivaltime.minute;

                double _doubleYourTime = _arrivaltime.hour +
                    (_arrivaltime.minute/ 60);

                double _doubleNowTime = nowTime.hour +
                    (nowTime.minute/ 60);

                double _timeDiff = _doubleYourTime - _doubleNowTime;

                int _hr = _timeDiff.truncate();
                double _minute = ((_timeDiff - _timeDiff.truncate()) * 60);
                int minute = _minute.ceil()+10;
                if(minute > 60){
                  minute = (minute)%60;
                  _hr+=1;
                }

               if(orders[i]['is_delivered']=='Pending'||orders[i]['is_delivered']=='Time Expired') {
                 if (_hr < 0 || minute < 0) {
                   try {
                     Firestore.instance.collection('orders').document(
                         orders[i].documentID).updateData(
                         {'is_delivered': 'Time Expired'})
                         .catchError((e) => print(e))
                         .then((value) => print("Success"));
                   } catch (error) {
                     pr.hide().then((isHidden) {
                       print(isHidden);
                     });
                     toast("Failed to mark as received!");
                     print(error);
                   }
                   _hr = 0;
                   minute = 0;
                 }
               }

               if(orders[i]['is_delivered']=='Delivered'||orders[i]['is_delivered']=='Time Expired'){
                 _hr = 0;
                 minute = 0;
               }
                // print('Here your Happy $_hr Hour and also $_minute min');
                return new GestureDetector(
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,10,0,0),
                          child: Text(
                            '${orders[i]['restaurantname']}',
                            style: TextStyle(fontSize: 20.0,color: Colors.grey[700],fontWeight: FontWeight.bold,),
                          ),
                        ),
                        Divider(height: 15.0,color: Colors.grey[400],),
                        ListTile(
                            title: Text("Order #${(i+1)}"),
                            subtitle: Text('Total Amount: ${orders[i]['total'].toString()} \u{20B9}'),
                            trailing: Column(
                              children: [
                                Text('Status: ${orders[i]['is_delivered']}'),
                                Text( 'Reaching Time: ${orders[i]['time_of_arrival']}',style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Time Left: $_hr hr $minute min',)
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsPage(orders[i])));
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