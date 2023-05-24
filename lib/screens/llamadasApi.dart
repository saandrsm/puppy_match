import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api extends StatefulWidget {
  const Api({Key? key}) : super(key: key);

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //barra superior
        title: const Text('IMAGEN RANDOM'),
        leading: IconButton( //los LEADINGIcon se situan al principio de la línea (a la izquierda del texto)
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: (){
            //vuelve hacia pantalla anterior
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        // child: FutureBuilder<List<Dogdata>>( //builder basado en un valor futuro
        //   future: getImagesBreed(),
        //   builder: (BuildContext context, AsyncSnapshot<List<Dogdata>> snapshot) {
        //     if (snapshot.hasData) { //si hay datos
        //       final lista = snapshot.data!;
        //       return ListView.builder(
        //         itemCount: lista.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return Image.network(
        //             lista[index].imagen,
        //             alignment: Alignment.center,
        //             fit: BoxFit.fitHeight,
        //             filterQuality: FilterQuality.medium,
        //           );
        //         },
        //       );
        //     } else {  //si no hay datos muestra una barra de progreso
        //       return const CircularProgressIndicator();
        //     }
        //   },
        // ),
        child: FutureBuilder<Dogdata>( //builder basado en un valor futuro
          future: getImageRandom(),
          builder: (BuildContext context, AsyncSnapshot<Dogdata> snapshot) {
            if(snapshot.hasData) {
              return Image.network(snapshot.data!.imagen);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

//se convierte en un objeto dart
Future<List<Dogdata>> getImagesBreed() async {
  //get
  final response1 = await http.get(Uri.parse('https://dog.ceo/api/breed/leonberg/images?&limit=5'));

  if (response1.statusCode == 200) {
    // Si el servidor obtiene una respuesta 200 OK,
    // parsea el JSON.
    final data = jsonDecode(response1.body);
    // este es un array de Strings
    final list = data['message'] as List;
    // pasando la data a objetos DogData, recorriendo los strings y transformandolos a objeto
    return list.map((e) => Dogdata(imagen: e)).toList();
  } else {
    // Si el servidor no recibe una respuesta 200 OK,
    // lanza una excepcion
    throw Exception('Failed to load album');
  }
}

Future <Dogdata> getImageRandom() async {
  final response2 = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

  if (response2.statusCode == 200) {

    return Dogdata.fromJson(jsonDecode(response2.body));

  } else {
    // Si el servidor no recibe una respuesta 200 OK,
    // lanza una excepcion
    throw Exception('Failed to load album');
  }
}

class Dogdata {
  final String imagen;

  const Dogdata({
    required this.imagen,
  });

  factory Dogdata.fromJson(Map<String, dynamic> json) {
    return Dogdata(
      imagen: json['message'],
    );
  }
}