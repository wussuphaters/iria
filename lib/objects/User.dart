import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iria/Routes.dart';

class User  {
  int id;
  String firstName;
  String lastName;
  String gender;
  String email;
  String phoneNumber;
  DateTime birthDate;
  bool isAdmin;
  String created;
  DateTime expiration;
  String jwt;

  User();

  User.fromJson(Map<String, dynamic> data) {
    id=int.parse(data['id']);
    firstName = data['first_name'];
    lastName = data['last_name'];
    gender = data['gender'];
    email = data['email'];
    phoneNumber = data['phone_number'];
    birthDate = DateTime.parse(data['birth_date']);
    isAdmin = data['is_admin'] == '1' ? true : false;
    created = data['created'];
    expiration = DateTime.parse(data['expiration']);
    if(expiration.isAfter(DateTime.now().add(Duration(days: 365)))) expiration = null;
  }

  void logout(BuildContext context) {
    FlutterSecureStorage().delete(key: "jwt");
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, ModalRoute.withName(Routes.login));
  }
}