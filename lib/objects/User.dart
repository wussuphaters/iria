import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iria/Routes.dart';

class User  {
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String birthDate;
  bool isAdmin;
  String created;
  String expiration;
  String jwt;

  User();

  User.fromJson(Map<String, dynamic> data) {
    id=int.parse(data['id']);
    firstName = data['first_name'];
    lastName = data['last_name'];
    email = data['email'];
    phoneNumber = data['phone_number'];
    birthDate = data['birth_date'];
    isAdmin = data['is_admin'] == '1' ? true : false;
    created = data['created'];
    expiration = data['expiration'];
  }

  void logout(BuildContext context) {
    FlutterSecureStorage().delete(key: "jwt");
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, ModalRoute.withName(Routes.login));
  }
}