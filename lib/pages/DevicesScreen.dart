import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/DeviceCard.dart';
import 'package:iria/Menu.dart';
import 'package:iria/Routes.dart';
import 'package:iria/objects/API.dart';
import 'package:iria/objects/User.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';
  final API api;

  DevicesScreen({this.api});

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  User user;
  List devices;

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if(args != null) user = args['user'];
    
    return FutureBuilder(
      future: widget.api.getDevices(),
      builder: (context, AsyncSnapshot<Map> snapshot)  {
        if(snapshot.hasData)  {
          devices = snapshot.data['devices'];
          if(devices == null) user.logout(context);
        }
        return Scaffold(
          appBar: AppBar(
            title : Text("Appareils")
          ),
          body: snapshot.hasData ? ListView.builder(
            itemCount: devices.length,
            itemBuilder: (BuildContext context, int index)  {
              return DeviceCard(device: devices[index], api: widget.api);
            },
          ) : Center(
            child: FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, s) => s.connectionState == ConnectionState.done
                    ? Text("Impossible de se connecter à l'API.")
                    : 
                    CircularProgressIndicator()
            )
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, Routes.addDevice)
          ),
          drawer: Menu(user: user),
        );
      },
    );
  }
}