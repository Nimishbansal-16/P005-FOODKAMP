import 'package:flutter/material.dart';

class TandC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Text('“foodKamp APP” is for ordering food from restaurants available. ',style: TextStyle(
                    fontSize: 18,fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 10,),
                Text('It basically saves time and hassle. ',style: TextStyle(
                    fontSize: 16,fontWeight: FontWeight.bold
                ),),
                Text('''
                

1. This app only places the orders and does not manage the preparation of the orders at the restaurant.

2. If the order is not prepared by the time the user wanted his/her order, the restaurantmust be responsible for that.

3. Also, if the order is not picked-up by the user within the defined time, it would be in restaurant’s control of whether to fulfill the order later or cancel the order and return/not return the money.
    ''', style: TextStyle(fontSize: 16),),
              ],
            ),
          ),
        ),
      ) ,
    );
  }
}
