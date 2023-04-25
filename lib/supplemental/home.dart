import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/model/product.dart';
import '/model/products_repository.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  List<Card> _buildGridCards(BuildContext context){
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHRINE'),
        actions: <Widget>[
          IconButton(
              onPressed:(){
                print('Search button');
              },
              icon: const Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
          ),
          IconButton(
              onPressed: (){
                print('Filter button');
              },
              icon: const Icon(
                Icons.tune,
                semanticLabel: 'filter',
              ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/api');
            },
            icon: const Icon(
              Icons.photo,
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
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: _buildGridCards(context)
      ),
    );
  }
}

/*
final _routes = {
    '/': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    '/api': (context) => const Api(),
    // '/servicios': (context) => const ServiciosPage(),
  };
 */