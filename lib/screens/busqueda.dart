import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/model/product.dart';
import '/model/products_repository.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  List<Card> _buildGridCards(BuildContext context){
    List<Product> products = ProductsRepository.loadProducts(Breed.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);        //theme para usar colores

        return products.map((product) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('assets/golden-retriever.jpg'),
                      fit: BoxFit.contain),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                          foregroundColor: theme.colorScheme.secondary //usar esquema determinado en app.dart
                        ),
                        onPressed: () { 
                          Navigator.pushNamed(context, '/info');
                        },
                        child: Text(product.name),
                      ),
                      Text(
                        product.age,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget customSearchBar = const Text('Welcome');
  Icon customIcon = const Icon(Icons.search);
  List<Product> products = ProductsRepository.loadProducts(Breed.all);

  //int _selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed:(){
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                    title: TextField(
                      onChanged: (text) {
                        // if(text == products.){
                        //
                        // }
                        //print('textfield: $text');
                      },
                      //controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: ' Search...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)
                          ),
                      ),
                      ),
                    );
                } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Adoptions');
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
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/api');
            },
            icon: const Icon(
              Icons.pets,
              semanticLabel: 'api',
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            semanticLabel: 'logout',
          ),
          onPressed: (){
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation){
          return GridView.count(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                padding: const EdgeInsets.all(16.0),
                childAspectRatio: 8.0 / 9.0,
                children: _buildGridCards(context)
              );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.mark_unread_chat_alt_outlined),
      ),
    );

  }
}
