import 'package:flutter/material.dart';
import 'package:meals/screens/add_meal_screen.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';
import '../screens/my_recipes_screen.dart';
import '../providers/auth.dart';

class DrawerTab extends StatefulWidget {
  static const routeName = 'drawer';

  @override
  _DrawerTabState createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  bool _isEng;
  Widget buildListTile(
      {IconData icon,
      String title,
      Function onTapHandler,
      Widget trialingWidget}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 40,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: trialingWidget,
      onTap: onTapHandler,
    );
  }

  void onLangSwitch(LanguageSettings lang, [bool value]) {
    setState(() {
      _isEng = !_isEng;
    });
    Provider.of<LanguageSettings>(context, listen: false).setIsEng(_isEng);
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final languageSettings = Provider.of<LanguageSettings>(context);
    final Map<String, String> langMap = languageSettings.getWords(
      DrawerTab.routeName,
    );
    _isEng = languageSettings.isEng;
    return Drawer(
      child: Column(
        children: [
          Stack(children: [
            Container(
              height: 150,
              color: Theme.of(context).accentColor,
              alignment: Alignment.center,
              child: Text(languageSettings.getWords('name')['appName'],
                  style: TextStyle(
                      fontFamily: 'ArefRuqaa',
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
          SizedBox(
            height: 5,
          ),
          buildListTile(
            icon: Icons.restaurant,
            title: langMap['category'],
            onTapHandler: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          buildListTile(
            icon: Icons.add,
            title: langMap['add recpie'],
            onTapHandler: () => Navigator.of(context)
                .pushReplacementNamed(AddMealScreen.routeName),
          ),
          buildListTile(
            icon: Icons.language,
            title: langMap['language switch'],
            onTapHandler: () => onLangSwitch(languageSettings),
            trialingWidget: Switch(
              value: _isEng,
              onChanged: (value) => onLangSwitch(languageSettings, value),
            ),
          ),
          buildListTile(
            icon: Icons.exit_to_app_rounded,
            title: 'logOut',
            onTapHandler: () => _logOut(),
          ),
        ],
      ),
    );
  }

  void _logOut() {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
