import 'package:flutter/material.dart';

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
            'Dashboard',
            () => Navigator.of(context).pushNamed('/dashboard'),
          ),
          _customListTyle(
            Icons.account_circle,
            'Farmers',
            () => Navigator.of(context).pushNamed('/farmers'),
          ),
          _customListTyle(
            Icons.supervised_user_circle,
            'Groups',
            () => Navigator.of(context).pushNamed('/groups'),
          ),
          _customListTyle(
            Icons.notifications,
            'Farm Inputs',
            () => Navigator.of(context).pushNamed('/farm_inputs'),
          ),
          _customListTyle(
            Icons.store,
            'Organizations',
            () => Navigator.of(context).pushNamed('/organizations'),
          ),
          _customListTyle(
            Icons.settings,
            'Profile',
            () => Navigator.of(context).pushNamed('/profile'),
          ),
          _customListTyle(
            Icons.blur_circular,
            'Logout',
            () => Navigator.of(context).pushNamed('/logout'),
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
