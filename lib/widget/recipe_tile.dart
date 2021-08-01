import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';


class Recipetile extends StatelessWidget {
  final String imageUrl;
  final String recipeName;
  final String recipeId;
  final String imageName;

  Recipetile(this.imageUrl,this.imageName, this.recipeName, this.recipeId,{Key key}):super(key: key);
  void editRecipe(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AddMealScreen.routeName, arguments: {'edit':recipeId});
  }

  @override
  Widget build(BuildContext context) {
final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords('recipeTile');

    return Dismissible(
      key: ValueKey(recipeId),
      onDismissed: (dir) async {
        final isDeleting = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(langMap[ 'deleting?']),
            content: Text(langMap['check']),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(langMap[ 'delete'])),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(langMap['cancel']))
            ],
          ),
        );
        if (isDeleting) {
          try {
            if(imageName.isNotEmpty){
               FirebaseStorage.instance
                .ref()
                .child('Recipes')
                .child(imageName).delete();
            }
            
            await FirebaseFirestore.instance
                .collection('Recipes')
                .doc(recipeId)
                .delete();
          } catch (error) {
            print(error);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(langMap['errorMsg'],
                    style: TextStyle(color: Theme.of(context).errorColor))));
          }
        }
      },
      background: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Icon(
              Icons.delete,
              color: Colors.red,
            )
          ],
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(recipeName),
        onTap: () => editRecipe(context),
        trailing: IconButton(
            onPressed: () => editRecipe(context), icon: Icon(Icons.edit)),
      ),
    );
  }
}
