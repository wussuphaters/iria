import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Device.dart';

class UpdateDeviceScreen extends StatefulWidget {
  static const routeName = '/devices/update';
  final API api;

  UpdateDeviceScreen({this.api});

  @override
  _UpdateDeviceScreenState createState() => _UpdateDeviceScreenState();
}

class _UpdateDeviceScreenState extends State<UpdateDeviceScreen> {
  Device user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Modifier l'appareil")
      ),
      body: Text("Page modif")
    );
  }
}