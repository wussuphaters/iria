import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iria/objects/API.dart';

class LightCard extends StatefulWidget  {
  final Map device;
  final API api;

  LightCard({this.device, this.api});

  @override
  _LightCardState createState() => _LightCardState();
}

class _LightCardState extends State<LightCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.device);

    return Card(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.lightbulb_outline),
            color: widget.device['status']['power'] == "on" ? Colors.amber : Colors.grey,
            onPressed: (){},
          ),
          Text(widget.device['name'])
        ],
      )
    );
  }
}