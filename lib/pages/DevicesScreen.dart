import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';
  final API api;

  DevicesScreen({this.api});

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  User user;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];

    print(user);
    
    return Scaffold(
      appBar: AppBar(
        title : Text("Appareils")
      ),
      body: Text("Page appareils"),
      drawer: Menu(user: user),
    );
  }
}