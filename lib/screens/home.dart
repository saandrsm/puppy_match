import 'package:flutter/material.dart';
import 'package:tutorial3_flutter/screens/busqueda.dart';
import 'package:tutorial3_flutter/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool shouldPop = true; //vueltra atrás activada

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);  //variable para utilizar colores del tema definido

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
        // builder: (context, constraints) {

          // if (constraints.maxWidth < 450){
          //   return Column(
          //     children: [
          //       SafeArea(
          //         child:
        bottomNavigationBar: BottomNavigationBar( //barra de navegación entre HomePage y ProfilePage
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
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
              //],
            //);
          // } else {
          //   return Row(
          //     children: [
          //       SafeArea(
          //         child: NavigationRail(
          //           extended: constraints.maxWidth >= 600,
          //           destinations: const [
          //             NavigationRailDestination(
          //               icon: Icon(Icons.home),
          //               label: Text('Home'),
          //             ),
          //             NavigationRailDestination(
          //               icon: Icon(Icons.person),
          //               label: Text('Profile'),
          //             ),
          //           ],
          //           selectedIndex: selectedIndex,
          //           onDestinationSelected: (value) {
          //             setState(() {
          //               selectedIndex = value;
          //             });
          //           },
          //         ),
          //       ),
          //     ],
          //   );
          // }
    );
  }
}
