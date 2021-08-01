import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../widget/recipe_item.dart';
import '../models/recipe.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = '/category-meals';

  void addRecipe(BuildContext ctx,catId) {
    Navigator.of(ctx).pushNamed(AddMealScreen.routeName, arguments: {'add':catId});
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final categoryTitle = routeArgs['title'];
    final String categoryId = routeArgs['id'];
    final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords(CategoryMealsScreen.routeName);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Recipes')
              .where('categories', arrayContains: categoryId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.docs.isEmpty)
              return Center(child: Text(langMap['noRecipe']));

            final docs = snapshot.data.docs;

            return ListView.builder(
              itemBuilder: (ctx, index) =>
                  RecipeItem(createRecipe(docs[index].id, docs[index].data())),
              itemCount: docs.length,
            );
          }),
           floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>addRecipe(context, categoryId)
      ),
    );
  }
}
