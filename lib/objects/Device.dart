import 'package:flutter/material.dart';

class Device    {
  String id;
  String name;
  String addr;
  String type;
  String room;
  Map status;

  Device({this.id, this.name, this.addr, this.type, this.room, this.status});

  Widget getIcon()  {
    IconData iconData;
    if(type == "light-xiaomi" || type == "light-philips") {
      iconData = Icons.lightbulb_outline;
    } else if(type == "lock") {
      if(status['state'] == "unlocked") iconData = Icons.lock_open;
      else iconData = Icons.lock;
    }

    return Icon(iconData);
  }

  MaterialColor getColor()  {
    if((type == "light-xiaomi" || type == "light-philips") && status['power'] == "on")  {
      return Colors.amber;
    } else return Colors.grey;
  }

  Map toggle() {
    if(type == "light-xiaomi" || type == "light-philips") {
      if(status['power'] == "on") status['power'] = "off";
      else status['power'] = "on";
      return {'id': id, 'power': status['power']};
    } else if(type == "lock") {
      if(status['state'] == "unlock") status['state'] = "lock";
      else status['state'] = "unlock";
      return {'id': id, 'state': status['state']};
    } else return {};
  }
}