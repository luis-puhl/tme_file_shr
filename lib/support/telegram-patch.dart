import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';
import 'package:teledart/src/telegram/http_client.dart';

class TelegramPatch extends Telegram {
  final HttpClient _client = new HttpClient();
  final String _baseUrl = 'https://api.telegram.org/bot';
  final String _token;

  TelegramPatch(
    this._token,
  ) : super(_token);

  /// Use this method to send general files. On success, the sent [Message] is returned.
  /// Bots can currently send files of any type of up to 50 MB in size,
  /// this limit may be changed in the future.
  ///
  /// https://core.telegram.org/bots/api#senddocument
  ///
  /// [Message]: https://core.telegram.org/bots/api#message
  @override
  Future<Message> sendDocument(int chatId, dynamic document,
      {
      dynamic thumb,
      String caption,
      @required String fileName,
      String parse_mode,
      bool disable_notification,
      int reply_to_message_id,
      ReplyMarkup reply_markup}) async {
    String requestUrl = '$_baseUrl$_token/sendDocument';
    Map<String, dynamic> body = {
      'chat_id': chatId,
      'caption': caption ?? '',
      'parse_mode': parse_mode ?? '',
      'disable_notification': disable_notification ?? '',
      'reply_to_message_id': reply_to_message_id ?? '',
      'reply_markup': reply_markup == null ? '' : jsonEncode(reply_markup)
    };

    if (document is io.File) {
      // filename cannot be empty to post to Telegram server
      List<http.MultipartFile> files = new List.filled(
          1,
          new http.MultipartFile(
            'document', document.openRead(), document.lengthSync(),
            filename: fileName
          )
        );
      if (thumb != null) {
        if (thumb is io.File)
          files.add(new http.MultipartFile(
              'thumb', thumb.openRead(), thumb.lengthSync(),
              filename: '${thumb.lengthSync()}'));
        else if (thumb is String)
          body.addAll({'thumb': thumb});
        else
          return new Future.error(new TelegramException(
              'Attribute \'thumb\' can only be either io.File or String (Telegram file_id or image url)'));
      }
      return Message.fromJson(
          await _client.httpMultipartPost(requestUrl, files, body: body));
    } else if (document is String) {
      body.addAll({'document': document});
      if (thumb != null) {
        if (thumb is io.File)
          return Message.fromJson(await _client.httpMultipartPost(
              requestUrl,
              new List.filled(
                  1,
                  new http.MultipartFile(
                      'thumb', thumb.openRead(), thumb.lengthSync(),
                      filename: '${thumb.lengthSync()}')),
              body: body));
        else if (thumb is String) {
          body.addAll({'thumb': thumb});
        } else
          return new Future.error(new TelegramException(
              'Attribute \'thumb\' can only be either io.File or String (Telegram file_id or image url)'));
      }
      return Message.fromJson(await _client.httpPost(requestUrl, body: body));
    } else {
      return new Future.error(new TelegramException(
          'Attribute \'document\' can only be either io.File or String (Telegram file_id or image url)'));
    }
  }
}