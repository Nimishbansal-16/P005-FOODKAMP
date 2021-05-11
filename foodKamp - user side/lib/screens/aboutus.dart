
import 'package:flutter/material.dart';
class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Text('''In this era where time is money, people in our college generally face the hassle of waiting a lot in cafeterias like Cafe Zippy and Aladin to get their food. It is a tiring and time consuming process. But a food ordering app can reduce this time barrier. With the help of this system, a person can order desired food at his desired time. 

Also, it will help restaurants to get optimized control, as they will be well prepared with the orders, when the customer arrives.

From the management point of view, the manager will be able to control the restaurant by having all the reports in hand and will be able to see the records of their sales.

This application helps the restaurants to do all functionalities accurately and also increase their efficiency.
Thus, benefiting everyone involved in the
business.
    ''',style: TextStyle(fontSize: 18,),),
          ),
        ),
      ) ,
    );
  }
}
