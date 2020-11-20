import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:iria/objects/User.dart';

class API {
  String addr;
  String jwt;
  String lastErrorMsg;

  Future<String> getAddr() async {
    /*var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      var wifiName = await Connectivity().getWifiName();
      var bssid = await IosNetworkInfo.bssid;
      print(bssid);
      if (wifiName == "tuveuxdupoulet" || wifiName == "tuveuxdladinde")
        return "http://192.168.1.100/smart_home_api/api";
    }

    return "http://176.191.181.154:27323/smart_home_api/api";*/

    return "http://192.168.1.100/smart_home_api/api";
  }

  Future<String> login(String email, String password) async {
    http.Response rep = await http.post('${this.addr}/user/login.php',
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    if (rep.statusCode == 200) {
      return json.decode(rep.body)['token'];
    } else {
      lastErrorMsg = json.decode(rep.body)['error'];
      return null;
    }
  }

  Future<User> getUser() async {
    http.Response rep = await http.post('${this.addr}/user/get_profile.php',
        body: jsonEncode(<String, String>{'token': jwt}));
    if (rep.statusCode == 200) {
      var jsonUser = json.decode(rep.body)['user'];
      User user = User.fromJson(jsonUser);
      user.jwt = jwt;
      return user;
    } else {
      lastErrorMsg = json.decode(rep.body)['error'];
      return null;
    }
  }

  Future<Map> getUsers() async {
    http.Response response = await http.post('${this.addr}/user/get_all.php',
        body: jsonEncode(<String, String>{'token': jwt}));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getDevices() async {
    http.Response response = await http.post('${this.addr}/device/get_all.php',
        body: jsonEncode(<String, String>{'token': jwt}));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getRooms() async {
    http.Response response = await http.post('${this.addr}/room/get_all.php',
        body: jsonEncode(<String, String>{'token': jwt}));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getTasks() async {
    http.Response response = await http.post('${this.addr}/task/get_all.php',
        body: jsonEncode(<String, String>{'token': jwt}));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getDeviceTypes() async {
    http.Response response = await http.post(
        '${this.addr}/devices/get_types.php',
        body: jsonEncode(<String, String>{'token': jwt}));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<bool> controlDevice(List payload) async {
    http.Response response = await http.post('${this.addr}/device/control.php',
        body: jsonEncode(<String, dynamic>{'token': jwt, 'devices': payload}));

    print(jsonEncode(<String, dynamic>{'token': jwt, 'devices': payload}));

    if (response.statusCode != 200) {
      lastErrorMsg = json.decode(response.body)['error'];
      return false;
    }
    return true;
  }

  Future<Map> getDeviceStatus(String id) async {
    return http
        .post('${this.addr}/device/get_status.php',
            body: jsonEncode(<String, dynamic>{
              'token': jwt,
              'device': {'id': id}
            }))
        .then((response) {
      if (response.statusCode == 200) {
        Map status = json.decode(response.body)['status'];
        if (status.containsKey('bright'))
          status['bright'] = double.parse(status['bright']);
        if (status.containsKey('color_mode'))
          status['color_mode'] = double.parse(status['color_mode']);
        if (status.containsKey('ct')) status['ct'] = double.parse(status['ct']);
        if (status.containsKey('rgb')) {
          status['rgb'] = int.parse(status['rgb']).toRadixString(16);
        }
        return status;
      } else {
        lastErrorMsg = json.decode(response.body)['error'];
        return (Map<String, dynamic>());
      }
    });
  }

  Future<void> deleteUser(int id) async {
    http.Response response = await http.post('${this.addr}/user/delete.php',
        body: jsonEncode(<String, dynamic>{
          'token': jwt,
          'user': {'id': id}
        }));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<void> deleteDevice(int id) async {
    http.Response response = await http.post('${this.addr}/device/delete.php',
        body: jsonEncode(<String, dynamic>{
          'token': jwt,
          'device': {'id': id}
        }));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<void> deleteRoom(int id) async {
    http.Response response = await http.post('${this.addr}/room/delete.php',
        body: jsonEncode(<String, dynamic>{
          'token': jwt,
          'room': {'id': id}
        }));

    if (response.statusCode != 200)
      lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<bool> addUser(Map user) async {
    Map<String, dynamic> requestBody = {'token': jwt, 'user': {}};

    user.forEach((key, value) {
      requestBody['user'][key] = value;
    });

    http.Response rep = await http.post('${this.addr}/user/add.php',
        body: jsonEncode(requestBody));

    if (rep.statusCode == 200)
      return true;
    else {
      lastErrorMsg = jsonDecode(rep.body)['error'];
      return false;
    }
  }

  Future<bool> updateUser(Map user) async {
    Map<String, dynamic> requestBody = {'token': jwt, 'user': {}};

    user.forEach((key, value) {
      requestBody['user'][key] = value;
    });

    print(jsonEncode(requestBody));

    http.Response rep = await http.post('${this.addr}/user/update.php',
        body: jsonEncode(requestBody));

    if (rep.statusCode == 200)
      return true;
    else {
      lastErrorMsg = jsonDecode(rep.body)['error'];
      return false;
    }
  }
}
