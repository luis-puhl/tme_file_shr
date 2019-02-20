import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:tme_file_shr/support/transparent-image.dart';
import 'package:tme_file_shr/main.dart';

class Arquivo {
  static List<String> serializeThumbnailConfig(String identifier, int width, int height, int quality) {
    return <String>[identifier, width.toString(), height.toString(), quality.toString()];
  }
  static Future<bool> requestThumbnail(List<String> serialConfig) {
    MultiImagePicker.pickImages(maxImages: 300);
    String identifier = serialConfig[0];
    int width = int.tryParse(serialConfig[1]) ?? 100;
    int height = int.tryParse(serialConfig[2]) ?? 100;
    int quality = int.tryParse(serialConfig[3]) ?? 100;
    return MultiImagePicker.requestThumbnail(identifier, width, height, quality);
  }

  String _path, filename;
  Asset asset;
  int _size;
  int _id = Random.secure().nextInt(1<<32);

  get id => this._id;

  Arquivo();

  factory Arquivo.fromFilePath(String path) {
    Arquivo arq = Arquivo();
    arq._path = path;
    arq.filename = path.split('/').last;
    return arq;
  }
  factory Arquivo.fromAsset(Asset asset) {
    Arquivo arq = Arquivo();
    arq.filename = asset.name;
    arq.asset = asset;
    asset.requestOriginal();
    arq.getThumb();
    return arq;
  }

  Future<Uint8List> getThumb() async {
    if (this.asset?.thumbData == null) {
      // await this.asset?.requestThumbnail(asset.originalWidth ~/100, asset.originalHeight ~/100, quality: 10);
      await compute(
        Arquivo.requestThumbnail,
        Arquivo.serializeThumbnailConfig(this.asset.identifier, asset.originalWidth, asset.originalHeight, 100)
      );
      // await this.asset?.requestThumbnail(asset.originalWidth, asset.originalHeight);
    }
    if ( this.asset.thumbData != null) {
      return this.asset.thumbData.buffer.asUint8List();
    }
    return kTransparentImage;
  }

  Future<int> getSize() async{
    if (this._size != null && this._size != 0) {
      return this._size;
    }
    if (this._path != null) {
      this._size = (await File(this._path).stat()).size;
      return this._size;
    }
    if (this.asset.imageData == null) {
      await this.asset.requestOriginal();
    }
    this._size = this.asset.imageData.lengthInBytes;
    return this._size;
  }

  Future<List<int>> readAsBytes() async {
    if (this._path != null) {
      return await File(this._path).readAsBytes();
    }
    if (this.asset.imageData == null) {
      await this.asset.requestOriginal();
    }
    return this.asset.imageData.buffer.asUint8List();
  }

  void release() {
    return this.asset?.release();
  }
}