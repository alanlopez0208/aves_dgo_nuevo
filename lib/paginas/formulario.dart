import 'package:aves_dgo_nuevo/menus/inicio.dart';
import 'package:aves_dgo_nuevo/paginas/datos.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Formulario extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return MiFormulario();
  }
}

class MiFormulario extends State<Formulario>{
  final controladorNombreComun = TextEditingController();
  final controladorNombereCient = TextEditingController();
  final controladorId = TextEditingController();
  final controladorNombreAutor = TextEditingController();

  Datos? dat = Datos("", "", "", "");

  Future<void> guardarDatos(String nombre, String nombreCient, String nombreCreditos, String foto) async {
    Future.delayed(
        Duration(seconds: 10) , ()async{
          final datos = await FirebaseFirestore.instance.collection('aves');
          return datos.add({
            'nombreCom' : nombre,
            'nombrecient' : nombreCient,
            'nombreCreditos' : nombreCreditos,
            'fotos' : foto
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
            children: [
              Padding(padding: EdgeInsets.all(10.00)),
              TextField(
                controller: controladorNombreComun,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  icon: Icon(Icons.add),
                  border:OutlineInputBorder(),
                  labelText: "Nombre Comun"
                ),
              ),
              Padding(padding: EdgeInsets.all(10.00)),
              TextField(
                controller: controladorNombereCient ,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    icon: Icon(Icons.add),
                    border:OutlineInputBorder(),
                    labelText: "Nombre Cientifico"
                ),
              ),
              Padding(padding: EdgeInsets.all(10.00)),
              TextField(
                controller: controladorNombreAutor ,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    icon: Icon(Icons.add),
                    border:OutlineInputBorder(),
                    labelText: "Creditos"
                ),
              ),
              Padding(padding: EdgeInsets.all(10.00)),
              ElevatedButton(onPressed: (){
                dat!.nombreCien = controladorNombereCient.text;
                dat!.nombreCom = controladorNombreComun.text;
                dat!.nombreCrd = controladorNombereCient.text;
                dat!.foto = Datos.downloadURL;

                guardarDatos(dat!.nombreCien,dat!.nombreCom  , dat!.nombreCrd,  dat!.foto);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return Inicio();
                    }),
                ModalRoute.withName('/')
                );
              }, child: Text('Registrar'))
            ],
          ),
        )
      ),
    );
  }

}