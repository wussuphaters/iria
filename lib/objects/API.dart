import 'dart:convert';
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
      User user = User(jsonUser);
      user.jwt = jwt;
      return user;
    } else return null;
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

  void controlDevice(List payload) async  {
    http.Response response = await http.post(
      '${this.addr}/device/control.php',
      body: jsonEncode(<String, dynamic>{
        'token' : jwt,
        'devices' : payload
      })
    );
  }
}