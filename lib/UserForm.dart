import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class UserForm extends StatefulWidget {
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
  TextEditingController _phoneIpController;
  bool admin;
  bool expiration;
  User user;
  bool loading;
  final formKey = GlobalKey<FormState>();
  DateTime expirationDate;
  DateTime birthDate;
  String gender;

  @override
  void initState() {
    user = widget.user;
    admin = user != null ? user.isAdmin : false;
    expiration =
        user != null ? (user.expiration != null ? true : false) : false;
    loading = false;
    _firstNameController =
        new TextEditingController(text: user != null ? user.firstName : "");
    _lastNameController =
        new TextEditingController(text: user != null ? user.lastName : "");
    _emailController =
        new TextEditingController(text: user != null ? user.email : "");
    _phoneNumberController =
        new TextEditingController(text: user != null ? user.phoneNumber : "");
    _phoneIpController =
        new TextEditingController(text: user != null ? user.phoneIp : "");
    _passwordController = new TextEditingController();
    _pinController = new TextEditingController();
    gender = user != null ? user.gender : 'Homme';
    expirationDate = user != null ? user.expiration : null;
    birthDate = user != null ? user.birthDate : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: "Prénom"),
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                  validator: (value) {
                    return value.isEmpty ? "Entrez un prénom" : null;
                  }),
              TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: "Nom"),
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                  validator: (value) {
                    return value.isEmpty ? "Entrez un nom" : null;
                  }),
              DropdownButton(
                  value: gender,
                  items: <String>['Homme', 'Femme'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => gender = value)),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Adresse email"),
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                  validator: (value) {
                    return value.isEmpty ? "Entrez une adresse email" : null;
                  }),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: "Numéro de téléphone"),
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  validator: (value) {
                    if (value.isEmpty)
                      return "Entrez un numéro de téléphone";
                    else if (value.length < 10)
                      return "Le numéro de téléphone n'est pas valide";
                    else
                      return null;
                  }),
              TextFormField(
                controller: _phoneIpController,
                decoration: InputDecoration(labelText: "Adresse IP sur le LAN"),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
              ),
              DateTimeField(
                  validator: (DateTime value) {
                    return value == null
                        ? "Sélectionnez une date de naissance"
                        : null;
                  },
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: InputDecoration(labelText: "Date de naissance"),
                  initialValue: user != null ? user.birthDate : null,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        initialDate: currentValue ?? DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        confirmText: "OK",
                        cancelText: "ANNULER",
                        locale: Localizations.localeOf(context),
                        helpText: "");
                  },
                  onChanged: (DateTime value) {
                    setState(() {
                      birthDate = value;
                    });
                  }),
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Mot de passe"),
                  validator: (value) {
                    if (user == null || value.length > 0) {
                      if (value.isEmpty)
                        return "Entrez un mot de passe";
                      else if (value.length < 8)
                        return "Le mot de passe doit faire au moins 8 caractères";
                      else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value))
                        return "Minuscule, majuscule, chiffre et caractère spécial";
                      else
                        return null;
                    } else
                      return null;
                  }),
              TextFormField(
                  controller: _pinController,
                  decoration: InputDecoration(labelText: "Code PIN"),
                  validator: (value) {
                    if (user == null || value.length > 0) {
                      if (value.isEmpty)
                        return "Entrez un code PIN";
                      else if (value.length < 8)
                        return "Le code PIN doit faire 8 caractères";
                      else if (!RegExp(r'^(?=.*[A-D])(?=.*\d)[A-D\d]{8,}$')
                          .hasMatch(value))
                        return "Le PIN doit être un mélange de chiffres et de lettres (A/B/C/D)";
                      else
                        return null;
                    } else
                      return null;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp('[0-9A-D]')),
                    LengthLimitingTextInputFormatter(8)
                  ]),
              Row(children: <Widget>[
                Text("Administrateur"),
                Checkbox(
                  value: admin,
                  onChanged: (bool value) {
                    setState(() {
                      admin = value;
                    });
                  },
                )
              ]),
              Row(
                children: <Widget>[
                  Text("Expiration"),
                  Checkbox(
                    value: expiration,
                    onChanged: (bool value) {
                      setState(() {
                        expiration = value;
                        if (!expiration) expirationDate = null;
                      });
                    },
                  )
                ],
              ),
              expiration
                  ? DateTimeField(
                      validator: (DateTime value) {
                        return value == null
                            ? "Sélectionnez une date d'expiration"
                            : null;
                      },
                      initialValue: user != null ? user.expiration : null,
                      decoration:
                          InputDecoration(labelText: "Date d'expiration"),
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
                            helpText: "");
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
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
                      })
                  : SizedBox.shrink(),
              FlatButton(
                  child: loading
                      ? CircularProgressIndicator()
                      : (user != null ? Text("Modifier") : Text("Ajouter")),
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      bool rep;
                      if (user != null)
                        rep = await widget.api.updateUser({
                          'id': user.id,
                          'gender': gender,
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'pin': _pinController.text,
                          'phone_number': _phoneNumberController.text,
                          'phone_ip': _phoneIpController.text,
                          'birth_date': birthDate.toString(),
                          'expiration':
                              expiration ? expirationDate.toString() : "",
                          'is_admin': admin ? 1 : 0
                        });
                      else
                        rep = await widget.api.addUser({
                          'gender': gender,
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'pin': _pinController.text,
                          'phone_number': _phoneNumberController.text,
                          'phone_ip': _phoneIpController.text,
                          'birth_date': birthDate.toString(),
                          'expiration':
                              expiration ? expirationDate.toString() : "",
                          'is_admin': admin ? 1 : 0
                        });
                      if (rep) {
                        Fluttertoast.showToast(
                            msg: "Utilisateur " +
                                (user == null ? "ajouté" : "modifié") +
                                " avec succès");
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text("Impossible " +
                                  (user == null ? "d'ajouter" : "de modifier") +
                                  " l'utilisateur"),
                              content: Text(widget.api.lastErrorMsg)),
                        );
                        setState(() {
                          loading = false;
                        });
                      }
                    }
                  })
            ])));
  }
}
