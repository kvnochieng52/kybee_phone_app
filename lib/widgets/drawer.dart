import 'package:flutter/material.dart';
import 'package:kybee/ui/contact_us/ContactUsPage.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/ui/logout/LogOutPage.dart';
import 'package:kybee/ui/messages/MessagesPage.dart';
import 'package:kybee/ui/profile/basicDetailsPage.dart';
import 'package:kybee/ui/terms_conditions/TermsConditionsPage.dart';

Drawer drawer(context) {
  return Drawer(
    child: Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          // DrawerHeader(
          //   decoration: BoxDecoration(
          //     // gradient: LinearGradient(
          //     //   colors: <Color>[
          //     //     Colors.brown,
          //     //     Colors.brown,
          //     //   ],
          //     // ),
          //     color: Colors.brown,
          //   ),
          //   child: Container(
          //     child: Column(
          //       children: <Widget>[
          //         Image.asset(
          //           'images/logo.png',
          //           width: 80.0,
          //           height: 80.0,
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          _customListTyle(
            Icons.dashboard,
            'My Loan',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardPage(),
              ),
            ),
          ),
          _customListTyle(
            Icons.account_circle,
            'My Profile',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BasicDetailsPage(),
              ),
            ),
            // () => Navigator.of(context).pushNamed('/farmers'),
          ),
          _customListTyle(
            Icons.phone,
            'Contact Us',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactUsPage(),
              ),
            ),
          ),
          _customListTyle(
            Icons.chat,
            'Messages',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesPage(),
              ),
            ),
          ),

          _customListTyle(
            Icons.info,
            'Terms & Conditions',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TermsandConditionsPage(),
              ),
            ),
          ),

          _customListTyle(
            Icons.logout,
            'Logout',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogOutPage(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _customListTyle(IconData icon, String text, Function onTap) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    ),
  );
}
