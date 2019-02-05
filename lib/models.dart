class User {
  String name, phone;
  List<Order> orders;
}

class Order {
  final STATUS_LOCAL = 'local';
  final STATUS_UPLOADED = 'uploaded';
  final STATUS_PRINTED = 'printed';
  final STATUS_RETRIEVED = 'retrieved';

  List<FileConfig> files;
  String status;
}

class FileConfig {
  String fileName, path, size;
  int qtd;
}
