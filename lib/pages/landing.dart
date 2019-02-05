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
                    decoration: InputDecoration(
                      hintText: "Nome...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.face, color: Colors.white,),
                    ),
                    onSubmitted: (String str) {
                      print(str);
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Telefone...", 
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      prefixIcon: Icon(Icons.phone, color: Colors.white,),
                    ),
                    onSubmitted: (String str) {
                      print(str);
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, '/listing'),
              child: Text("Cadastrar",style: TextStyle(fontSize: 25.0),),
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
