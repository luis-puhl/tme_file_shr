import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      // color: Colors.greenAccent,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/res/mipmap-xhdpi/ic_launcher.png')),
            Padding(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Your name...", hintStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                    onSubmitted: (String str) {
                      print(str);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Your phone...", hintStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                    onSubmitted: (String str) {
                      print(str);
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            ),
            RaisedButton(
              onPressed: () => print('tap'),
              child: Text("Let's Go", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            // Load image from assets
            image: AssetImage('assets/bg1.jpg'),
            // Make the image cover the whole area
            fit: BoxFit.cover,
          )
        ),
      ),
    );
  }
}
