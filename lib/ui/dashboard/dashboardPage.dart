//import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:kybee/widgets/bottomNavigation.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:kybee/widgets/headerMain.dart';
// import 'package:kybee/widgets/progress.dart';
import 'package:hexcolor/hexcolor.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Dashboard'),
      drawer: drawer(context),
      //backgroundColor: Color(0xFFF0F0F0),
      body: _buildBodyptions(context),
    );
  }

  Widget _buildBodyptions(context) {
    return ListView(children: <Widget>[
      _loanSelecetor(context),
      _loanDays(context),
      _loanDetails(context),
    ]);
  }

  Container _loanSelecetor(context) {
    String dropdownvalue = 'Ksh 1,000';
    var items = [
      'Ksh 1,000',
      'Ksh 500',
    ];
    return Container(
      child: Center(
        child: DropdownButton(
          dropdownColor: HexColor('#000000'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 30.0,
          ),
          value: dropdownvalue,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 38,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          items: items.map((String items) {
            return DropdownMenuItem(
                value: items,
                child: Text(
                  items,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ));
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropdownvalue = newValue;
            });
          },
        ),
      ),
      color: HexColor('#4A1F1F'),
    );
  }

  Container _loanDays(context) {
    return Container(
      color: HexColor('#4A1F1F'),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  "7 Days",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: HexColor('#4A1F1F'),
                    fontSize: 18.0,
                  ),
                ),
              ),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    // return Container(
    //   child: Center(
    //       child: Padding(
    //     padding: const EdgeInsets.all(30.0),
    //     child: Text(
    //       "7 Days",
    //       style: TextStyle(
    //         backgroundColor: Colors.blue,
    //       ),
    //     ),
    //   )),
    //   color: HexColor('#4A1F1F'),
    // );
  }

  Container _loanDetails(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 23.0, bottom: 23.0, left: 10.0, right: 10.0),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Text(
                "LOAN DETAILS",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Disbursed",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ksh 700",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Repayment",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ksh 1,000",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Interest",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ksh 270",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total Commission",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ksh 30",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
