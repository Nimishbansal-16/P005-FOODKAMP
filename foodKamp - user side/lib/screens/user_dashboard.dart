import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/models/restaurant.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/screens/menu.dart';
import 'package:canteen_food_ordering_app/screens/navbar2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';


class OrderNow extends StatefulWidget {
  @override
  _OrderNowState createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  List<Restaurant>restaurantIds= new List<Restaurant>();


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
        // appBar: AppBar(
        //   title: Text('Cart'),
        // ),
        appBar: AppBar(
          toolbarHeight: 210.0,
          flexibleSpace: Image(
            image: AssetImage('images/Group286.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        // ignore: unrelated_type_equality_checks
        body:
        (authNotifier.userDetails.uuid == Null) ?
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text("No Items to display"),
        )
           : restaurantList(context)
    );
  }

  Widget restaurantList(context){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('restaurants').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
      if(snapshot1.data == null) return Center(child: CircularProgressIndicator());
      restaurantIds= new List<Restaurant>();
      snapshot1.data.documents.forEach((item) {
        restaurantIds.add(Restaurant(item.documentID,item['restaurantname'],item['Category'],item['Open_time'],item['Close_time']));
      });
     return SingleChildScrollView(
       physics: ScrollPhysics(),
       child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(' ORDER NOW',style: TextStyle(
               fontSize: 27.0,color: Colors.blueGrey[700],fontWeight: FontWeight.bold,
             ),),
             SizedBox(height: 8.0,),

             ListView.builder(

    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: restaurantIds.length,
    itemBuilder: (context, int i) {
        TimeOfDay _time = TimeOfDay.now();
        String opentime = restaurantIds[i].Open_time;
        String closetime = restaurantIds[i].Close_time;
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

    return Container(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // SizedBox(height: 8.0,),
    InkWell(
    child: Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    clipBehavior: Clip.antiAlias,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Image.asset('images/th(15).png',height: 141,fit: BoxFit.fitWidth,),
    ListTile(
    title: Text(
    restaurantIds[i].restaurantname,
    style: TextStyle(fontSize: 22.0,color: Colors.grey[700],fontWeight: FontWeight.bold,),
    ),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(restaurantIds[i].Category,style: TextStyle(color: Colors.grey[600],),),
    Row(
    children: [
        if(t==1)
    Text('Open Now',style: TextStyle(color: Colors.lightGreenAccent[400], fontWeight: FontWeight.bold),),
    if(t==0)Text('Closed Now',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),) ,
    SizedBox(width: 18.0,),
    Text('${restaurantIds[i].Open_time} - ${restaurantIds[i].Close_time}',style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),),
    ],
    )
    ],
    ),
    )
    ],
    ),
    ),

    onTap: (){

        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {

            return HomePage(restaurantID2: restaurantIds[i].id, restaurantName: restaurantIds[i].restaurantname,);


          },
        ));

    },
    ),
    ],
    ),
    ),
    );}
    ),

           ],
         ),
     );







     }
  ,
  );
}
  // Widget build(BuildContext context) {
  //   
  // }

}


