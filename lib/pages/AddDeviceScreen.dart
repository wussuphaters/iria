import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/Device.dart';

class AddDeviceScreen extends StatefulWidget {
  static const routeName = '/devices/add';
  final API api;

  AddDeviceScreen({this.api});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  Device device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Ajouter un appareil")
      ),
      body: Text("Page ajout")
    );
  }
}