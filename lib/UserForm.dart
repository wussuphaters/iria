import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class UserForm extends StatefulWidget  {
  final User user;
  final API api;

  UserForm({this.user, this.api});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _pinController;
  TextEditingController _passwordController;
  bool admin;
  bool expiration;
  User user;
  bool loading;
  final formKey = GlobalKey<FormState>();
  DateTime expirationDate;
  DateTime birthDate;

  @override
  void initState() {
    admin = false;
    expiration = false;
    loading = false;
    user= widget.user;
    _firstNameController = new TextEditingController(text: user != null ? user.firstName : "");
    _lastNameController = new TextEditingController(text: user != null ? user.lastName : "");
    _emailController = new TextEditingController(text: user != null ? user.email : "");
    _phoneNumberController = new TextEditingController(text: user != null ? user.phoneNumber : "");
    _passwordController = new TextEditingController();
    _pinController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: "Prénom"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez un prénom" : null;
              }
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: "Nom"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez un nom" : null;
              }
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Adresse email"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez une adresse email" : null;
              }
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Numéro de téléphone"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez un numéro de téléphone" : null;
              }
            ),
            DateTimeField(
              validator: (DateTime value)  {
                return value == null ? "Sélectionnez une date de naissance" : null;
              },
              format: DateFormat("yyyy-MM-dd"),
              decoration: InputDecoration(
                labelText: "Date de naissance"
              ),
              initialValue: user != null ? DateTime.parse(user.birthDate) : null,
              onShowPicker: (context, currentValue)  {
                return showDatePicker(
                  context: context,
                  initialDate: currentValue ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  confirmText: "OK",
                  cancelText: "ANNULER",
                  locale: Localizations.localeOf(context),
                  helpText: ""
                );
              },
              onChanged: (DateTime value) {
                setState(() {
                  birthDate = value;
                });
              }
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Mot de passe"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez un mot de passe" : null;
              }
            ),
            TextFormField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: "Code PIN"
              ),
              validator: (value)  {
                return value.isEmpty ? "Entrez un code PIN" : null;
              },
              inputFormatters: [WhitelistingTextInputFormatter(RegExp('[0-9A-D]'))]
            ),
            Row(children: <Widget>[
              Text("Administrateur"),
              Checkbox(
                value: admin,
                onChanged: (bool value) {
                  setState(() {
                    admin=value;
                  });
                },
              )
            ],),
            Row(children: <Widget>[
              Text("Expiration"),
              Checkbox(
                value: expiration,
                onChanged: (bool value) {
                  setState(() {
                    expiration=value;
                  });
                },
              )
            ],),
            expiration ? DateTimeField(
              validator: (DateTime value)  {
                return value == null ? "Sélectionnez une date d'expiration" : null;
              },
                decoration: InputDecoration(labelText: "Date d'expiration"),
                format: DateFormat("yyyy-MM-dd HH:mm:00"),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                    confirmText: "OK",
                    cancelText: "ANNULER",
                    locale: Localizations.localeOf(context),
                    helpText: ""
                  );
                  if(date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (DateTime value) {
                  setState(() {
                    expirationDate = value;
                  });
                }
              ) : SizedBox.shrink(),
            FlatButton(
              child: loading ? CircularProgressIndicator() : (user != null ? Text("Modifier") : Text("Ajouter")),
              onPressed: () async {
                if(formKey.currentState.validate()) {
                  setState(() {
                    loading = true;
                  });
                  bool rep =await widget.api.addUser({'first_name': _firstNameController.text, 'last_name': _lastNameController.text, 'email': _emailController.text, 'password': _passwordController.text, 'pin': _pinController.text, 'phone_number': _phoneNumberController.text, 'birth_date': birthDate.toString(), 'expiration': expirationDate.toString(), 'is_admin': admin});
                  if(rep) {
                    Fluttertoast.showToast(
                      msg: "Utilisateur ajouté avec succès"
                    );
                    Navigator.pop(context);
                  } else{
                    showDialog(
                      context: context,
                      builder: (context) =>
                        AlertDialog(
                          title: Text("Impossible d'ajouter l'utilisateur"),
                          content: Text(widget.api.lastErrorMsg)
                        ),
                    );
                    setState(() {
                      loading = false;
                    });
                  }
                }
              }
            )
          ]
        )
      )
    );
  }
}