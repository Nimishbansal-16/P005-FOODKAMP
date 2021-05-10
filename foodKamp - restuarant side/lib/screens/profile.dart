import 'package:canteen_food_ordering_app/models/restaurant.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/screens/adminHome.dart';

import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:canteen_food_ordering_app/widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';


class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TimeOfDay open_time = TimeOfDay(hour: 8, minute: 00);
  TimeOfDay close_time = TimeOfDay(hour: 22, minute: 00);


  final _formKeyEdit = GlobalKey<FormState>();
  List<Restaurant>restaurantIds= new List<Restaurant>();
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    void _selectcloseTime() async {
      final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: close_time,
      );
      if (newTime != null) {
        setState(() {
          close_time = newTime;
        });
        updateClosetime(close_time.format(context), authNotifier);
      }


    }
    void _selectTime() async {
      final TimeOfDay newTime = await showTimePicker(
        context: context,
        initialTime: open_time,
      );

      if (newTime != null) {
        setState(() {
          open_time = newTime;
        });
        updateOpentime(open_time.format(context), authNotifier);
      }


    }
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('restaurants').where('id', isEqualTo: authNotifier.user.uid).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
    if(snapshot1.data == null) return Center(child: CircularProgressIndicator());
    restaurantIds= new List<Restaurant>();
    snapshot1.data.documents.forEach((item) {
    restaurantIds.add(Restaurant(item.documentID,item['restaurantname'],item['Category'],item['Open_time'],item['Close_time']));
    });
    String opentime = restaurantIds[0].Open_time;
    String closetime = restaurantIds[0].Close_time;

    {
    return AlertDialog(
    content: Stack(
    overflow: Overflow.visible,
    children: <Widget>[
    Form(
    key: _formKeyEdit,
    autovalidate: true,
    child: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
      Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("Edit Profile", style: TextStyle(
      color: Color.fromRGBO(255, 63, 111, 1),
      fontSize: 25,
      fontWeight: FontWeight.bold,
      ),),
      ),
      Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
      initialValue: restaurantIds[0].Category,
      validator: (String value) {
      if(value.length < 3) return "Not a valid category";
      else return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (String value) {
      restaurantIds[0].Category = value;
      },
      cursorColor: Color.fromRGBO(255, 63, 111, 1),
      decoration: InputDecoration(
      hintText: 'Category',
      hintStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 63, 111, 1),
      ),
      icon: Icon(
      Icons.category,
      color: Color.fromRGBO(255, 63, 111, 1),
      ),
      ),
      ),
      ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(255, 114, 117, 1),),
                // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.brown[900]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
            ),
            onPressed: _selectTime,
            child: Text( 'Open time: ${opentime}',style: TextStyle(
                fontSize: 16
            ),),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromRGBO(255, 114, 117, 1),),
                // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.brown[900]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))
            ),
            onPressed: _selectcloseTime,
            child: Text( 'Close time: ${closetime}',style: TextStyle(
                fontSize: 16
            ),),
          ),
        ),
      Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
      onTap: () {
      if (_formKeyEdit.currentState.validate()) {
      _formKeyEdit.currentState.save();

      updateCategory(restaurantIds[0].Category, authNotifier);

      // Navigator.pushReplacement(context, MaterialPageRoute(
      //    builder: (BuildContext context) {
      //      return NavigationBarPage(selectedIndex: 1);
      //
      //    },
      //  ));
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AdminHomePage()),
      (Route<dynamic> route) => false,
      );
      //  Navigator.pop(context);
      toast('Profile Updated Successfully');


      }

      },
      child: CustomRaisedButton(buttonText: 'Save Changes'),
      ),
      ),
      ],
      ),
    ),
    ),
    ],
    )
    );
    }
    });

  }
}

