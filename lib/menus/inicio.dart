import 'package:aves_dgo_nuevo/paginas/splashscreen.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MiInicio();
  }
}

class MiInicio extends State <Inicio> {
  int _selectedIndex = 0;
  final List <Widget> _children = [
    SplashScreen(),
    SplashScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _children[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Fotos'
          ),
        ],
      ),
    );
  }
}