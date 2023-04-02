import 'package:aves_dgo_nuevo/paginas/datos.dart';
import 'package:aves_dgo_nuevo/paginas/actualizarDatos.dart';
import 'package:aves_dgo_nuevo/paginas/formulario.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Aves Durango'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('aves').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>; //nuevo paquete
                  return Card(
                    elevation: 10,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Image.network(data['foto'], height: 200),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListTile(
                                title:
                                    Text("Nombre común: " + data['nombrecom']),
                                subtitle: Text(
                                  "Nombre científico: " +
                                      data['nombrecie'] +
                                      "\n" +
                                      "Fotografiada por: " +
                                      data['nombrecrd'],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(10.00)),
                                child: IconButton(
                                    onPressed: () {
                                      Datos datos = Datos.conId(
                                          document.id,
                                          data['nombrecom'],
                                          data['nombrecie'],
                                          data['nombrecrd'],
                                          data['foto']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                          return FormularioEdicion(
                                              datos: datos);
                                        }),
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10.00)),
                                child: IconButton(
                                    onPressed: () {
                                      borrarDatos(
                                          context, document.id.toString());
                                    },
                                    icon: Icon(Icons.delete)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }));
  }

  void borrarDatos(BuildContext context, String uid) {
    showDialog(
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
            title: Text("Confirmar eliminación"),
            content: Text("¿Estás seguro de que deseas eliminar esta Ave?"),
            actions: [
              TextButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.amber),
                ),
                onPressed: () {
                  //Se agrega el metodo eliminarRegistro
                  eliminarDatos(uid);

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> eliminarDatos(String uid) async {
    final CollectionReference baseDatos =
        FirebaseFirestore.instance.collection('aves');
    Future.delayed(Duration(seconds: 3), () {
      return baseDatos.doc(uid).delete();
    });
    print("Se ha eliminado el dato");
  }
}
