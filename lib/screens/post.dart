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
    final response = await http.get(Uri.parse('https://dog.ceo/api/breed/leonberg/images'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final data = jsonDecode(response.body);
      // este es un array de Strings
      final list = data['message'] as List;
      // pasando la data a objetos DogData, recorriendo los strings y transformandolos a objeto
      return list.map((e) => Dogdata(imagen: e)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEONBERGS'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            semanticLabel: 'back',
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Dogdata>>(
          future: getImagesBreed(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Dogdata>> snapshot) {
            if (snapshot.hasData) {
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
            } else {
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