import 'package:flutter/cupertino.dart';
import 'package:iria/pages/AddDeviceScreen.dart';
import 'package:iria/pages/AddRoomScreen.dart';
import 'package:iria/pages/AddUserScreen.dart';
import 'package:iria/pages/ControlScreen.dart';
import 'package:iria/pages/DevicesScreen.dart';
import 'package:iria/pages/LoginScreen.dart';
import 'package:iria/pages/RoomsScreen.dart';
import 'package:iria/pages/UpdateDeviceScreen.dart';
import 'package:iria/pages/UpdateUserScreen.dart';
import 'package:iria/pages/UsersScreen.dart';
import 'package:flutter/material.dart';
import 'package:iria/pages/ProfileScreen.dart';
import 'Routes.dart';
import 'objects/API.dart';

class IriaApp extends StatefulWidget {
  @override
  _IriaAppState createState() => _IriaAppState();
}

class _IriaAppState extends State<IriaApp> {
  API api = API(addr: 'http://192.168.1.100/smart_home_api/api');

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
        Routes.devices : (context) => DevicesScreen(api: api),
        Routes.addUser : (context) => AddUserScreen(api: api),
        Routes.addDevice : (context) => AddDeviceScreen(api: api),
        Routes.updateUser : (context) => UpdateUserScreen(api: api),
        Routes.updateDevice : (context) => UpdateDeviceScreen(api: api),
        Routes.rooms : (context) => RoomsScreen(api: api),
        Routes.addRoom : (context) => AddRoomScreen(api: api)
      }
    );
  }
}