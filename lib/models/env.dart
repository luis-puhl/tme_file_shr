import 'package:flutter/services.dart';

import './loja.dart';
export './loja.dart';

class Env {
  static String telegramToken = String.fromEnvironment('telegramToken', defaultValue: null);
  static Map<Loja, LojaInfo> lojaStr;
  static bool isDebuggin = false;

  static Future init() async {
    assert((){
      isDebuggin = true;
      return true;
    }());
    String rawDotEnv = await rootBundle.loadString('.env');
    Map<String, String> dotEnv = {};
    for (var line in rawDotEnv.trim().replaceAll('\r', '').split('\n')) {
      List<String> kv = line.split('=');
      dotEnv[kv[0]] = kv[1];
    }
    telegramToken = dotEnv['telegramToken'];
    lojaStr = {
      // Filial 2
      Loja.loja1: LojaInfo(
        key: Loja.loja1,
        nome: 'Quintino',
        chatId: int.tryParse(dotEnv['LOJA_QUINTINO_ID']),
        endereco: 'Rua Quintino Bocaiúva, 555 - Londrina',
        telefone: ['(43) 3323-5483', '(43) 3323-5533'],
        whatsapp: '(43) 9.9838-2121',
        email: 'loja.quintino@fotocelula.com.br',
      ),
      // Filial 4
      Loja.loja2: LojaInfo(
        key: Loja.loja2,
        nome: 'Comtur',
        chatId: int.tryParse(dotEnv['LOJA_COMTUR_ID']),
        endereco: 'Av. Tiradentes, 1241 Sl 03 - Bl. A Shop. ComTur - Londrina',
        telefone: ['(43) 3344-5130', '(43) 3327-3746'],
        whatsapp: '(43) 9.9991-3268',
        email: 'loja.comtur@fotocelula.com.br',
      ),
      // Filial 8
      Loja.loja3: LojaInfo(
        key: Loja.loja3,
        nome: 'Higienopolis',
        chatId: int.tryParse(dotEnv['LOJA_HIGI_ID']),
        endereco: 'Av. Higienópolis, 1056 - Londrina',
        telefone: ['(43) 3339-3442', '(43) 3344-0213'],
        whatsapp: '(43) 9.9838-1414',
        email: 'loja.higienopolis@fotocelula.com.br',
      ),
      // Nossa Matriz
      Loja.loja4: LojaInfo(
        key: Loja.loja4,
        nome: 'Centro',
        chatId: int.tryParse(dotEnv['LOJA_CENTRO_ID']),
        endereco: 'Av. Rio de Janeiro, 158 - Londrina',
        telefone: ['(43) 3323-2640'],
        whatsapp: '(43) 9.9838-2120',
        email: 'loja.centro@fotocelula.com.br',
      ),
    };
  }
}