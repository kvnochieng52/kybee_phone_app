import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kybee/api/api.dart';
import 'package:kybee/ui/loading.dart';
import 'package:kybee/ui/progress.dart';
import 'package:kybee/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesPage extends StatefulWidget {
  // const MessagesPage({Key? key}): super(key:key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _initDataFetched = false;
  List _notifications = [];

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
    var res = await CallApi().postData(data, 'notification/get');
    var body = json.decode(res.body);

    if (body['success']) {
      setState(() {
        _initDataFetched = true;
        _notifications = body['notifications'];
      });
    }
  }

  Future<Null> _refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 3));
    _getInitData();

    return null;
  }

  Widget _buildBody(context) {
    return ListView.builder(
        // physics: ClampingScrollPhysics(),
        // shrinkWrap: true,
        itemCount: _notifications.length,
        padding: EdgeInsets.all(8.5),
        itemBuilder: (BuildContext context, int position) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.chat, color: HexColor('#4A1F1F')),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        " ${_notifications[position]['created_formatted']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor('#4A1F1F'),
                          //fontSize: 18.9,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    " ${_notifications[position]['message']}",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                onTap: () => null,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        drawer: drawer(context),
        body: RefreshIndicator(
          key: refreshKey,
          child: _initDataFetched ? _buildBody(context) : circularProgress(),
          onRefresh: _refreshList,
        ));
  }
}
