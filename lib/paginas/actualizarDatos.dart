import 'dart:io';
import 'dart:math';
import 'package:aves_dgo_nuevo/menus/inicio.dart';
import 'package:aves_dgo_nuevo/paginas/datos.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormularioEdicion extends StatefulWidget {
  final Datos datos;

  FormularioEdicion({Key? key, required this.datos}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MiFormularioEdicion();
  }
}

class MiFormularioEdicion extends State<FormularioEdicion> {
  Datos _datos = Datos.conId("","", "", "", "");
  final controladorNombreComun = TextEditingController();
  final controladorNombereCient = TextEditingController();
  final controladorId = TextEditingController();
  final controladorNombreAutor = TextEditingController();
  late String uid = widget.datos.uid;
  final CollectionReference baseDatos =
  FirebaseFirestore.instance.collection('aves');
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _datos = widget.datos;
    controladorNombereCient.text = _datos.nombreCien;
    controladorNombreComun.text = _datos.nombreCom;
    controladorNombreAutor.text = _datos.nombreCrd;
  }

  Future<void> obtenerImagen(BuildContext context) async{
    final picker =  ImagePicker();
    return showDialog(context: context, builder: (BuildContext builder){
      var pickedFile;
      return AlertDialog(
        title: Text("Seleccione opcion para foto"),
        content: SingleChildScrollView(
          //ListBody es oara elementos cortos y que no van a crecer.
          child: ListBody(
            children:<Widget> [
              GestureDetector(
                  child: Text("Galeria"),
                  onTap: () async {
                    pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    imageFile = File(pickedFile.path);
                    Navigator.of(context).pop(pickedFile);
                  }
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Cámara"),
                onTap: () async {
                  pickedFile = await picker.pickImage(source: ImageSource.camera);
                  imageFile = File(pickedFile.path);
                  print(imageFile.toString());
                  Navigator.of(context).pop(pickedFile);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> actualizarDatos(String uid,String nombre, String nombreCient,
      String nombreCreditos, String foto) async {
    Future.delayed(Duration(seconds: 5), () {
      return baseDatos.doc(uid).set({
        'nombrecom': nombre,
        'nombrecie': nombreCient,
        'nombrecrd': nombreCreditos,
        'foto': foto
      });
    });
  }

  Widget fotografia(){
    if(imageFile != null){
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(imageFile!, width: 100)
      );
    }else{
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(widget.datos.foto,
          width: 150,),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar datos de la Ave"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10.00)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10.00)),
                        child: fotografia()
                    ),
                    Padding(padding: EdgeInsets.all(10.00)),
                    IconButton(onPressed: (){
                      obtenerImagen(context);
                    }, icon: Icon(Icons.edit)),
                  ],
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
                        _datos.nombreCom = controladorNombreComun.text;
                        _datos.nombreCien= controladorNombereCient.text;
                        _datos.nombreCrd = controladorNombreAutor.text;

                        actualizarDatos(uid,_datos.nombreCom,_datos.nombreCien,
                        _datos.nombreCrd,_datos.foto);
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return Inicio();
                           }), ModalRoute.withName('/'));
                      }else{
                        alertaNombre(context);
                      }
                    },
                    child: Text('Acutalizar'))
              ],
            ),
          )),
    );
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

}


