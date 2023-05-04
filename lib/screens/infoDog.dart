import 'package:flutter/material.dart';

class InfoDog extends StatelessWidget {
  const InfoDog({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Ejemplo Nombre',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Ejemplo raza',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              //Navigator.pushNamed(context, '/api');
            },
            icon: const Icon(
              Icons.favorite_border,
              semanticLabel: 'fav',
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),  //left, top, right, bottom
      child: Text(
        'Aquí tiene que haber una descripción sobre el animal en cuestión '
        'que hable sobre sus principales características como edad, raza, '
        'carcaterísticas de su raza, enfermedades o cuidados específicos, '
        'carácter, particularidades y los detalles sobre cómo, porqué y '
        'dónde fue rescatado. También especificar que entorno y circunstancias '
        'serían las idóneas para su familia y hogar adoptivo.',
        softWrap: true, //saltos de linea cuando se acabe el espacio,
        // en false texto  en linea horizontal ilimitada
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            color: Colors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        children: [
          Image.asset(
            'assets/golden-retriever.jpg',
            width: 600,
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          titleSection,
          textSection,
          const SizedBox(height: 5),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed:(){
                    //Navigator.pushNamed(context, '/home');
                },
                child: const Text('ENVIAR MENSAJE'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
