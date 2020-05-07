import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:iria/objects/User.dart';

class API {
  String addr;
  String jwt;
  String lastErrorMsg;

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
    } else  {
      lastErrorMsg = json.decode(rep.body)['error'];
      return null;
    }
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
    } else {
      lastErrorMsg = json.decode(rep.body)['error'];
      return null;
      }
  }

  Future<Map> getUsers() async  {
    http.Response response = await http.post(
      '${this.addr}/user/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getDevices() async  {
    http.Response response = await http.post(
      '${this.addr}/device/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<Map> getRooms() async  {
    http.Response response = await http.post(
      '${this.addr}/room/get_all.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
    return jsonDecode(response.body);
  }

  Future<void> controlDevice(List payload) async  {
    http.Response response = await http.post(
      '${this.addr}/device/control.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'devices' : payload
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
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
      } else  {
        lastErrorMsg = json.decode(response.body)['error'];
        return (Map<String,dynamic>());
      }
    });
  }

  Future<void> deleteUser(int id) async {
    http.Response response = await http.post(
      '${this.addr}/user/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'user' : {
          'id' : id
        }
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<void> deleteDevice(int id) async {
    http.Response response = await http.post(
      '${this.addr}/device/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'device' : {
          'id' : id
        }
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<void> deleteRoom(int id) async {
     http.Response response = await http.post(
      '${this.addr}/room/delete.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'room' : {
          'id' : id
        }
      })
    );

    if(response.statusCode != 200) lastErrorMsg = json.decode(response.body)['error'];
  }

  Future<bool> addUser(Map user) async {
    Map<String, dynamic> requestBody = {
      'token' : jwt,
      'user' : {
        'first_name' : user['first_name'],
        'last_name' : user['last_name'],
        'email' : user['email'],
        'password' : user['password'],
        'pin' : user['pin'],
        'phone_number' : user['phone_number'],
        'birth_date' : user['birth_date'],
        'is_admin' : user['is_admin']
      }
    };

    if(user['expiration'] != null) requestBody['expiration'] = user['expiration'];

    http.Response rep = await http.post(
      '${this.addr}/user/add.php',
      body: jsonEncode(requestBody)
    );

    if(rep.statusCode == 200) return true;
    else  {
      lastErrorMsg = jsonDecode(rep.body)['error'];
      return false;
    }
  }
}