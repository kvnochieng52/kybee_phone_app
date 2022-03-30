import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/ui/dashboard/dashboardPage.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepayLoanPage extends StatefulWidget {
  final int loanID;
  RepayLoanPage({Key key, @required this.loanID}) : super(key: key);

  @override
  _RepayLoanPageState createState() => _RepayLoanPageState();
}

class _RepayLoanPageState extends State<RepayLoanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _initDataFetched = false;
  String _mpesaPabill = '--';
  String _accountNumber = '--';
  String _balance = '--';

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'code': 'MPESA_PAYBILL',
      'loan_id': widget.loanID,
      'user_id': user['id'],
    };
    var res = await CallApi().postData(data, 'loan/repayment_details');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _initDataFetched = true;
        _mpesaPabill = body['mpesa_paybill'];
        _accountNumber = body['account_number'];
        _balance = body['balance'];
      });
    }
  }

  _copyPayBillNo() {
    Clipboard.setData(ClipboardData(text: _mpesaPabill));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        // duration: Duration(milliseconds: snacTime),
        content: Text("Business No. Copied!"),
        action: SnackBarAction(
          label: 'X',
          textColor: Colors.orange,
          onPressed: () {},
        ),
      ),
    );
  }

//widget.phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Repay Loan',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      drawer: drawer(context),
      body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 5.0, right: 5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, bottom: 30.0, left: 8.0, right: 8.0),
                child: ListTile(
                  title: Text(
                    "PAY THROUGH MPESA PAYBILL",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: HexColor('#4A1F1F'),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '1. Go to '),
                                TextSpan(
                                  text: ' M-PESA ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: 'on your phone '),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 17.9,
                                    color: Colors.grey,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: '2. Enter Business no. '),
                                    TextSpan(
                                      text: "$_mpesaPabill",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                child: Text("Copy"),
                                onPressed: () => _copyPayBillNo(),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '3. Enter Account No. '),
                                TextSpan(
                                  text: "$_accountNumber",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '4. Enter Amount: '),
                                TextSpan(
                                  text: "$_balance",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '5. Enter Your Mpesa PIN & Send '),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '6. You will receive a confirmation via SMS '),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17.9,
                                color: Colors.grey,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '-Payment reflects on your a/c within 30 minutes '),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: HexColor('#4A1F1F'), // background
                onPrimary: HexColor('#4A1F1A'),
                shape: StadiumBorder(), // foreground
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Text(
                  'Okay'.toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              onPressed: () {
                //After successful login we will redirect to profile page. Let's create profile page now
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
