import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tme_file_shr/support/transparent-image.dart';
import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models/env.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      Container(
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: AssetImage('assets/icone-favicon.png'),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        constraints: BoxConstraints(maxHeight: 200.0, minHeight: 200.0),
      ),
      ListTile(
        title: Text('Sobre o aplicativo'),
        subtitle: Text(
          'Neste aplicativo você pode fazer pedidos para alguma de nossas lojas.\n'
          'Você pode enviar até 50MB de arquivos por pedido e obter o orçamento entrando em contato com a loja para onde ele foi feito.'
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: RaisedButton.icon(
            label: Text(
              'Iniciar um pedido', 
              style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).colorScheme.onPrimary,),
            ),
            color: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            icon: Icon(Icons.play_circle_outline, size: 50,),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      Divider(),
      ListTile(
        title: Text('Sobre a Foto Celula'),
        subtitle: Text.rich(
          TextSpan(
            text: 'A Foto Célula foi fundada no ano de 1976 na cidade de Londrina pelo Senhor Terumi Koga e sua principal'
            ' missão é oferecer soluções em recordações, presentes e registros.\n\n'
            'Facebook: ',
            children: [
              TextSpan(
                style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch('https://web.facebook.com/fotoceluladigital/'),
                text: '@fotoceluladigital'
              ),
            ],
          ),
        )
      ),
      Divider(),
      Center(child: Text('Lojas', style: Theme.of(context).textTheme.display2,),),
      Divider()
    ];
    for (LojaInfo loja in Env.lojaStr.values) {
      list.addAll([
        Padding(child: Text(loja.nome, style: Theme.of(context).textTheme.headline,), padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),),
        // Endereço
        ListTile(
          title: Text(loja.endereco),
          contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          // subtitle: Text('Endereço'),
          trailing: FlatButton(
            child: Icon(Icons.place),
            // geo:0,0?q=my+street+address
            // String get enderecoLink => 'geo:0,0?q=${endereco.replaceAll(' ', '+')}';
            onPressed: () => launch('geo:0,0?q=${loja.endereco.replaceAll(' ', '%20')}'),
          ),
        ),
        // Telefones
        Column(
          children: loja.telefone.map((fone) => ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            // dense: true,
            title: Text(fone),
            // subtitle: Text('Telefone'),
            trailing: FlatButton(
              child: Icon(Icons.phone),
              // tel:<phone number>
              onPressed: () => launch('tel:$fone'),
            ),
          )).toList(),
        ),
        // Whatsapp
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          title: Text(loja.whatsapp),
          subtitle: Text('Whatsapp'),
          trailing: FlatButton(
            child: Icon(Icons.sms),
            onPressed: () => launch(
              'https://wa.me/55${loja.whatsapp.replaceAll(RegExp('[ \+\.\-]'), '')}'
            ),
          ),
        ),
        // Email
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          title: Text(loja.email),
          subtitle: Text('Email'),
          trailing: FlatButton(
            child: Icon(Icons.email),
            // mailto:<email address>?subject=<subject>&body=<body>
            onPressed: () => launch('mailto:${loja.email}?subject=App%20FotoCelula%20Express'),
          ),
        ),
        Divider(),
      ]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: ListView(
        children: list,
      ),
    );
  }
}