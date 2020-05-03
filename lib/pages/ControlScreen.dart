

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';

import 'Menu.dart';

class ControlScreen extends StatefulWidget {
  static const routeName = 'control';
  String jwt;
  API api;

  ControlScreen({this.api, this.jwt});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Contrôle")
      ),
      body: Text("Page controle"),
      drawer: Menu(),
    );
  }
}