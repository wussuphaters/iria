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
}