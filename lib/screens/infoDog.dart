import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class InfoDog extends StatefulWidget {
  //const InfoDog({super.key});
  const InfoDog({Key? key}) : super(key: key);

  @override
  State<InfoDog> createState() => _InfoDogState();
}

class _InfoDogState extends State<InfoDog> {
  bool isShelter = true; //variable que define el tipo de usuario
  bool isEditing = false;

  String dogName = 'Ejemplo Nombre';
  String breedName = 'Ejemplo raza';
  String dogDescription =
      'Aquí tiene que haber una descripción sobre el animal en cuestión '
      'que hable sobre sus principales características como edad, raza, '
      'carcaterísticas de su raza, enfermedades o cuidados específicos, '
      'carácter, particularidades y los detalles sobre cómo, porqué y '
      'dónde fue rescatado. También especificar que entorno y circunstancias '
      'serían las idóneas para su familia y hogar adoptivo.';

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

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController breedEditingController = TextEditingController();
  TextEditingController dogDescriptionEditingController = TextEditingController();

  @override
  void dispose() {
    nameEditingController.dispose();
    breedEditingController.dispose();
    dogDescriptionEditingController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
      nameEditingController.text = dogName;
      breedEditingController.text = breedName;
      dogDescriptionEditingController.text = dogDescription;
    });
  }

  void saveText() {
    setState(() {
      isEditing = false;
      dogName = nameEditingController.text;
      breedName = breedEditingController.text;
      dogDescription = dogDescriptionEditingController.text;
      // DatabaseService(uid: userId).updateNameAndDescription(name!, userDescription!); //llama al método para actualizar el nombre y descripción al dejar de editar
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
                  child: Text(
                    dogName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  breedName,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          isShelter
              ? SizedBox(
                  width: 0,
                )
              : IconButton(
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
    Widget textSection = Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20), //left, top, right, bottom
      child: ReadMoreText(
        dogDescription,
        trimLines: 3,
        trimMode: TrimMode.Line,
        trimCollapsedText: ' Show more',
        trimExpandedText: ' Hide',
        //estilo de texto que amplía
        moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey),
        //estilo de texto que reduce
        lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.blueGrey),
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
        actions: [
          isShelter
              ? isEditing
                  ? IconButton(
                      onPressed: () {
                        saveText();
                      },
                      icon: const Icon(Icons.save),
                    )
                  : IconButton(
                      onPressed: () {
                        startEditing();
                      },
                      icon: const Icon(Icons.edit),
                    )
              : SizedBox(width: 0)
        ],
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
          const SizedBox(height: 5), //espacio en blanco de separación
          isEditing
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20), //left, top, right, bottom
                  child: Column(
                    children: [
                      TextField(
                        controller: nameEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nombre',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: breedEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Raza',
                        ),
                      ),
                    ],
                  ),
                )
              : titleSection,
          isEditing
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20), //left, top, right, bottom
                  child: TextField(
                    controller: dogDescriptionEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    maxLength: 400,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Descripción',
                    ),
                    maxLines: 10,
                  ),
                )
              : textSection,
          const SizedBox(height: 5), //espacio en blanco de separación
          OverflowBar(
            //barra donde se encuentra el boton de Enviar Mensaje
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              isShelter
                  ? ElevatedButton(
                      onPressed: () {
                        showAlertDialogInfo(context);
                      },
                      child: const Text('ELIMINAR PERRO'),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: const Text('ENVIAR MENSAJE'),
                    )
            ],
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

//alertDailog de confirmación
showAlertDialogInfo(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("ELIMINAR"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget cancelButton = TextButton(
    child: const Text("CANCELAR"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      'Eliminar perro',
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ),
    content: const Text(
      '¿Estás seguro de que quieres eliminar este perro?',
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.start,
    ),
    actions: [cancelButton, okButton],
  );
// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
