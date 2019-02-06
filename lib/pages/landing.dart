import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';

class Landing extends StatelessWidget {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

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
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Nome...",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.face,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: "Telefone...",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            ScopedModelDescendant<User>(
              builder: (context, child, model) => RaisedButton(
                onPressed: () {
                  model.name = nameController.text;
                  model.phone = phoneController.text;
                  Navigator.pushNamed(context, '/listing');
                },
                child: Text(
                  "Cadastrar",
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
          // Load image from assets
          image: AssetImage('assets/bg1.jpg'),
          // Make the image cover the whole area
          fit: BoxFit.cover,
        )),
      ),
    );
  }
}
