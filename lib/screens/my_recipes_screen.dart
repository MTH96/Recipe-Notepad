import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';
// import '../providers/settings.dart';
import '../providers/recipes.dart';

class MyRecipes extends StatefulWidget {
  static const routeName = '/my-recipes';
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    // final langMap = Provider.of<LanguageSettings>(context, listen: false)
    //     .getWords(MyRecipes.routeName);
    final recipes = Provider.of<Recipes>(context).items;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              icon: Icon(Icons.arrow_back)),
          title: Text('${userData.name}\'s Recipes'),
        ),
        body: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (ctx, index) =>
              Recipetile(recipes[index].imageUrl, recipes[index].title),
        ));
  }
}

class Recipetile extends StatelessWidget {
  final String imageUrl;
  final String recipeName;
  Recipetile(this.imageUrl, this.recipeName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(recipeName),
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
    );
  }
}
