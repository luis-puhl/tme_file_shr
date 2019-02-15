import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

import './env.dart';
import './impressao.dart';
import './arquivo.dart';

enum PedidoStatus { vazio, identificado, preenchido, enviado }

class Pedido extends Model {
  static Pedido of(BuildContext context) => ScopedModel.of<Pedido>(context);

  int _id = Random.secure().nextInt(1<<32);
  PedidoStatus status = PedidoStatus.vazio;
  String nome, telefone;
  Loja lojaRetirada;
  DateTime dataRetirada;
  List<GrupoImpressao> grupos = [];
  String statusString = '';

  Pedido({this.nome, this.telefone});

  Future<int> getSize() async {
    int size = 0;
    for (GrupoImpressao grupo in grupos) {
      size += (await grupo.getSize()) ?? 0;
    }
    return size;
  }

  Future<String> toSubTitle() async {
    return (telefone != null ? telefone : 'null') + '\n' +
      (lojaRetirada != null ? Env.lojaStr[lojaRetirada].nome : '') + '\n' +
      (dataRetirada != null ? DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada) : '') + '\n' +
      ((await this.getSize()) / pow(2, 20)).toStringAsFixed(2) + ' MB'
      ;
  }

  String toString() {
    return 'nome: ' + (nome != null ? nome : 'null') + ', ' +
      'telefone: ' + (telefone != null ? telefone : 'null') + ', ' +
      'loja Retirada: ' + (lojaRetirada != null ? Env.lojaStr[lojaRetirada].nome : '') + ', ' +
      'data Retirada: ' + (dataRetirada != null ? DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada) : '');
  }

  setIdentification(String nome, String telefone, Loja lojaRetirada, DateTime dataRetirada) {
    this.nome = nome;
    this.telefone = telefone;
    this.lojaRetirada = lojaRetirada;
    this.dataRetirada = dataRetirada;
    this.status = PedidoStatus.identificado;
    this.notifyListeners();
  }

  addGrupo(GrupoImpressao group) {
    this.grupos.add(group);
    // notifyListeners();
  }
  removeGrupo(GrupoImpressao group) {
    this.grupos.removeWhere((g) => g.id == group.id);
    notifyListeners();
  }

  bool isEnviando = false;
  bool isEnviado = false;
  enviar() async {
    int chatId = Env.lojaStr[this.lojaRetirada].chatId;
    try {
      await this.enviarActual(chatId);
    } catch (error) {
      status = PedidoStatus.preenchido;
      isEnviado = false;
      statusString = 'Falha ao enviar\n' + error.toString();
      if (error?.cause != null && error?.cause == 'HttpClientException: 400 Bad Request: chat not found') {
        statusString = 'Falha ao enviar\nChat $chatId não encontrado';
      }
      print(error);
    } finally {
      isEnviando = false;
      this.notifyListeners();
    }
  }
  enviarActual(int telegramGroupId) async {
    isEnviando = true;
    this.notifyListeners();

    String ordem = '${nome.replaceAll(' ', '-')}_${telefone}_${DateFormat('yyyy-MM-dd_HH-mm', 'ptBR').format(dataRetirada)}_$_id';
    String message = '# Informações gerais\n'
      '\nCliente: $nome'
      '\nTelefone: $telefone'
      '\nData da emissão: ${DateFormat('dd\/MM\/yyyy', 'ptBR').format(DateTime.now())}'
      '\nData de entrega: ${DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada)}'
      '\n'
      ;
    String caption = message.toString();

    Archive archive = Archive();

    statusString = 'Verificando arquivos';
    this.notifyListeners();
    // limit to 50MB
    if (await (this.getSize()) >= (50 * pow(2, 20))) {
      status = PedidoStatus.preenchido;
      isEnviado = false;
      statusString = 'Falha ao enviar, tamanho do pedido excede 50MB\n'
      'Remova alguns arquivos e tente novamente.';
      isEnviando = false;
      this.notifyListeners();
      return;
    }
    for (GrupoImpressao grupo in grupos) {
      for (Arquivo arquivo in grupo.arquivos) {
        int duplicados = grupo.arquivos.where((arq) => arq.filename == arquivo.filename).length;
        if (duplicados > 1 || arquivo.filename == ordem + '.txt'){
          arquivo.filename = duplicados.toString() + '_' + arquivo.filename;
        }
      }
    }
    for (GrupoImpressao grupo in grupos) {
      message += '\n# Lote ${grupos.indexOf(grupo) + 1} ${tipoGrupoStr[grupo.tipoGrupo]}\n' + grupo.toMessage();
      for (Arquivo arquivo in grupo.arquivos) {
        message += '\nNome arquivo: ${arquivo.filename}';
        List<int> content = await arquivo.readAsBytes();
        archive.addFile(
          ArchiveFile('$ordem/${arquivo.filename}', content.length, content)
        );
        arquivo.release();
      }
      message += '\n';
    }
    statusString = 'Comprimindo arquivos';
    this.notifyListeners();
    List<int> content = Utf8Codec().encode(message.replaceAll('\n', '\r\n'));
    archive.addFile(
      ArchiveFile('$ordem/pedido.txt', content.length, content)
    );

    List<int> tempZipFile = ZipEncoder().encode(archive);

    statusString = 'Enviando arquivos';
    this.notifyListeners();

    if (Env.telegramToken == null) throw 'Sem telegram token';
    if (telegramGroupId == null) throw 'Sem telegram group id';

    await _telegramSendDocument(chatId: telegramGroupId, document: tempZipFile, caption: caption, fileName: '$ordem.zip');
    status = PedidoStatus.enviado;
    isEnviado = true;
    statusString = 'Pedido enviado';
    isEnviando = false;
    this.notifyListeners();
  }

  _telegramSendDocument({int chatId, String caption, List<int> document, String fileName}) async {
    final String _baseUrl = 'https://api.telegram.org/bot';
    final String _token = Env.telegramToken;

    String requestUrl = '$_baseUrl$_token/sendDocument';
    Map<String, dynamic> body = {
      'chat_id': chatId,
      'caption': caption ?? '',
      'parse_mode': '',
      'disable_notification': '',
      'reply_to_message_id': '',
      'reply_markup': '',
    };

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(requestUrl));
    request
    ..headers.addAll({'Content-Type': 'multipart/form-data'})
    ..fields.addAll(body.map((k, v) => MapEntry(k, '$v')))
    ..files.add(
      http.MultipartFile.fromBytes(
        'document',
        document,
        filename: fileName
      )
    );
    http.Response response = await http.Response.fromStream(
      await request.send()
    );
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody['ok']) {
      return responseBody['result'];
    } else {
      return Future.error(Exception(
          '${responseBody['error_code']} ${responseBody['description']}'));
    }
  }
}