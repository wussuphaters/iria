import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';
  String jwt;
  API api;

  DevicesScreen({this.api, this.jwt});

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Appareils")
      ),
      body: Text("Page appareils"),
      drawer: Menu(admin: true),
    );
  }
}