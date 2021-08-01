import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../widget/recipe_tile.dart';

class MyRecipes extends StatefulWidget {
  static const routeName = '/my-recipes';
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance.currentUser;
    final langMap = Provider.of<LanguageSettings>(context,listen:false)
        .getWords(MyRecipes.routeName);
    return Scaffold(
      appBar: AppBar(
        title: Text(langMap['my Recipes']),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Recipes')
              .where('creatorId',
                  isEqualTo: _auth.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.docs.isEmpty)
              return Center(child: Text(langMap['noRecipe']));
            final docs = snapshot.data.docs;
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (ctx, index) => Recipetile(
                docs[index].data()['imageUrl'],
                docs[index].data()['imageName'],
                docs[index].data()['title'],
                docs[index].id,
                key: ValueKey(docs[index].id),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddMealScreen.routeName),
      ),
    );
  }
}
