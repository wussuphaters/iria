class User  {
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  DateTime birthDate;
  bool isAdmin;
  DateTime created;
  DateTime expiration;
  String jwt;

  User({this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.birthDate, this.isAdmin, this.created, this.expiration});
}