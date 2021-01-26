import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_lo_app/res/saveSharedPreference.dart';

import 'pages/login.dart';
import 'pages/myTenants.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void isLoggenIn() async {
    String userId = await SaveSharedPreference.getUserId();
    print(userId);
    bool isLogIn = userId == null;
    if (isLogIn)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    else {
      String userName = await SaveSharedPreference.getUserName();
      String userPhoneNumber = await SaveSharedPreference.getPhoneNumber();
      String userEmail = await SaveSharedPreference.getUserEmail();
      print(userName);
      print(userPhoneNumber);
      print(userEmail);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyTenants(
            email: userEmail,
            name: userName,
            userId: userId,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), isLoggenIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "assets/splashLogo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
