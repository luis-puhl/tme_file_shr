import 'package:scoped_model/scoped_model.dart';

class Pedido extends Model {
  String nome, telefone;
  Loja lojaRetirada;
  DateTime dataRetirada;
  List<GrupoImpressao> grupos;
}

class GrupoImpressao extends Model {
  Config config;
  List<Arquivo> arquivos;
}

class Config extends Model {
  TipoGrupo tipoGrupo;
  int copias;
  ConfigDoc configDoc;
  ConfigFoto configFoto;
}

class Arquivo extends Model {
  String path, filename;
}

enum Loja { loja1, loja2, loja3, loja4, }
Map<Loja, String> lojaStr = {
  Loja.loja1: 'Loja 1',
  Loja.loja2: 'Loja 2',
  Loja.loja3: 'Loja 3',
  Loja.loja4: 'Loja 4',
};

enum TipoGrupo { documento, foto, }
enum TamanhoDoc { a3, a4, a5, a6, }
enum TamanhoFoto {
  mm152x102,
  mm152x210,
  mm129x89,
  mm129x180,
  mm203x254,
  mm203x305,
  mm254x305,
  mm254x380,
  mm305x406,
  mm305x450,
  mm400x600,
  mm500x600,
  mm500x700,
  mm500x750,
  mm600x900,
}
Map<TamanhoFoto, String> tamanhoFotoStr = {
  TamanhoFoto.mm152x102: '15,2 x 10,2 cm',
  TamanhoFoto.mm152x210: '15,2 x 21,0 cm',
  TamanhoFoto.mm129x89: '12,9 x 8,9 cm',
  TamanhoFoto.mm129x180: '12,9 x 18,0 cm',
  TamanhoFoto.mm203x254: '20,3 x 25,4 cm',
  TamanhoFoto.mm203x305: '20,3 x 30,5 cm',
  TamanhoFoto.mm254x305: '25,4 x 30,5 cm',
  TamanhoFoto.mm254x380: '25,4 x 38 cm',
  TamanhoFoto.mm305x406: '30,5 x 40,6 cm',
  TamanhoFoto.mm305x450: '30,5 x 45 cm',
  TamanhoFoto.mm400x600: '40 x 60 cm',
  TamanhoFoto.mm500x600: '50 x 60 cm',
  TamanhoFoto.mm500x700: '50 x 70 cm',
  TamanhoFoto.mm500x750: '50 x 75 cm',
  TamanhoFoto.mm600x900: '60 x 90 cm',
};

class ConfigDoc {
  TamanhoDoc tamanhoDoc;
  // frente, frente_verso,
  bool duplex;
  // colorido ou PB
  bool colorido;
}

enum TipoPapelFoto { brilho, fosco, }

class ConfigFoto {
  TamanhoFoto tamanhoFoto;
  TipoPapelFoto tipoPapelFoto;
}
