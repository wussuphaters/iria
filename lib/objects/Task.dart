import 'package:iria/objects/Device.dart';

class Task {
  String name;
  List<Device> devices;

  Task();

  Task.fromJson(Map<String, dynamic> data) {}
}
