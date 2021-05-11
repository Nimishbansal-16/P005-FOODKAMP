
import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/models/cart.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final String restaurantID2, restaurantname;

  CartPage({Key key, @required this.restaurantID2, @required this.restaurantname}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }

  }

  double sum = 0;
  int itemsCount = 0;

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      // ignore: unrelated_type_equality_checks
      body: (authNotifier.userDetails.uuid == Null) ? Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text("No Items to display"),
      ) : cartList(context)
    );
  }

  Widget cartList(context){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('carts').document(authNotifier.userDetails.uuid).collection('items').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                if (snapshot1.hasData && snapshot1.data.documents.length > 0 ) {
                  List<String> foodIds = new List<String>();
                  Map<String, int> count = new Map<String, int>();
                  snapshot1.data.documents.forEach((item) {
                    foodIds.add(item.documentID);
                    count[item.documentID] = item.data['count'];
                  });
                  return dataDisplay(context,widget.restaurantID2, authNotifier.userDetails.uuid, foodIds, count, widget.restaurantname);
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text("No Items to display"),
                  );
                }
              } ,
            ),
        ],
      ),
    );
  }

  Widget dataDisplay(BuildContext context,String restaurantID2, String uid, List<String> foodIds, Map<String, int> count, String restaurantname){

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('restaurants').document(restaurantID2).collection('items').where(FieldPath.documentId, whereIn: foodIds).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0 ) {
          List<Cart> _cartItems = new List<Cart>();
          snapshot.data.documents.forEach((item) {
            _cartItems.add(Cart(item.documentID, count[item.documentID], item.data['item_name'], item.data['total_qty'], item.data['price'], item.data['time']));
            _cartItems.sort((a,b){
              return a.time.compareTo(b.time);
            });
          });
          if (_cartItems.length > 0){
            sum = 0;
            itemsCount= 0;
            _cartItems.forEach((element) {
              if(element.price != null && element.count != null){
                sum += element.price * element.count;
                itemsCount += element.count;
              }
            });
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, int i) {
                    return Card(
                      child: ListTile(
                        title: Text(_cartItems[i].itemName ?? ''),
                        subtitle: Text('cost: ${_cartItems[i].price.toString()} \u{20B9}  |  Preparation time: ${_cartItems[i].time.toString()} min'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                          (_cartItems[i].count == null || _cartItems[i].count <= 1) ?
                          IconButton(
                            onPressed: () async{
                              setState(() {
                                foodIds.remove(_cartItems[i].itemId);
                              });
                              await editCartItem(_cartItems[i].itemId, 0, context);
                            },
                            icon: new Icon(Icons.delete),
                          )
                          : IconButton(
                            onPressed: () async{
                              await editCartItem(_cartItems[i].itemId, (_cartItems[i].count-1), context);
                            },
                            icon: new Icon(Icons.remove),
                          ),
                          Text(
                            '${_cartItems[i].count ?? 0}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          IconButton(
                            icon: new Icon(Icons.add),
                            onPressed: () async{
                              await editCartItem(_cartItems[i].itemId, (_cartItems[i].count+1), context);
                            },
                          )
                        ]),
                      ),
                    );
                  }),
                  Text("Total ($itemsCount items): $sum \u{20B9}"),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(255, 114, 117, 1),),
                    // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.brown[900]),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
                    ),
                    onPressed: _selectTime,
                    child: Text( 'Selected Reaching Time: ${_time.format(context)}',style: TextStyle(
                      fontSize: 16
                    ),),
                  ),
                  // GestureDetector(
                  //   onTap: _selectTime,
                  //   child:  CustomRaisedButton(buttonText: 'Selected Reaching Time: ${_time.format(context)}')
                  // ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async{
                      CollectionReference rest = Firestore.instance.collection('restaurants');
                      QuerySnapshot snap = await rest.where(FieldPath.documentId, isEqualTo: restaurantID2).getDocuments();
                      if (snap.documents.isNotEmpty && snap.documents.length > 0 ) {
                        List<dynamic> restro = snap.documents;
                        String opentime = restro[0]['Open_time'];
                        String closetime = restro[0]['Close_time'];
                        int hh = 0;
                        if (opentime.endsWith('PM') && !opentime.startsWith('12')) hh = 12;
                        String time = opentime.split(' ')[0];
                        TimeOfDay _opentime =  TimeOfDay(
                          hour: hh + int.parse(time.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
                          minute: int.parse(time.split(":")[1]) % 60,
                        );
                        hh= 0;
                        if (closetime.endsWith('PM') && !closetime.startsWith('12')) hh = 12;
                        String timex = closetime.split(' ')[0];
                        TimeOfDay _closetime =  TimeOfDay(
                          hour: hh + int.parse(timex.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
                          minute: int.parse(timex.split(":")[1]) % 60,
                        );
                        int t= 0;
                        if(_opentime.hour <= _time.hour)  t = 1;
                        if(_time.hour >= _closetime.hour) t= 0;


                        TimeOfDay nowTime = TimeOfDay.now();
                        double _doubleYourTime = _time.hour +
                            (_time.minute/ 60);

                        double _doubleNowTime = nowTime.hour +
                            (nowTime.minute/ 60);

                        double _timeDiff = _doubleYourTime - _doubleNowTime;

                        int _hr = _timeDiff.truncate();
                        double _minute = ((_timeDiff - _timeDiff.truncate()) * 60);
                        int minute = _minute.toInt();

                        if(((_hr == 0 && minute > _cartItems[_cartItems.length - 1].time)||(_hr>0)) && (t==1)) t= 2;

                        if(t==2){
                          showAlertDialog(context, "Total ($itemsCount items): $sum \u{20B9}", restaurantID2, restaurantname);
                          print(_closetime);
                          print(_opentime);
                        }
                        else if(t==1){
                          toast('Select time according to preparation time');
                        }

                        else{toast('Select time b/w opening and closing time of restaurant');
                        print(_closetime);
                        print(_opentime);}
                      }




                    // int temp = timecheck(restaurantID2,_time);
                    // if(temp==1)
                    //   showAlertDialog(context, "Total ($itemsCount items): $sum \u{20B9}", restaurantID2);
                    // else{toast('Select valid time');}
                    },
                    child: CustomRaisedButton(buttonText: 'Proceed to buy'),
                  ),

                  SizedBox(
                    height: 70,
                  ),
                ],
              )
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text("No Items to display"),
            );
          }
        } else {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text("No Items to display"),
          );
        }
      },
    );
  }

  showAlertDialog(BuildContext context, String data, String restaurantID2, String restaurantname) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

      Widget continueButton = FlatButton(
        child: Text("Place Order"),
        onPressed: () {
          placeOrder(context, sum, restaurantID2,_time.format(context), restaurantname);
        },
      );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Proceed to checkout?"),
      content: Text(data),
      actions: [
        cancelButton,
        continueButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}