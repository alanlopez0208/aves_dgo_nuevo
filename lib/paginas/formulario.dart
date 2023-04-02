import 'dart:io';
import 'package:aves_dgo_nuevo/menus/inicio.dart';
import 'package:aves_dgo_nuevo/paginas/datos.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Formulario extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MiFormulario();
  }
}

class MiFormulario extends State<Formulario> {
  final controladorNombreComun = TextEditingController();
  final controladorNombereCient = TextEditingController();
  final controladorId = TextEditingController();
  final controladorNombreAutor = TextEditingController();
  final CollectionReference datos =
      FirebaseFirestore.instance.collection('aves');

  Datos? dat = Datos("", "", "", "");

  Future<void> guardarDatos(String nombre, String nombreCient,
      String nombreCreditos, String foto) async {
    Future.delayed(Duration(seconds: 10), () {
      return datos.add({
        'nombrecom': nombre,
        'nombrecie': nombreCient,
        'nombrecrd': nombreCreditos,
        'foto': foto
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos de la Ave"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10.00)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10.00)),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.image)),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombreComun,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                  labelText: "Nombre Comun"),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombereCient,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                  labelText: "Nombre Cientifico"),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            TextField(
              controller: controladorNombreAutor,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.add),
                  border: OutlineInputBorder(),
                  labelText: "Creditos"),
            ),
            Padding(padding: EdgeInsets.all(10.00)),
            ElevatedButton(
                onPressed: () {
                  if (validarNombre(controladorNombreComun.text) &&
                      validarNombreCient(controladorNombereCient.text) &&
                      (validarNombre(controladorNombreAutor.text)) &&
                      Datos.downloadURL != null) {
                    dat!.nombreCien = controladorNombereCient.text;
                    dat!.nombreCom = controladorNombreComun.text;
                    dat!.nombreCrd = controladorNombreAutor.text;
                    dat!.foto = Datos.downloadURL;
                    guardarDatos(dat!.nombreCien, dat!.nombreCom,
                        dat!.nombreCrd, dat!.foto);
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Inicio();
                    }), ModalRoute.withName('/'));
                  }else{
                    alertaNombre(context);
                  }
                },
                child: Text('Registrar'))
          ],
        ),
      )),
    );
  }
}

bool validarNombre(String cadena) {
  RegExp exp = new RegExp(r'^[a-zA-Z]+[. ]*[a-zA-Z]*$');
  if (cadena.isEmpty) {
    return false;
  } else if (!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}

bool validarNombreCient(String cadena) {
  RegExp exp = new RegExp(r'^[a-zA-Z]+[. ]*[a-zA-Z]*$');
  if (cadena.isEmpty) {
    return false;
  } else if (!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}

bool validarId(String cadena) {
  RegExp exp = new RegExp(r'^AV[a-zA-z]{1,4}\d{1,4}$');
  if (cadena.isEmpty) {
    return false;
  } else if (!exp.hasMatch(cadena)) {
    return false;
  } else {
    return true;
  }
}
void alertaNombre(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alerta"),
          content: Text("Hay alguna informacion Incorrecta",
              style: TextStyle(fontFamily: "Arial", fontSize: 15)),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ok"))
          ],
        );
      });
}
