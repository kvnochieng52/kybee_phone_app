import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/ui/terms_conditions/TermsConditionsPage.dart';
import 'package:kybee/widgets/headerMain.dart';
import 'package:hexcolor/hexcolor.dart';

class MetaDataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MetaDataState();
  }
}

class _MetaDataState extends State<MetaDataPage> {
  String _currency = '-';
  int _loanpaymentDays = 0;

  String _totalLoanAmount = "-";
  String _intrest = "-";
  String _commission = "-";
  String _loanDisbursed = "-";
  String _applicationDateFormatted = "-";
  String _dueDateFormatted = "-";
  String _repayment = "-";

  bool _initDataFetched = false;

  void initState() {
    super.initState();
    _getInitData();
  }

  _getInitData() async {
    var data = {};

    var res = await CallApi().postData(data, 'loan/meta_init');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _repayment = body['loan_meta_details']['calculations']
                  ['repayment_formatted']
              .toString();
          _loanpaymentDays = body['loan_meta_details']['period'];
          _currency = body['currency'];
          _totalLoanAmount = body['loan_meta_details']['calculations']
                  ['total_loan_amount_formatted']
              .toString();
          _intrest = body['loan_meta_details']['calculations']
                  ['intrest_formatted']
              .toString();
          _commission = body['loan_meta_details']['calculations']
                  ['commission_formatted']
              .toString();
          _loanDisbursed = body['loan_meta_details']['calculations']
                  ['disbursed_formatted']
              .toString();
          _dueDateFormatted = body['loan_meta_details']['calculations']
                  ['due_date_formatted']
              .toString();
          _applicationDateFormatted = body['loan_meta_details']['calculations']
                  ['application_date_formatted']
              .toString();
          _initDataFetched = true;
        });
      }
    }
  }

  _refreshScreen(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MetaDataPage(),
      ),
    );
    // _initDataFetched = false;
    // Loading().loader(context, "Loading...Please wait");
    // _getInitData();
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Dashboard'),
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
        child: _initDataFetched
            ? Text(
                "$_currency $_totalLoanAmount",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  height: 25.0,
                  width: 25.0,
                ),
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
                  _initDataFetched ? "$_loanpaymentDays Days" : "Loading...",
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
                    onPressed: () => _refreshScreen(context),
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
                      "$_currency $_totalLoanAmount",
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
                      "$_currency $_repayment",
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
                      "$_currency $_intrest",
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
                      "Service Fee",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "$_currency $_commission",
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
                      "Interest &  Service fee rates Ranges up to 16% APR",
                      style: TextStyle(fontSize: 14.0),
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
                      "loan Terms from 91 to 365 Days",
                      style: TextStyle(fontSize: 14.0),
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
                      "$_applicationDateFormatted",
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
                      "$_dueDateFormatted",
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
                      "$_currency $_repayment",
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
              _initDataFetched ? 'LOGIN/REGISTER' : 'Loading...please wait',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          onPressed: () => _initDataFetched
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsandConditionsPage(),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
