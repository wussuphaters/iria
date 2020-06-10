import 'package:flutter/material.dart';

class Device    {
  String id;
  String name;
  String addr;
  String type;
  String room;
  Map<String, dynamic> status;

  Device({this.id, this.name, this.addr, this.type, this.room, this.status});

  Device.fromJson(Map<String, dynamic> data) {
    print(data);
    id = data['id'];
    name = data['name'];
    addr = data['addr'];
    type = data['type'];
    room = data['room'];
  }

  Widget getIcon()  {
    IconData iconData;
    if(status.length == 0) iconData = Icons.warning;
    else if(type == "light-xiaomi" || type == "light-philips" || type == "light-tasmota") {
      iconData = Icons.lightbulb_outline;
    } else if(type == "lock") {
      if(status['state'] == "locked") iconData = Icons.lock;
      else if(status['state'] == "unlocked") iconData = Icons.lock_open;
      else iconData = Icons.help_outline;
    } else if(type == "switch-tasmota" || type == "ir-tasmota" || type == "momentary") {
      iconData = Icons.power_settings_new;
    } else iconData = Icons.help_outline;

    return Icon(iconData);
  }

  MaterialColor getColor()  {
    MaterialColor color;
    if(status.length == 0) color = Colors.grey;
    else if((type == "light-xiaomi" || type == "light-philips" || type == "light-tasmota" || type == "switch-tasmota") && status['power'] == "on")  {
      color = Colors.amber;
    } else color = Colors.grey;

    return color;
  }

  Map toggle() {
    Map payload;
    if(status.length == 0) payload = {};
    else if(type == "light-xiaomi" || type == "light-philips" || type == "light-tasmota" || type == "switch-tasmota") {
      if(status['power'] == "on") payload = {'id': id, 'power': "off"};
      else payload = {'id': id, 'power': "on"};
    } else if(type == "lock") {
      if(status['state'] == "unlocked") payload = {'id': id, 'state': "lock"};
      else if(status['state'] == "locked") payload = {'id': id, 'state': "unlock"};
    } else if(type == "ir-tasmota") {
      payload = {'id': id, 'action': 'power'};
    }else if(type == "momentary") {
      payload = {'id': id};
    } else  payload = {};

    return payload;
  }
}