import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class ControlScreen extends StatefulWidget {
  static const routeName = '/control';
  final API api;

  ControlScreen({this.api});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];

    return Scaffold(
      appBar: AppBar(
        title : Text("Contrôle")
      ),
      body: Text("Page controle"),
      drawer: Menu(user: user),
    );
  }
}