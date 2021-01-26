import 'package:flutter/material.dart';
import 'package:flutter_truecaller/flutter_truecaller.dart';
import 'package:rent_lo_app/model/userDetailsModel.dart';
import 'package:rent_lo_app/res/detailsFirebase.dart';
import 'package:rent_lo_app/ui/pages/enterDetailsPage.dart';
import 'package:rent_lo_app/ui/pages/myTenants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FlutterTruecaller caller = FlutterTruecaller();

  @override
  void initState() {
    getTruecallerProfile();
    super.initState();
  }

  getTruecallerProfile() async {
    await caller.initializeSDK(
      sdkOptions: FlutterTruecallerScope.SDK_OPTION_WITH_OTP,
      footerType: FlutterTruecallerScope.FOOTER_TYPE_SKIP,
      consentMode: FlutterTruecallerScope.CONSENT_MODE_POPUP,
    );
  }

  void handleLogin(BuildContext context) async {
    await caller.getProfile();
    FlutterTruecaller.trueProfile.listen(
      (TruecallerProfile data) async {
        if (data == null)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                "Unknown Error Occured",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text(
                "You are automatically logged in",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
          UserDetailsModel _userModel = await DetailsFirebase()
              .checkAlreadyAMemeber(phoneNumber: data.phoneNumber);
          print(_userModel);
          if (_userModel == null)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => EnterDetailsPage(
                  firstName: data.firstName,
                  lastName: data.lastName,
                  mail: data.email,
                  phoneNumber: data.phoneNumber,
                ),
              ),
            );
          else
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => MyTenants(
                  email: _userModel.email,
                  name: _userModel.name,
                  userId: _userModel.userId,
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -120,
              top: -70,
              child: Image.asset(
                "assets/bg1.png",
                color: Color(0xFF5a20c7),
                scale: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 40),
              child: Image.asset(
                "assets/rentlo.png",
                width: 100.0,
                height: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 145),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: 40.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Lo Rent - Ecospace",
                          style: TextStyle(
                              fontSize: 40.0,
                              fontFamily: "Josefin",
                              color: Colors.white),
                        ),
                       
                        Text(
                          "Manage & Send Reminders to Tenants",
                          style: TextStyle(
                            fontSize: 22.0,
                            height: 1,
                            fontFamily: "Josefin",
                            color: Colors.black,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    height: 100.0,
                  ),
                  GestureDetector(
                    onTap: () => handleLogin(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 80,
                      height: 60,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF5a20c7),
                                blurRadius: 7.0,
                                offset: Offset(0, 7.0))
                          ],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Material(
                        color: Colors.transparent,
                        child: Center(
                          child: Text(
                            "Login wth Truecaller",
                            style: TextStyle(
                                fontFamily: "Poiret",
                                color: Colors.black,
                                fontSize: 18.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
