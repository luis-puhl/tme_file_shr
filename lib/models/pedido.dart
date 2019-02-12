import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:teledart/teledart.dart';

import 'package:tme_file_shr/support/telegram-patch.dart';

import './env.dart';
import './impressao.dart';

enum PedidoStatus { vazio, identificado, preenchido, enviado }

class Pedido extends Model {
  PedidoStatus status = PedidoStatus.vazio;
  String nome, telefone;
  Loja lojaRetirada;
  DateTime dataRetirada;
  List<GrupoImpressao> grupos = [];
  String statusString = '';

  static Pedido of(BuildContext context) => ScopedModel.of<Pedido>(context);

  String toSubTitle() {
    return (telefone != null ? telefone : 'null') + '\n' +
      (lojaRetirada != null ? Env.lojaStr[lojaRetirada].nome : '') + '\n' +
      (dataRetirada != null ? DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada) : '');
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

  bool isEnviando = false;
  bool isEnviado = false;
  enviar() async {
    int chatId = Env.lojaStr[this.lojaRetirada].chatId;
    try {
      await this.enviarActual(chatId);
    } catch (e) {
      status = PedidoStatus.preenchido;
      isEnviado = false;
      statusString = 'Falha ao enviar\n' + e.toString();
      if (e.cause != null) {
        switch (e.cause) {
          case "HttpClientException: 400 Bad Request: chat not found":
            statusString = 'Falha ao enviar\nChat $chatId não encontrado';
            break;
          default:
        }
      }
      print(e);
    } finally {
      isEnviando = false;
      this.notifyListeners();
    }
  }
  enviarActual(int telegramGroupId) async {
    isEnviando = true;
    this.notifyListeners();

    String ordem = '${nome.replaceAll(' ', '-')}_${telefone}_${DateFormat('yyyy-MM-dd_HH-mm', 'ptBR').format(dataRetirada)}';
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
    for (var grupo in grupos) {
      for (var arquivo in grupo.arquivos) {
        int duplicados = grupo.arquivos.where((arq) => arq.filename == arquivo.filename).length;
        if (duplicados > 1 || arquivo.filename == ordem + '.txt'){
          arquivo.filename = duplicados.toString() + '_' + arquivo.filename;
        }
      }
    }
    for (var grupo in grupos) {
      message += '\n# Lote ${grupos.indexOf(grupo) + 1} ${tipoGrupoStr[grupo.tipoGrupo]}\n' + grupo.toMessage();
      for (var arquivo in grupo.arquivos) {
        message += '\nNome arquivo: ${arquivo.filename}';
        List<int> content = await File(arquivo.path).readAsBytes();
        archive.addFile(
          ArchiveFile(arquivo.filename, content.length, content)
        );
      }
      message += '\n';
    }
    statusString = 'Comprimindo arquivos';
    this.notifyListeners();
    List<int> content = Utf8Codec().encode(message.replaceAll('\n', '\r\n'));
    archive.addFile(
      ArchiveFile(ordem + '.txt', content.length, content)
    );

    Directory tempDir = await Directory.systemTemp.createTemp();
    File tempZipFile = File(tempDir.path + '/$ordem.zip');
    await tempZipFile.writeAsBytes(
      ZipEncoder().encode(archive)
    );

    // limit to 50MB
    FileStat zipStas = await tempZipFile.stat();
    if (zipStas.size >= (50 * pow(2, 20))) {
      status = PedidoStatus.preenchido;
      isEnviado = false;
      statusString = 'Falha ao enviar, tamanho do pedido excede 50MB\n'
      'Remova alguns arquivos e tente novamente.';
      isEnviando = false;
      this.notifyListeners();
      await tempZipFile.delete();
      await tempDir.delete();
      return;
    }

    statusString = 'Enviando arquivos para telegram';
    this.notifyListeners();

    if (Env.telegramToken == null) throw 'Sem telegram token';
    if (telegramGroupId == null) throw 'Sem telegram group id';

    TelegramPatch telegram = TelegramPatch(Env.telegramToken);
    TeleDart(telegram, Event());
    await telegram.sendDocument(telegramGroupId, tempZipFile, caption: caption, fileName: '$ordem.zip');
    status = PedidoStatus.enviado;
    isEnviado = true;
    statusString = 'Ordem enviada';
    isEnviando = false;
    this.notifyListeners();
    await tempZipFile.delete();
    await tempDir.delete();
  }
}