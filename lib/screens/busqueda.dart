import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/model/product.dart';
import '/model/products_repository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //metodo para generar Cards con lista de productos
  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Breed.all);

    if (products.isEmpty) {
      //si la lista estuviera vacia devolvería una Card vacia
      return const <Card>[];
    }

    final ThemeData theme =
        Theme.of(context); //variable theme para usar colores

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias, //esto aún no se que es
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, //alineado en el centro
          children: <Widget>[
            Container(
              //contenedor para la imagen de la Card
              width: 150,
              height: 130,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle, //forma de la imagen
                image: DecorationImage(
                    image: AssetImage('assets/golden-retriever.jpg'),
                    fit: BoxFit.contain),
              ),
            ),
            Expanded(
              //el expanded llena el espacio disponible
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          //estilo del texto del button
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle
                                .normal, //no tengo claro para que sirve esto
                            fontWeight: FontWeight.bold,
                          ),
                          foregroundColor: theme.colorScheme
                              .secondary //usar esquema determinado para color de fuente
                          ),
                      onPressed: () {
                        //al presional pasa hacia pantalla InfoPage
                        Navigator.pushNamed(context, '/info');
                      },
                      child: Text(product
                          .name), //el texto es el getter del nombre del producto
                    ),
                    Text(
                        product
                            .age, //el texto es el getter de la edad del producto
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget customSearchBar = const Text('Welcome'); //variable de widget de texto
  Icon customIcon = const Icon(Icons.search); //variable de icono
  List<Product> products =
      ProductsRepository.loadProducts(Breed.all); //lista de todos los productos
  //controlador de texto de TextField
  final TextEditingController _searchController = TextEditingController();

  //int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false, //esto no lo entiendo
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                //si se pulsa y el icono era el de busqueda, cambia al de cancelar
                if (customIcon.icon == Icons.search) {
                  //y se abre una barra de busqueda
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    title: TextField(
                      onChanged: (text) {
                        //aqui falta implementar funcionalidad de busqueda
                        // if(text == products.){
                        //
                        // }
                        //print('textfield: $text');
                      },
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: ' Search...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            //subrayado
                            borderSide: BorderSide(color: Colors.black38)),
                      ),
                    ),
                  );
                } else {
                  //si el icono no es de busqueda, vuelve a serlo y en lugar de la barra de busqueda
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Adoptions'); //hay un text
                }
              });
            },
            icon: customIcon,
          ),
          // IconButton(
          //     onPressed: (){
          //       print('Filter button');
          //     },
          //     icon: const Icon(
          //       Icons.tune,
          //       semanticLabel: 'filter',
          //     ),
          // ),
          //button provisional para accedes a la pantalla que hace llamada a una api
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/api');
            },
            icon: const Icon(
              Icons.pets,
              semanticLabel: 'api',
            ),
          ),
        ],
        leading: IconButton(
          //icono a la izquierda (principio) del texto para cerrar sesión
          icon: const Icon(
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              //al presionar vuelve hacia LoginPage
              print('Signed out');
              Navigator.pushNamed(context, '/');
            });
          },
        ),
      ),
      body: OrientationBuilder(
          //el cuerpo es un orientation builder para controlar las columns en horizontal
          builder: (context, orientation) {
        return GridView.count(
            //hay 2 columns en vertical y 4 en horizontal
            crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
            padding: const EdgeInsets.all(16.0),
            childAspectRatio: 8.0 / 9.0, //esto no se muy bien que es
            children: _buildGridCards(
                context) //llama al metodo para generar las Cards
            );
      }),
      floatingActionButton: FloatingActionButton(
        //button flotante para acceder al chat
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black87,
        onPressed: () {
          //falta añadir funcionalidad
        },
        child: const Icon(Icons.chat_outlined),
      ),
    );
  }
}
