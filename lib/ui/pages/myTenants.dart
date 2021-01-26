import 'package:flutter/material.dart';
import 'package:rent_lo_app/ui/widgets/addTenantWidget.dart';
import 'package:rent_lo_app/ui/widgets/viewTenants.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTenants extends StatefulWidget {
  final String name;
  final String email;
  final String userId;

  const MyTenants({this.name, this.email, this.userId});
  @override
  _MyTenantsState createState() => _MyTenantsState();
}

class _MyTenantsState extends State<MyTenants> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        backgroundColor: Color(0xFF5a20c7),
        title: Text("Your Tenants",
            style: TextStyle(
              fontFamily: "Josefin",
              fontSize: 25,
            )),
      ),
      floatingActionButton: AddTenant(
        userId: widget.userId,
      ),
      body: SafeArea(
        child: ViewTenants(
          userId: widget.userId,
        ),
      ),
    );
  }

  launchURL() async {
    const url = 'https://lorentapp.com';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURL1() async {
    const url = 'https://lorentapp.medium.com';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURL2() async {
    const url = 'https://lorentapp.com/new';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURL3() async {
    const url = 'https://lorentapp.com/help';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(),
            decoration: BoxDecoration(
              color: Color(0xFF5a20c7),
            ),
            accountName: Text(
              widget.name,
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 23,
              ),
            ),
            accountEmail: Text(
              widget.email,
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text(
              "Visit Website",
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 20,
              ),
            ),
            onTap: () {
              launchURL();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.hourglass_bottom),
            title: Text(
              "New Updates Coming Soon",
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 18,
              ),
            ),
            onTap: () {
              launchURL2();
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.info_rounded),
            title: Text(
              "Help",
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 20,
              ),
            ),
            onTap: () {
              launchURL3();
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text(
              "Lo Rent Blog",
              style: TextStyle(
                fontFamily: "Josefin",
                fontSize: 20,
              ),
            ),
            onTap: () {
              launchURL1();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
