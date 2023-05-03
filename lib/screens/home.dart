import 'package:flutter/material.dart';
import 'package:tutorial3_flutter/screens/busqueda.dart';
import 'package:tutorial3_flutter/screens/profile.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int selectedIndex = 0;
  // static const List<Widget> _widgetOptions = <Widget>[
  //
  // ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Widget page;
    switch(selectedIndex){
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const ProfilePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }


    return Scaffold(
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

        bottomNavigationBar: BottomNavigationBar(
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
                    selectedItemColor: Colors.brown,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                );
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

  }
}
