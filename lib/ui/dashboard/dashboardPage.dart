import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/loan/PendingApprovalPage.dart';
import 'package:kybee/ui/loan/RepayLoanPage.dart';
import 'package:kybee/ui/login.dart';
import 'package:kybee/ui/profile/basicDetailsPage.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:kybee/widgets/headerMain.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String _currency = '-';
  int _loanpaymentDays = 0;

  String _totalLoanAmount = "-";
  String _intrest = "-";
  String _commission = "-";
  String _loanDisbursed = "-";
  String _applicationDateFormatted = "-";
  String _dueDateFormatted = "-";

  String _statementDetails = "-";

  String _displalRepayment = '-';

  String _repaymentTotalAmount = "-";
  String _repaymentApplicationDate = "-";
  String _repaymentDueDate = "-";
  String _repaymentLoanStatus = "-";
  String _repaymentColrCode = "#000000";
  String _repaymentLoanDetails = "-";
  String _repaymentLoanBalance = "-";
  String _repaymentLoanAmountPaid = "-";
  int _repaymentLoanID;
  int _repaymentLoanStatusID;

  bool _initDataFetched = false;

  bool _activeLoan = false;
  bool _applyLoanLoading = false;

  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  // Position _currentPosition;
  String _currentAddress = '';
  bool _currentPositionFetched = false;

  void initState() {
    super.initState();
    _getInitData();
  }

  Future<PermissionStatus> _geLocationtPermission() async {
    final PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.location].request();
      return permissionStatus[Permission.location];
    } else {
      return permission;
    }
  }

  // _getCurrentLocationProcess() async {
  //   final PermissionStatus permissionStatus = await _geLocationtPermission();
  //   if (permissionStatus == PermissionStatus.granted) {
  //     _getCurrentLocation();
  //   } else {
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     localStorage.remove('user');
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LoginPage(),
  //       ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             "Please Grant Kybee Permissions to get location through the phone settings"),
  //       ),
  //     );
  //   }
  // }

  // _getCurrentLocation() {
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });

  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     // print(e);
  //   });
  // }

  // _getAddressFromLatLng() async {
  //   try {
  //     if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
  //       List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //           _currentPosition.latitude, _currentPosition.longitude);

  //       Placemark place = p[0];
  //       setState(() {
  //         _currentAddress =
  //             "${place.locality}, ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.country}, ${place.thoroughfare}, ${place.subThoroughfare}";
  //         _currentPositionFetched = true;
  //       });
  //     }
  //   } catch (e) {
  //     //print(e);
  //   }
  // }

  _refreshStatus(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(),
      ),
    );
  }

  _calculateLoan(context) async {
    Loading().loader(context, "Loading...Please wait");

    var data = {
      'distribution_id': _loanDistribution,
    };
    var res = await CallApi().postData(data, 'loan/calculate_loan');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _loanpaymentDays = body['loan_details']['loan_details']['period'];
        _totalLoanAmount = body['loan_details']['total_loan_amount_formatted'];
        _intrest = body['loan_details']['intrest_formatted'];
        _commission = body['loan_details']['commission_formatted'];
        _loanDisbursed = body['loan_details']['disbursed_formatted'];
        _applicationDateFormatted =
            body['loan_details']['application_date_formatted'];
        _dueDateFormatted = body['loan_details']['due_date_formatted'];
        _displalRepayment =
            body['loan_details']['repayment_formatted'].toString();
      });
    }

    Navigator.pop(context);
  }

  _repayLoan(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepayLoanPage(
          loanID: _repaymentLoanID,
        ),
      ),
    );
  }

  _closeLoan(context) async {
    Loading().loader(context, "Loading...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
      'loan_id': _repaymentLoanID,
    };
    var res = await CallApi().postData(data, 'loan/close_loan');
    var body = json.decode(res.body);
    if (body['success']) {
      Navigator.pop(context);
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ),
      );
    }

    Navigator.pop(context);
  }

  _applyLoan(context) async {
    Loading().loader(context, "Loading...Please wait");

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    var data = {
      'user_id': user['id'],
      'loan_distribution_id': _loanDistribution,
    };
    var res = await CallApi().postData(data, 'loan/apply_loan');
    var body = json.decode(res.body);

    if (body['success']) {
      Navigator.pop(context);
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PendingApprovalPage(),
        ),
      );
    } else {
      var snacTime = body['error_code'] == 1 ? 20000 : 15000;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: snacTime),
          content: Text(body['message']),
          action: SnackBarAction(
            label: body['error_code'] == 1 ? 'TAKE ME THERE' : 'X',
            textColor: Colors.orange,
            onPressed: () {
              if (body['error_code'] == 1) {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicDetailsPage(),
                  ),
                );
              }
            },
          ),
        ),
      );
    }

    setState(() {
      _applyLoanLoading = true;
    });

    Navigator.pop(context);
  }

  _getInitData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    // _getCurrentLocationProcess();

    var data = {
      'user_id': user['id'],
      'current_address': _currentAddress,
    };

    var res = await CallApi().postData(data, 'loan/dashboard_init');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _loanDistributions = body['loan_distributions'];
          _statementDetails = body['statement_details'];
          _loanDistribution = body['user_details']['loan_distribution_id'];
          _loanpaymentDays = body['user_details']['period'];
          _currency = body['currency'];
          _displalRepayment =
              body['default_loan']['repayment_formatted'].toString();
          _totalLoanAmount =
              body['default_loan']['total_loan_amount_formatted'].toString();
          _intrest = body['default_loan']['intrest_formatted'].toString();
          _commission = body['default_loan']['commission_formatted'].toString();
          _loanDisbursed =
              body['default_loan']['disbursed_formatted'].toString();
          _dueDateFormatted =
              body['default_loan']['due_date_formatted'].toString();
          _applicationDateFormatted =
              body['default_loan']['application_date_formatted'].toString();
          _initDataFetched = true;

          if (body['active_loan']) {
            _repaymentTotalAmount = body['active_loan_details']
                    ['total_amount_formatted']
                .toString();
            _repaymentApplicationDate = body['active_loan_details']
                    ['application_date_formatted']
                .toString();
            _repaymentDueDate =
                body['active_loan_details']['due_date_formatted'].toString();
            _activeLoan = body['active_loan'];
            //  _activeLoanDetails = body['active_loan_details'];
            _repaymentLoanStatus =
                body['active_loan_details']['loan_status_name'];
            _repaymentColrCode = body['active_loan_details']['color_code'];
            _repaymentLoanDetails = body['active_loan_details']['description'];
            _repaymentLoanBalance =
                body['active_loan_details']['balance_formatted'].toString();
            _repaymentLoanAmountPaid =
                body['active_loan_details']['amount_paid_formatted'].toString();
            _repaymentLoanID = body['active_loan_details']['id'];
            _repaymentLoanStatusID =
                body['active_loan_details']['loan_status_id'];
          }
        });
      }
    }
  }

  _formatCurrency(double d) {
    String inString = d.toStringAsFixed(0);
    var formatter = NumberFormat('#,##,000');
    return formatter.format(double.tryParse(inString));
  }

  _refreshScreen(context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(),
      ),
    );
    // _initDataFetched = false;
    // Loading().loader(context, "Loading...Please wait");
    // _getInitData();
    // Navigator.pop(context);
  }

  _activeLoanScreen(context) {
    return ListView(children: <Widget>[
      Container(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
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
                            "LOAN STATUS",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      label: Text('Refresh',
                          style: TextStyle(color: Colors.white)),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () => _refreshStatus(context),
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
                        "Loan Status",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      DecoratedBox(
                        decoration:
                            BoxDecoration(color: HexColor(_repaymentColrCode)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            _repaymentLoanStatus,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
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
                        "Total Repayment Amount",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "$_currency $_repaymentTotalAmount",
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
                        "Amount Paid",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "$_currency $_repaymentLoanAmountPaid",
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
                        "Loan Balance",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "$_currency $_repaymentLoanBalance",
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
                        "Application Date",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text(
                        "$_repaymentApplicationDate",
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
                        "$_repaymentDueDate",
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20.0,
                        color: HexColor(_repaymentColrCode),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Text(
                          _repaymentLoanDetails,
                          style: TextStyle(
                            color: HexColor(_repaymentColrCode),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: (_repaymentLoanStatusID == 4 ||
                              _repaymentLoanStatusID == 3)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: HexColor('#4A1F1F'), // background
                                onPrimary: HexColor('#4A1F1A'),
                                shape: StadiumBorder(), // foreground
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  _repaymentLoanStatusID == 4
                                      ? "Repay Loan"
                                      : "Close",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () => _repaymentLoanStatusID == 4
                                  ? _repayLoan(context)
                                  : _closeLoan(context))
                          : Text("-------------------------"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: _repaymentLoanStatusID == 1
                          ? Text(
                              "$_statementDetails",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.red,
                                fontSize: 16.0,
                              ),
                            )
                          : Text(""),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Dashboard'),
      drawer: drawer(context),
      body:
          _activeLoan ? _activeLoanScreen(context) : _buildBodyptions(context),
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
            ? DropdownButton(
                value: _loanDistribution,
                isExpanded: false,
                hint: Text("Select Loan"),
                // validator: (value) => value == null ? 'Select Gender' : null,
                onChanged: (value) {
                  setState(() {
                    _loanDistribution = value;
                    _calculateLoan(context);
                  });
                },
                items: _loanDistributions.map((distribution) {
                  return DropdownMenuItem(
                    value: distribution['id'],
                    child: Text(_currency +
                        " " +
                        _formatCurrency(
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
                      "$_currency $_loanDisbursed",
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
                      "$_currency $_displalRepayment",
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
              // Padding(
              //   padding: const EdgeInsets.only(top: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         "Interest &  Comission rates Ranges up to 10% APR",
              //         style: TextStyle(fontSize: 14.0),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 15.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         "loan Terms from 91 to 365 Days",
              //         style: TextStyle(fontSize: 14.0),
              //       ),
              //     ],
              //   ),
              // ),
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
                      "$_currency $_displalRepayment",
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
                _initDataFetched ? 'Apply Loan' : 'Loading...please wait',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            onPressed: () => _initDataFetched || _applyLoanLoading
                ? _applyLoan(context)
                : null),
      ),
    );
  }
}
