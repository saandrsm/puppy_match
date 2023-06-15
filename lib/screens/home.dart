import 'package:flutter/material.dart';
import 'package:PuppyMatch/screens/busqueda.dart';
import 'package:PuppyMatch/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool shouldPop = true; //vueltra atrás desactivada

  @override
  Widget build(BuildContext context) {
    //el indice en 0 muestra la HomePage y el indice en 1 muestra la ProfilePage
    Widget page;
    switch(selectedIndex){
      case 0:
        page = const SearchPage();
        break;
      case 1:
        page = const ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }


    return WillPopScope(
        //devuelve un Future
        onWillPop: () async {
      //volver a pantalla anterior
      return shouldPop;
    },
    child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return page;
        }
      ),
        bottomNavigationBar: BottomNavigationBar( //barra de navegación entre HomePage y ProfilePage
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Inicio',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Perfil',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    selectedItemColor: Colors.brown, //el icono del item seleccionado se hace marrón
                    onTap: (value) { //cuando se pulsa se actualiza el estado
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
    );
  }
}
