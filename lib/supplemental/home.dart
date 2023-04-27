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
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);        //theme para usar colores
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale : Localizations.localeOf(context).toString()
    );

        return products.map((product) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(
                    'assets/diamond.png'
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        formatter.format(product.price),
                        style: theme.textTheme.titleSmall,
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

  final TextEditingController _searchController = TextEditingController();  //controlador de texto de barra de búsqueda

  Widget customSearchBar = const Text('MY DOGGY');
  Icon customIcon = const Icon(Icons.search);

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
                    customSearchBar = const ListTile(
                    // leading: Icon(
                    //   Icons.search,
                    //   size: 26,
                    // ),
                    title: TextField(
                      //controller: _searchController,
                      decoration: InputDecoration(
                        hintText: ' Search...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38)
                          ),
                      ),
                      // style: TextStyle(
                      //   color: Colors.white,
                      //   ),
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
            Icons.arrow_back_ios,
            semanticLabel: 'back',
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
      )

    );
  }
}
