import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:provider/provider.dart';

import '../widget/drawer_tab.dart';
import './category_screen.dart';
import './favorite_screen.dart';
import 'add_category_screen.dart';

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
 final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords(TabsScreen.routeName,);

    return Scaffold(
      appBar:
          AppBar(title: Text(langMap[_selectedScreen[_selectedScreenIndex]['title']])),
      body: _selectedScreen[_selectedScreenIndex]['page'],
      drawer: DrawerTab(),
      floatingActionButton: _selectedScreen[_selectedScreenIndex]['title'] !=
              'Categories'
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
              }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: langMap['Categories']),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              label: langMap['Favorite']),
        ],
      ),
    );
  }
}
