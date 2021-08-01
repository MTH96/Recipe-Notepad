import 'package:flutter/material.dart';

import '../widget/drawer_tab.dart';
import 'category_screen.dart';
import 'favorite_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _selectedScreen = [
    {
      'page': CategoryScreen(),
      'title': 'Categories',
    },
    {
      'page': FavoriteScreen(),
      'title': 'Favorites',
    },
  ];

  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(_selectedScreen[_selectedScreenIndex]['title'])),
      body: _selectedScreen[_selectedScreenIndex]['page'],
      drawer: DrawerTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              label: 'Favorite'),
        ],
      ),
    );
  }
}
