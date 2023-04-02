import 'dart:core';

class Datos {
  late String uid;
  late String nombreCom;
  late String nombreCien;
  late String nombreCrd;
  late String foto;

  static String downloadURL = "";

  Datos(this.nombreCom, this.nombreCien, this.nombreCrd, this.foto);

  Datos.conId(this.uid, this.nombreCom, this.nombreCien, this.nombreCrd, this.foto);
}
