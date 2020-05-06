import 'package:iria/pages/AddDeviceScreen.dart';
import 'package:iria/pages/AddUserScreen.dart';
import 'package:iria/pages/ControlScreen.dart';
import 'package:iria/pages/DevicesScreen.dart';
import 'package:iria/pages/LoginScreen.dart';
import 'package:iria/pages/ProfileScreen.dart';
import 'package:iria/pages/RoomsScreen.dart';
import 'package:iria/pages/UpdateDeviceScreen.dart';
import 'package:iria/pages/UpdateUserScreen.dart';
import 'package:iria/pages/UsersScreen.dart';
import 'package:iria/pages/AddRoomScreen.dart';

class Routes  {
  static const String login = LoginScreen.routeName;
  static const String profile = ProfileScreen.routeName;
  static const String control = ControlScreen.routeName;
  static const String users = UsersScreen.routeName;
  static const String devices = DevicesScreen.routeName;
  static const String addUser = AddUserScreen.routeName;
  static const String addDevice = AddDeviceScreen.routeName;
  static const String updateUser = UpdateUserScreen.routeName;
  static const String updateDevice = UpdateDeviceScreen.routeName;
  static const String rooms = RoomsScreen.routeName;
  static const String addRoom = AddRoomScreen.routeName;
}