import 'package:flutter/material.dart';
import 'package:tme_file_shr/main.dart';

class AddFile extends StatelessWidget {

  void _openFileExplorer() async {
    // _path = SupportFile.openFileExplorer();
    // setState(() {
    //   _fileName = _path != null ? _path.split('/').last : '...';
    // });
  }

  @override
  Widget build(BuildContext context) {
    // "Icon",
    // "File Name",
    // "find file",
    // "Print!",
    return Scaffold(
      appBar: AppBar(
        title: Text(TelegramFileShareApp.title),
      ),
      body: Container(
        color: Colors.purple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.album),
                      title: Text('The Enchanted Nightingale'),
                      subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                    ),
                    ButtonTheme.bar( // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('BUY TICKETS'),
                            onPressed: () { /* ... */ },
                          ),
                          FlatButton(
                            child: const Text('LISTEN'),
                            onPressed: () { /* ... */ },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(Icons.file_upload),
            Padding(
              child: Column(
                children: <Widget>[
                  // Slider(
                  //   value: 1.0,
                  //   onChanged: (val) => print(val),
                  //   min: 1.0,
                  //   max: 30.0,
                  //   divisions: 30,
                  // ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Cópias",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.face,
                        color: Colors.white,
                      ),
                    ),
                    onSubmitted: (String str) {
                      print(str);
                    },
                    autofocus: true,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Tamanho impressão",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                    onSubmitted: (String str) {
                      print(str);
                    },
                  ),
                  RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    child: new Text("Open file picker"),
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Imprimir",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
