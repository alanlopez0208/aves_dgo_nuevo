import 'dart:io';

import 'package:aves_dgo_nuevo/paginas/datos.dart';
import 'package:aves_dgo_nuevo/paginas/formulario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Fotos extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MisFotos();
  }
}

class MisFotos extends State<Fotos>{
  final picker = ImagePicker(); //ImagePicker la ventana para abrir para seleccionar la imagen
  File? imageFile;
  String reffoto="";
  String nomfoto="";

  //Llamamos al constructor de datos para agregarlo despues
  Datos? dat= Datos("","","","");


  Future<void> showSelectionDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Seleccione opcion para foto"),
            content: SingleChildScrollView(
              //ListBody es oara elementos cortos y que no van a crecer.
              child: ListBody(
                children:<Widget> [
                  GestureDetector(
                      child: Text("Galeria"),
                      onTap: (){
                        abrirGaleria(context);
                      }
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Cámara"),
                    onTap: (){
                      abrirCamara(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void abrirGaleria(BuildContext context) async{//Siempre que se utilza un metodo async se utiliza un await cuando se crea un objerto
    final picture =await picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      //Como aqui se esutilizado un objeto de tipo final siempre se tiene que usar el signo de admiracion
      imageFile = File(picture!.path);
      Navigator.of(context).pop();
    });
  }

  void abrirCamara(BuildContext context) async{
    final picture =await picker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile=File(picture!.path);
      Navigator.of(context).pop();
    });
  }

  void enviarImagen() async{
    //Solo se llama a la clase a travez de un alias
    firebase_storage.FirebaseStorage.instance
        .ref(reffoto+'.jpg')
        .putFile(imageFile!);
    print("Enviada________");
  }

  Future<void> visualizafoto() async{
    Future.delayed(Duration(seconds:7), () async{
      String urll = await firebase_storage.FirebaseStorage.instance.ref(reffoto+".jpg").getDownloadURL();
      Datos.downloadURL = urll.toString();

      print("----------->"+Datos.downloadURL);
    });

  }

  Widget mostrarImagen(){
    if(imageFile != null){
      return Image.file(imageFile!, width: 500, height: 500,);
    }else{
      return Text("Seleccione un imagen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mostrarImagen(),
            Padding(padding: new EdgeInsets.all(30.00)),
            IconButton(
              icon: Icon(Icons.send_and_archive),
              onPressed: (){
                nomfoto = (DateFormat.yMd().add_Hms().format(DateTime.now())).toString();
                reffoto = "uidgo/"+(nomfoto.replaceAll("/", "_").replaceAll(" ","_").replaceAll(":", "_"));
                enviarImagen();
                print("---------------"+nomfoto);
                print("---------------"+reffoto);
                visualizafoto();
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return Formulario();
                }));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showSelectionDialog(context);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}