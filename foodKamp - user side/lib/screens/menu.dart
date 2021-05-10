import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canteen_food_ordering_app/models/food.dart';
import 'package:provider/provider.dart';

import 'cartPage.dart';

class HomePage extends StatefulWidget {
 final String restaurantID2;
 final String restaurantName;
 HomePage({Key key, @required this.restaurantID2, @required this.restaurantName}) : super(key: key);
  // HomePage({@required this.restaurantID2});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cartIds = new List<String>();
  List<Food> _foodItems = new List<Food>();
  String name = '';

  // String get restaurantID2 => restaurantID2;
  // String restaurantID2 = restaurantID2;
  // String get restaurantID2 => restaurantID2;

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    getCart(authNotifier.userDetails.uuid);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),

      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return CartPage(restaurantID2: widget.restaurantID2, restaurantname: widget.restaurantName);
              },));
          },
          child: Icon(Icons.add_shopping_cart,color: Colors.white,),
          backgroundColor: Color.fromRGBO(255, 63, 111, 1),
        ),
      // ignore: unrelated_type_equality_checks
      body: (authNotifier.userDetails.uuid == Null) ? Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text("No Items to display"),
      ) : userHome(context,widget.restaurantID2)
    );
  }

  Widget userHome(context, String restaurantID2){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return SingleChildScrollView(
        physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('restaurants').document(restaurantID2).collection('items').where('total_qty', isGreaterThan: 0).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0 ) {
                  _foodItems = new List<Food>();
                  snapshot.data.documents.forEach((item) {
                    _foodItems.add(Food(item.documentID, item['item_name'], item['total_qty'], item['price'], item['time']));
                  });
                  List<Food> _suggestionList = (name == '' || name == null) ? _foodItems
                    : _foodItems.where((element) => element.itemName.toLowerCase().contains(name.toLowerCase())).toList();
                  if(_suggestionList.length > 0){
                    return Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child:ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _suggestionList.length,
                        itemBuilder: (context, int i) {
                        return Card(
                          child: ListTile(
                            title: Text(_suggestionList[i].itemName ?? ''),
                            subtitle:
                                Text('cost: ${_suggestionList[i].price.toString()} \u{20B9}  |  Preparation time: ${_suggestionList[i].time.toString()} min'),
                                // Text('time: ${_suggestionList[i].time.toString()}'),
                            trailing: IconButton(
                                  icon: cartIds.contains(_suggestionList[i].id)? new Icon(Icons.remove):new Icon(Icons.add,),
                                  onPressed: () async{
                                    cartIds.contains(_suggestionList[i].id)?
                                    await removeFromCart(_suggestionList[i], context) : await addToCart(_suggestionList[i], context);
                                    setState(() {
                                      getCart(authNotifier.userDetails.uuid);
                                    });
                                  },
                                ),

                          ),
                        );
                      }),

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
            ),
    // IconButton(icon: Icon(Icons.add_shopping_cart,color: Colors.brown[900],),alignment: Alignment.bottomLeft, onPressed: (){
    // Navigator.push(context, MaterialPageRoute(
    // builder: (BuildContext context) {
    // return CartPage(restaurantID2: restaurantID2);
    // },));}),


          ],
        ),
      );
  }

  void getCart(String uuid) async{
    List<String> ids = new List<String>();
    QuerySnapshot snapshot = await Firestore.instance.collection('carts').document(uuid).collection('items').getDocuments();
    var data = snapshot.documents;
    for(var i=0; i<data.length; i++){
      ids.add(data[i].documentID);
    }
    setState(() {
      cartIds = ids;
    });
  }
}
