import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class InfoDog extends StatefulWidget {
  //const InfoDog({super.key});
  const InfoDog({Key? key}) : super(key: key);

  @override
  _InfoDogState createState() => _InfoDogState();
}

class _InfoDogState extends State<InfoDog> {
  //metodo para marcar/desmarcar button favoritos
  bool _isFavorite = true;
  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        _isFavorite = false;
      } else {
        _isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //widget de seccion de titulo
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
            onPressed: _toggleFavorite,
            icon:
                (_isFavorite //si se presiona o no (cambia el valor o no) muestra un icono u otro
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite)),
            color: Colors.brown,
          ),
        ],
      ),
    );

    //widget de seccion de texto
    Widget textSection = const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20), //left, top, right, bottom
      child: ReadMoreText(
        'Aquí tiene que haber una descripción sobre el animal en cuestión '
        'que hable sobre sus principales características como edad, raza, '
        'carcaterísticas de su raza, enfermedades o cuidados específicos, '
        'carácter, particularidades y los detalles sobre cómo, porqué y '
        'dónde fue rescatado. También especificar que entorno y circunstancias '
        'serían las idóneas para su familia y hogar adoptivo. ',
        trimLines: 3,
        trimMode: TrimMode.Line,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Hide',
        //estilo de texto que amplía
        moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blueGrey),
        //estilo de texto que reduce
        lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blueGrey),
        //softWrap: true, //saltos de linea cuando se acabe el espacio,
        // en false el texto está en linea horizontal ilimitada
      ),
    );

    return Scaffold(
      appBar: AppBar(
        //barra superior
        centerTitle: true,
        title: const Text(
          //titulo y su diseño
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
        //cuerpo en formato de lista
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        children: [
          Image.asset(
            //imagen y sus parametros
            'assets/golden-retriever.jpg',
            width: 600,
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10), //espacio en blanco de separación
          titleSection,
          textSection,
          const SizedBox(height: 5), //espacio en blanco de separación
          OverflowBar(
            //barra donde se encuentra el boton de Enviar Mensaje
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  //falta funcionalidad hacia futura pantalla de chat
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
