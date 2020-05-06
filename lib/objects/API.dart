import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:iria/objects/User.dart';

class API {
  String addr;
  String jwt;

  API({this.addr});

  Future<String> login(String email, String password) async {
    http.Response rep = await http.post(
      '${this.addr}/user/login.php',
      body: jsonEncode(<String, String>{
        'email' : email,
        'password' : password
      })
    );

    if(rep.statusCode == 200) {
      return json.decode(rep.body)['token'];
    } else return null;
  }

  Future<User> getUser() async {
    http.Response rep = await http.post(
      '${this.addr}/user/get_profile.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );
    if(rep.statusCode == 200) {
      var jsonUser = json.decode(rep.body)['user'];
      User user = User.fromJson(jsonUser);
      user.jwt = jwt;
      return user;
    } else return null;
  }

  Future<Map> getUsers() async  {
    http.Response response = await http.post(
      '${this.addr}/user/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    return jsonDecode(response.body);
  }

  Future<Map> getDevices() async  {
    http.Response response = await http.post(
      '${this.addr}/device/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    return jsonDecode(response.body);
  }

  Future<Map> getRooms() async  {
    http.Response response = await http.post(
      '${this.addr}/room/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    return jsonDecode(response.body);
  }

  Future<void> controlDevice(List payload) async  {
    await http.post(
      '${this.addr}/device/control.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'devices' : payload
      })
    );
  }

  Future<Map> getDeviceStatus(String id) async  {
    return http.post(
      '${this.addr}/device/get_status.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'device' : {
          'id': id
        }
      })
    ).then((response) {
      if(response.statusCode == 200) {
        Map status = json.decode(response.body)['status'];
        if(status.containsKey('bright')) status['bright'] = double.parse(status['bright']);
        if(status.containsKey('color_mode')) status['color_mode'] = double.parse(status['color_mode']);
        if(status.containsKey('ct')) status['ct'] = double.parse(status['ct']);
        if(status.containsKey('rgb')) {
          status['rgb'] = int.parse(status['rgb']).toRadixString(16);
        }
        
        return status;
      } else return (Map<String,dynamic>());
    });
  }

  Future<void> deleteUser(int id) async {
    await http.post(
      '${this.addr}/user/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'user' : {
          'id' : id
        }
      })
    );
  }

  Future<void> deleteDevice(int id) async {
    await http.post(
      '${this.addr}/device/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'device' : {
          'id' : id
        }
      })
    );
  }

  Future<void> deleteRoom(int id) async {
    await http.post(
      '${this.addr}/room/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'room' : {
          'id' : id
        }
      })
    );
  }
}