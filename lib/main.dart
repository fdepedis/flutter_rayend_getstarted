import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'string.dart';

void main() => runApp(GHFlutterApp());

class GHFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      home: GHFlutter(),
    );
  }
}

class GHFlutter extends StatefulWidget {
  @override
  createState() => GHFlutterState();
}

class GHFlutterState extends State<GHFlutter> {
  var _members = <Member>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appTitle),
      ),
      body: ListView.builder(
          itemCount: _members.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }),
    );
  }

  // _loadData() i call when the state is initialized
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response response = await http.get(dataURL);
    setState(() {
      final membersJSON = json.decode(response.body);

      for (var memberJSON in membersJSON) {
        final member = Member(memberJSON["login"]);
        //dev.log('member: $member');
        _members.add(member);
      }
    });
  }

  Widget _buildRow(int i) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            ListTile(title: Text("${_members[i].login}", style: _biggerFont)));
  }
}

class Member {
  final String login;

  Member(this.login) {
    if (login == null) {
      throw ArgumentError("login of Member cannot be null. Received: '$login'");
    }
  }
}
