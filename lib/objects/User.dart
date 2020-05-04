class User  {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String birthDate;
  bool isAdmin;
  String created;
  String expiration;
  String jwt;

  User(Map<String, dynamic> data) {
    id=data['id'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    email = data['email'];
    phoneNumber = data['phone_number'];
    birthDate = data['birth_date'];
    isAdmin = data['is_admin'] == '1' ? true : false;
    created = data['created'];
    expiration = data['expiration'];
  }
}