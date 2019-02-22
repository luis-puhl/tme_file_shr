import { id } from './id';

export class PrintFile {
  // static List<String> serializeThumbnailConfig(String identifier, int width, int height, int quality) {
  //   return <String>[identifier, width.toString(), height.toString(), quality.toString()];
  // }
  // static Future<bool> requestThumbnail(List<String> serialConfig) {
  //   MultiImagePicker.pickImages(maxImages: 300);
  //   String identifier = serialConfig[0];
  //   int width = int.tryParse(serialConfig[1]) ?? 100;
  //   int height = int.tryParse(serialConfig[2]) ?? 100;
  //   int quality = int.tryParse(serialConfig[3]) ?? 100;
  //   return MultiImagePicker.requestThumbnail(identifier, width, height, quality);
  // }

  path: string;
  filename: string;
  // Asset asset;
  size: number;
  id = id();

  static fromFilePath(path) {
    const arq = new PrintFile();
    arq.path = path;
    arq.filename = path.split('/').last;
    return arq;
  }
  static fromAsset(asset) {
    const arq = new PrintFile();
    arq.filename = asset.name;
    // arq.asset = asset;
    // asset.requestOriginal();
    // arq.getThumb();
    return arq;
  }

  // Future<Uint8List> getThumb() async {
  //   if (this.asset?.thumbData == null) {
  //     // await this.asset?.requestThumbnail(asset.originalWidth ~/100, asset.originalHeight ~/100, quality: 10);
  //     await compute(
  //       PrintFile.requestThumbnail,
  //       PrintFile.serializeThumbnailConfig(this.asset.identifier, asset.originalWidth, asset.originalHeight, 100)
  //     );
  //     // await this.asset?.requestThumbnail(asset.originalWidth, asset.originalHeight);
  //   }
  //   if ( this.asset.thumbData != null) {
  //     return this.asset.thumbData.buffer.asUint8List();
  //   }
  //   return kTransparentImage;
  // }

  async getSize() {
    return this.size;
    // if (this._size != null && this._size != 0) {
    //   return this._size;
    // }
    // if (this._path != null) {
    //   this._size = (await File(this._path).stat()).size;
    //   return this._size;
    // }
    // if (this.asset.imageData == null) {
    //   await this.asset.requestOriginal();
    // }
    // this._size = this.asset.imageData.lengthInBytes;
    // return this._size;
  }

  async readAsBytes() {
    return '';
    // if (this._path != null) {
    //   return await File(this._path).readAsBytes();
    // }
    // if (this.asset.imageData == null) {
    //   await this.asset.requestOriginal();
    // }
    // return this.asset.imageData.buffer.asUint8List();
  }

  // void release() {
  //   return this.asset?.release();
  // }
}