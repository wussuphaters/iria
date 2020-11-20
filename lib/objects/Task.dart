import 'package:flutter/material.dart';

class Task {
  int id;
  String name;
  String triggerType;
  String triggerAlias;
  String triggerValue;
  int userId;
  int actionCount;

  Task();

  Task.fromJson(Map<String, dynamic> data) {
    id = int.parse(data['id']);
    name = data['name'];
    triggerType = data['trigger_type'];
    triggerAlias = data['trigger_alias'];
    triggerValue = data['trigger_value'];
    userId = int.parse(data['user_id']);
    actionCount = int.parse(data['action_count']);
  }

  Widget getIcon() {
    IconData iconData;
    if (triggerType == "cron") {
      iconData = Icons.timer;
    } else if (triggerType == "sensor") {
      iconData = Icons.settings_remote;
    } else
      iconData = Icons.help_outline;

    return Icon(iconData);
  }
}
