import 'dart:convert';
import 'package:http/http.dart' as http;

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

    print("allo");
    print(rep.body);

    if(rep.statusCode == 200) {
      return json.decode(rep.body)['token'];
    } else return null;
  }

  /*var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));

  Future<User> getUser(String jwt) async {
    http.Response rep = await http.post(
      '${this.addr}/user/get_by_token.php',
      body: jsonEncode(<String, String>{
        'token' : jwt
      })
    );

    if(rep.statusCode == 200) {
      return json.decode(rep.body)['token'];
    } else return null;
  }*/
}