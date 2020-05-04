import 'package:flutter/cupertino.dart';
import 'package:iria/pages/ControlScreen.dart';
import 'package:iria/pages/DevicesScreen.dart';
import 'package:iria/pages/LoginScreen.dart';
import 'package:iria/pages/UsersScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iria/pages/ProfileScreen.dart';
import 'Routes.dart';
import 'objects/API.dart';

class IriaApp extends StatelessWidget {
  final storage = FlutterSecureStorage();
  final api = API(addr: 'http://192.168.1.100/smart_home_api/api');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iria Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Routes.profile : (context) => ProfileScreen(),
        Routes.control : (context) => ControlScreen(api: api),
        Routes.login : (context) => LoginScreen(api: api),
        Routes.users : (context) => UsersScreen(api: api),
        Routes.devices : (context) => DevicesScreen(api: api)
      }
    );
  }
}