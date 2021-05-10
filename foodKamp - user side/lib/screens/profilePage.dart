import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/models/user.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/screens/orderDetails.dart';
import 'package:canteen_food_ordering_app/screens/tandc.dart';
import 'package:canteen_food_ordering_app/screens/user_dashboard.dart';
import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'aboutus.dart';
import 'navigationBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _formKey = GlobalKey<FormState>();
  Razorpay _razorpay;
  int money = 0;

  final _formKey2 = GlobalKey<FormState>();
  final _formKeyEdit = GlobalKey<FormState>();

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              signOutUser();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Container(
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                width: 100,
                child: Icon(
                  Icons.person,
                  size: 70,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              authNotifier.userDetails.displayName != null
                  ? Text(
                      authNotifier.userDetails.displayName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'MuseoModerno',
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text("You don't have a user name"),
              SizedBox(
                height: 10,
              ),
              Text(
                authNotifier.userDetails.email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'MuseoModerno',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              authNotifier.userDetails.balance != null
              ? Text(
                  "Balance: ${authNotifier.userDetails.balance} \u{20B9}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'MuseoModerno',
                  ),
                )
              :
              Text(
                "Balance: 0 \u{20B9}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'MuseoModerno',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return popupForm(context);
                    }
                  );
                },
                child: CustomRaisedButton(buttonText: 'Add Money'),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.green, size: 30.0,),
                  SizedBox(width: 10.0,),
                  TextButton(onPressed: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => FeedBack()),
                    // );
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return popupEditForm(context);
                        }
                    );
                  },
                    child:  Text('Edit Profile', style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                  ),

                ],),
              // Divider(height: 30.0,color: Colors.grey[400],thickness: 1.2,),
              // Row(
              //   children: [
              //     Icon(Icons.feedback_rounded, color: Colors.amberAccent[400], size: 30.0,),
              //     SizedBox(width: 10.0,),
              //     TextButton(onPressed: (){
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(builder: (context) => FeedBack()),
              //       // );
              //     },
              //       child:  Text('Feedback and Suggestions', style: TextStyle(
              //         fontSize: 18.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //       ),),
              //     ),
              //
              //   ],),
              Divider(height: 30.0,color: Colors.grey[400],thickness: 1.2,),
              Row(
                children: [
                  Icon(Icons.assignment, color: Color.fromRGBO(255, 63, 111, 1), size: 30.0,),
                  SizedBox(width: 10.0,),
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TandC()),
                    );
                  },
                    child: Text('Terms and Conditions', style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    ),
                  ),
                ],),
              Divider(height: 30.0,color: Colors.grey[400],thickness: 1.2,),
              Row(
                children: [
                  Icon(Icons.emoji_food_beverage, color: Colors.blueAccent[200], size: 30.0,),
                  SizedBox(width: 10.0,),
                  TextButton( onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUs()),
                    );
                  },
                    child: Text('About Us', style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                  ),
                ],),
              Divider(height: 30.0,color: Colors.grey[400],thickness: 1.2,),

            ],
          ),
        ),
      ),
    );
  }

  Widget popupEditForm(context){
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    String name = authNotifier.userDetails.displayName;
   String phone = authNotifier.userDetails.phone;

    return AlertDialog(
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Form(
              key: _formKeyEdit,
              autovalidate: true,
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
                      initialValue: name,
                      validator: (String value) {
                        if(value.length < 3) return "Not a valid name";
                        else return null;
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (String value) {
                        name = value;
                      },
                      cursorColor: Color.fromRGBO(255, 63, 111, 1),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                        icon: Icon(
                          Icons.person,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: phone,
                      validator: (String value) {
                        if(value.length != 10) return "Not a valid phone no.";
                        else if(int.tryParse(value) == null) return "Not a valid integer";
                        else return null;
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                      onSaved: (String value) {
                        phone = value;
                      },
                      cursorColor: Color.fromRGBO(255, 63, 111, 1),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                        icon: Icon(
                          Icons.phone,
                          color: Color.fromRGBO(255, 63, 111, 1),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     initialValue: totalQty.toString(),
                  //     validator: (String value) {
                  //       if(value.length > 4) return "QTY cannot be above 4 digits";
                  //       else if(int.tryParse(value) == null) return "Not a valid integer";
                  //       else return null;
                  //     },
                  //     keyboardType: TextInputType.numberWithOptions(),
                  //     onSaved: (String value) {
                  //       totalQty = int.parse(value);
                  //     },
                  //     cursorColor: Color.fromRGBO(255, 63, 111, 1),
                  //     decoration: InputDecoration(
                  //       hintText: 'Total QTY',
                  //       hintStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Color.fromRGBO(255, 63, 111, 1),
                  //       ),
                  //       icon: Icon(
                  //         Icons.add_shopping_cart,
                  //         color: Color.fromRGBO(255, 63, 111, 1),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: TextFormField(
                  //     initialValue: time.toString(),
                  //     validator: (String value) {
                  //       if(value.length > 2) return "Not a valid time";
                  //       else if(int.tryParse(value) == null) return "Not a valid integer";
                  //       else return null;
                  //     },
                  //     keyboardType: TextInputType.numberWithOptions(),
                  //     onSaved: (String value) {
                  //       time = int.parse(value);
                  //     },
                  //     cursorColor: Color.fromRGBO(255, 63, 111, 1),
                  //     decoration: InputDecoration(
                  //       hintText: 'Preparation time in min',
                  //       hintStyle: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Color.fromRGBO(255, 63, 111, 1),
                  //       ),
                  //       icon: Icon(
                  //         Icons.timelapse,
                  //         color: Color.fromRGBO(255, 63, 111, 1),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKeyEdit.currentState.validate()) {
                          _formKeyEdit.currentState.save();

                         updateUserData(name,phone);

                         // Navigator.pushReplacement(context, MaterialPageRoute(
                         //    builder: (BuildContext context) {
                         //      return NavigationBarPage(selectedIndex: 1);
                         //
                         //    },
                         //  ));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => NavigationBarPage(selectedIndex: 1)),
                                (Route<dynamic> route) => false,
                          );
                         //  Navigator.pop(context);
                          toast('Profile Updated Successfully');


                        }

                      },
                      child: CustomRaisedButton(buttonText: 'Edit'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }


  Widget popupForm(context){
    int amount = 0;
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Deposit Money", style: TextStyle(
                    color: Color.fromRGBO(255, 63, 111, 1),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (String value) {
                      if(int.tryParse(value) == null) return "Not a valid integer";
                      else if(int.parse(value) < 1) return "Minimum Deposit is 1 \u{20B9}";
                      else if(int.parse(value) > 1000) return "Maximum Deposit is 1000 \u{20B9}";
                      else return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(),
                    onSaved: (String value) {
                      amount = int.parse(value);
                    },
                    cursorColor: Color.fromRGBO(255, 63, 111, 1),
                    decoration: InputDecoration(
                      hintText: 'Money in INR',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 63, 111, 1),
                      ),
                      // icon: Icon(
                      //   Icons.attach_money,
                      //   color: Color.fromRGBO(255, 63, 111, 1),
                      // ),
                      icon : Text('\u{20B9}', style: TextStyle(color: Color.fromRGBO(255, 63, 111, 1), fontSize: 20, fontWeight: FontWeight.bold ),),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        return openCheckout(amount);
                      }
                    },
                    child: CustomRaisedButton(buttonText: 'Add Money'),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  void openCheckout(int amount) async {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    money = amount;
    var options = {
      'key': 'rzp_test_ZQaQemUodM0Vwr',
      'amount': money*100,
      'name': authNotifier.userDetails.displayName,
      'description': "${authNotifier.userDetails.uuid} - ${DateTime.now()}",
      'prefill': {'contact': authNotifier.userDetails.phone, 'email': authNotifier.userDetails.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void toast(String data){
    Fluttertoast.showToast(
      msg: data,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    addMoney(money, context, authNotifier.userDetails.uuid);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toast("ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toast("EXTERNAL_WALLET: " + response.walletName);
    Navigator.pop(context);
  }
}

