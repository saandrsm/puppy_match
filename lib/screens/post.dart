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
  //se convierte en un objeto dart
  Future<List<Dogdata>> getImagesBreed() async {
    //get
    final response = await http.get(Uri.parse('https://dog.ceo/api/breed/leonberg/images'));

    if (response.statusCode == 200) {
      // Si el servidor obtiene una respuesta 200 OK,
      // parsea el JSON.
      final data = jsonDecode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //barra superior
        title: const Text('LEONBERGS'),
        leading: IconButton( //los LEADINGIcon se situan al principio de la línea (a la izquierda del texto)
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/home'); //pasa hacia pantalla HomePage
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Dogdata>>( //builder basado en un valor futuro
          future: getImagesBreed(),
          builder: (BuildContext context, AsyncSnapshot<List<Dogdata>> snapshot) {
            if (snapshot.hasData) { //si hay datos
              final lista = snapshot.data!;
              return ListView.builder(
                itemCount: lista.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    lista[index].imagen,
                    alignment: Alignment.center,
                    // width: 300,
                    // height: 330,
                    fit: BoxFit.fitHeight,
                    filterQuality: FilterQuality.medium,
                  );
                },
              );
            } else {  //si no hay datos muestra una barra de progreso
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class Dogdata {
  final String imagen;

  const Dogdata({
    required this.imagen,
  });
}