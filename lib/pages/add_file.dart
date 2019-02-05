import 'package:flutter/material.dart';

class AddFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.greenAccent,
      child: InkWell(
        onTap: () => print('tap'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Icon", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
            Text("File Name", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
            Text("find file", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
            Text("Print!", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}