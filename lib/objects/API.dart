import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iria/objects/User.dart';

class API {
  String addr;

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

  Future<User> getUser(String jwt) async {
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
}