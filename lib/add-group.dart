import 'package:flutter/material.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/support/enum-picker.dart';

class PrintGroup extends StatefulWidget {
  @override
  _PrintGroupState createState() => _PrintGroupState();
}

class _PrintGroupState extends State<PrintGroup> {
  final _formKey = GlobalKey<FormState>();
  GrupoImpressao group = GrupoImpressao();

  TextStyle valueStyle;
  // group.config
  // TipoGrupo tipoGrupo;
  // int copias;
  // ConfigDoc configDoc;
  // ConfigFoto configFoto;

  @override
  Widget build(BuildContext context) {
    // print(group);
    this.valueStyle = Theme.of(context).textTheme.title;
    final padding = SizedBox(height: 8.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            EnumPicker<TipoGrupo>(
              iconData: Icons.assignment,
              labelText: 'Tipo de Impressão',
              hintText: 'Escolha uma loja para retirada',
              textStyle: Theme.of(context).textTheme.title,
              map: tipoGrupoStr,
              originalValue: this.group.tipoGrupo,
              onChanged: (TipoGrupo newValue) => setState(() {this.group.tipoGrupo = newValue;}),
            ),
            padding,
            this.group.tipoGrupo == TipoGrupo.documento ?
              DocConfigForm(
                onTamanhoDocChanged: (TamanhoDoc newValue) => setState(() {this.group.configDoc?.tamanhoDoc = newValue;}),
                onDuplexChanged: (bool newValue) => setState(() {this.group.configDoc?.duplex = newValue;}),
                onColoridoChanged: (bool newValue) => setState(() {this.group.configDoc?.colorido = newValue;}),
                tamanhoDoc: this.group.configDoc?.tamanhoDoc ?? TamanhoDoc.a4,
                duplex: this.group.configDoc?.duplex ?? false,
                colorido: this.group.configDoc?.colorido ?? false,
              )
              :
              this.group.tipoGrupo == TipoGrupo.foto ?
                FotoConfigForm(
                  onTamanhoFotoChanged: (TamanhoFoto newValue) => setState(() {this.group.configFoto?.tamanhoFoto = newValue;}),
                  onTipoPapelFotoChanged: (TipoPapelFoto newValue) => setState(() {this.group.configFoto?.tipoPapelFoto = newValue;}),
                  tamanhoFoto: this.group.configFoto?.tamanhoFoto ?? TamanhoFoto.mm500x750,
                  tipoPapelFoto: this.group.configFoto?.tipoPapelFoto ?? TipoPapelFoto.brilho,
                )
              : padding,
          ],
        ),
      ),
    );
  }
}

class DocConfigForm extends StatelessWidget {
  final Function onTamanhoDocChanged, onDuplexChanged, onColoridoChanged;
  final TamanhoDoc tamanhoDoc;
  final bool duplex;
  final bool colorido;
  DocConfigForm({
    Key key,
    this.onTamanhoDocChanged,
    this.onDuplexChanged,
    this.onColoridoChanged,
    this.tamanhoDoc,
    this.duplex,
    this.colorido,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Text('Configuração de Documento', style: Theme.of(context).textTheme.headline,),
          EnumPicker<TamanhoDoc>(
            iconData: Icons.straighten,
            labelText: 'Tamanho da folha',
            hintText: 'Escolha um tamaho de folha',
            textStyle: Theme.of(context).textTheme.title,
            map: tamanhoDocStr,
            originalValue: tamanhoDoc,
            onChanged: onTamanhoDocChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.wrap_text),
              ),
              Expanded(child: Text('Duplex (frente e verso)', style: Theme.of(context).textTheme.title,)),
              Switch(
                onChanged: onDuplexChanged,
                value: duplex,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.style),
              ),
              Expanded(child: Text('Colorido', style: Theme.of(context).textTheme.title,)),
              Switch(
                onChanged: onColoridoChanged,
                value: colorido,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FotoConfigForm extends StatelessWidget {
  //   class ConfigFoto {
  //   TamanhoFoto tamanhoFoto;
  //   TipoPapelFoto tipoPapelFoto;
  // }
  final Function onTamanhoFotoChanged, onTipoPapelFotoChanged;
  final TamanhoFoto tamanhoFoto;
  final TipoPapelFoto tipoPapelFoto;
  FotoConfigForm({
    Key key,
    this.onTamanhoFotoChanged,
    this.onTipoPapelFotoChanged,
    this.tamanhoFoto,
    this.tipoPapelFoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          Text('Configuração de Fotos', style: Theme.of(context).textTheme.headline,),
          EnumPicker<TamanhoFoto>(
            iconData: Icons.straighten,
            labelText: 'Tamanho da folha',
            hintText: 'Escolha um tamaho de folha',
            textStyle: Theme.of(context).textTheme.title,
            map: tamanhoFotoStr,
            originalValue: tamanhoFoto,
            onChanged: onTamanhoFotoChanged,
          ),
          EnumPicker<TipoPapelFoto>(
            iconData: Icons.straighten,
            labelText: 'Tipo de Papel',
            hintText: 'Escolha um tipo de papel',
            textStyle: Theme.of(context).textTheme.title,
            map: tipoPapelFotoStr,
            originalValue: tipoPapelFoto,
            onChanged: onTipoPapelFotoChanged,
          ),
        ],
      ),
    );
  }
}
