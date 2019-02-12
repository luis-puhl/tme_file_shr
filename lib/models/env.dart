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
      Loja.loja1: LojaInfo(key: Loja.loja1, nome: 'Quintino', chatId: int.tryParse(dotEnv['LOJA_QUINTINO_ID'])),
      Loja.loja2: LojaInfo(key: Loja.loja2, nome: 'Comtur', chatId: int.tryParse(dotEnv['LOJA_COMTUR_ID'])),
      Loja.loja3: LojaInfo(key: Loja.loja3, nome: 'Higienopolis', chatId: int.tryParse(dotEnv['LOJA_HIGI_ID'])),
      Loja.loja4: LojaInfo(key: Loja.loja4, nome: 'Centro', chatId: int.tryParse(dotEnv['LOJA_CENTRO_ID'])),
    };
  }
}