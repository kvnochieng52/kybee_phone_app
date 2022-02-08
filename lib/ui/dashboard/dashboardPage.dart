import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/common/theme_helper.dart';
import 'package:kybee/ui/loan/LoanApprovedPage.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:kybee/widgets/headerMain.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardPage> {
  List _loanDistributions = [];
  int _loanDistribution = 0;
  String _currency;
  int _loanpaymentDays = 0;

  bool _initDataFetched = false;

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
    };
    var res = await CallApi().postData(data, 'loan/dashboard_init');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _loanDistributions = body['loan_distributions'];
        _loanDistribution = body['user_details']['loan_distribution_id'];
        _loanpaymentDays = body['user_details']['period'];
        _currency = body['currency'];
        _initDataFetched = true;
      });
    }
  }

  _format_currency(double d) {
    String inString = d.toStringAsFixed(0);
    var formatter = NumberFormat('#,##,000');
    return formatter.format(double.tryParse(inString));
  }

  _refreshScreen() {
    print('refreshed');
    // _format_currency(1000.00);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Dashboard'),
      drawer: drawer(context),
      body: _buildBodyptions(context),
    );
  }

  Widget _buildBodyptions(context) {
    return ListView(children: <Widget>[
      _loanSelecetor(context),
      _loanDays(context),
      _loanDetails(context),
      _loanRepayment(context),
      _applyButton(context),
    ]);
  }

  Container _loanSelecetor(context) {
    return Container(
      child: Center(
        child: DropdownButton(
          value: _loanDistribution,
          isExpanded: false,
          hint: Text("Select Loan"),
          // validator: (value) => value == null ? 'Select Gender' : null,
          onChanged: (value) {
            setState(() {
              _loanDistribution = value;
            });
          },
          items: _loanDistributions.map((distribution) {
            return DropdownMenuItem(
              value: distribution['id'],
              child: Text(_currency +
                  " " +
                  _format_currency(
                      double.tryParse(distribution['max_amount']))),
            );
          }).toList(),
          dropdownColor: HexColor('#000000'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 25.0,
          ),
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 33,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
        ),
        // child: DropdownButton(
        //   dropdownColor: HexColor('#000000'),
        //   hint: Text("Select Gender"),
        //   style: TextStyle(
        //     fontWeight: FontWeight.w700,
        //     color: Colors.white,
        //     fontSize: 30.0,
        //   ),
        //   value: _loanDistributions,
        //   icon: Icon(Icons.keyboard_arrow_down),
        //   iconSize: 38,
        //   iconEnabledColor: Colors.white,
        //   iconDisabledColor: Colors.white,
        //   items: _loanDistributions.map((distribution) {
        //     return DropdownMenuItem(
        //         value: distribution['id'],
        //         child: Text(
        //           distribution['max_amount'],
        //           style: TextStyle(
        //             fontWeight: FontWeight.w700,
        //             color: Colors.white,
        //             fontSize: 30.0,
        //           ),
        //         ));
        //   }).toList(),
        //   onChanged: (value) {
        //     setState(() {
        //       _loanDistribution = value;
        //     });
        //   },
        // ),
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
                  "$_loanpaymentDays Days",
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
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 23.0,
            bottom: 23.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20.0,
                        color: HexColor('#000000'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "LOAN DETAILS",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    label:
                        Text('Refresh', style: TextStyle(color: Colors.white)),
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () => _refreshScreen(),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                  )
                ],
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

  Container _loanRepayment(context) {
    return Container(
      // margin: const EdgeInsets.only(top: 10.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 23.0,
            bottom: 23.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20.0,
                    color: HexColor('#000000'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "LOAN REPAYMENT",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Application Date",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "07-January-2022",
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
                      "Due Date",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "14-January-2022",
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
                      "Total Amount",
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
            ],
          ),
        ),
      ),
    );
  }

  Container _applyButton(context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      //decoration: ThemeHelper().buttonBoxDecoration(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: HexColor('#4A1F1F'), // background
            onPrimary: HexColor('#4A1F1A'),
            shape: StadiumBorder(), // foreground
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(
              'Apply Loan'.toUpperCase(),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          onPressed: () {
            //After successful login we will redirect to profile page. Let's create profile page now
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoanApprovedPage()));
          },
        ),
      ),
    );
  }
}
