
class LojaInfo {
  final Loja key;
  final String nome, endereco, email, whatsapp;
  final List<String> telefone;
  final int chatId;
  
  LojaInfo({
    this.key,
    this.nome,
    this.chatId,
    this.endereco,
    this.email,
    this.telefone,
    this.whatsapp,
  });
}
enum Loja { loja1, loja2, loja3, loja4, }
