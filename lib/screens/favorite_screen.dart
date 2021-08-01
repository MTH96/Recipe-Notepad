import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:provider/provider.dart';

import '../widget/recipe_item.dart';
import '../models/recipe.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords('Favorites');
    
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Recipes').where('fav',arrayContains: FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.docs.isEmpty) 
            return Center(child: Text(langMap['noFav']));

            final docs = snapshot.data.docs;
           

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index)=>  RecipeItem(createRecipe(docs[index].id, docs[index].data()))
          
        );
      }
    );
  }
}
