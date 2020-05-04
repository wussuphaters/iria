import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/LightCard.dart';
import 'package:iria/Menu.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class ControlScreen extends StatefulWidget {
  static const routeName = '/control';
  final API api;

  ControlScreen({this.api});

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  User user;
  List devices;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];

    return FutureBuilder(
      future: widget.api.getLights(user.jwt),
      builder: (context, AsyncSnapshot<Map> snapshot)  {
        if(snapshot.hasData)  {
          devices = snapshot.data['lights'];
          print(devices);
          if(devices == null) user.logout(context);
        }
        return Scaffold(
          appBar: AppBar(
            title : Text("Contrôle")
          ),
          body: snapshot.hasData ? ListView.builder(
            itemCount: devices.length,
            itemBuilder: (BuildContext context, int index)  {
              return LightCard(device: devices[index]);
            },
          ) : Center(
            child: CircularProgressIndicator()
          ),
          drawer: Menu(user: user),
        );
      },
    );
  }
}