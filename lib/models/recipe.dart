import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


enum Complexity {
  Simple, //0
  Challenging, //1
  Hard, //2
}

enum Affordability {
  Affordable, //0
  Pricey, //1
  Luxurious, //2
}

class Recipe {
  String id;
  String creatorID;
  List<String> categories;
  String title;
  String imageUrl;
  File image;//for offline handling only uploading to fire storage
  List<String> ingredients;
  List<String> steps;
  int duration;
  Complexity complexity;
  Affordability affordability;
  List<String> favoriteList;
  int favLength;
  String imageName;

  Recipe({
    this.id,
    this.creatorID,
    @required this.image,
    @required this.categories,
    @required this.title,
    @required this.imageUrl,
    @required this.ingredients,
    @required this.steps,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    this.favoriteList = const [],
    this.favLength = 0,
    this.imageName=''
  });

  void toggleFavorite() async {
    List<String> favData = favoriteList;
    int favLen=favLength;
    try {
      if (favData.contains(FirebaseAuth.instance.currentUser.uid)) {
        //if the data has this item as a favorite
        favData.remove(FirebaseAuth.instance.currentUser.uid);
        favLen -= 1;
      } else {
        //if the data has this item as a favorite
        favData.add(FirebaseAuth.instance.currentUser.uid);
         favLen += 1;
      }
      FirebaseFirestore.instance
          .collection('Recipes')
          .doc(id)
          .update({'fav': favData, 'favLength': favLen});
    } catch (error) {
      throw error;
    }
  }

  static int getComlexity(Complexity com) {
    switch (com) {
      case Complexity.Simple:
        return 0;
      case Complexity.Challenging:
        return 1;
      case Complexity.Hard:
        return 2;

      default:
        return -1;
    }
  }

  static Complexity setComlexity(int com) {
    switch (com) {
      case 0:
        return Complexity.Simple;
      case 1:
        return Complexity.Challenging;
      case 2:
        return Complexity.Hard;

      default:
        return Complexity.Simple;
    }
  }

  static int getAfford(Affordability aff) {
    switch (aff) {
      case Affordability.Affordable:
        return 0;
      case Affordability.Pricey:
        return 1;
      case Affordability.Luxurious:
        return 2;

      default:
        return -1;
    }
  }

  static Affordability setAfford(int aff) {
    switch (aff) {
      case 0:
        return Affordability.Affordable;
      case 1:
        return Affordability.Pricey;
      case 2:
        return Affordability.Luxurious;

      default:
        return Affordability.Affordable;
    }
  }
}

Map<String, dynamic> recipeTojson(Recipe recipe) {
  return {
    'title': recipe.title,
    'imageUrl': recipe.imageUrl,
    'ingredients': recipe.ingredients,
    'steps': recipe.steps,
    'duration': recipe.duration,
    'complexity': Recipe.getComlexity(recipe.complexity),
    'affordability': Recipe.getAfford(recipe.affordability),
    'categories': recipe.categories,
    'creatorId': FirebaseAuth.instance.currentUser.uid,
    'fav': recipe.favoriteList,
    'favLength': recipe.favLength,
    'imageName':recipe.imageName,
  };
}

Recipe createRecipe(String recipeId, Map recipeData) {
 
  return Recipe(
    id: recipeId,
    title: recipeData['title'],
    affordability: Recipe.setAfford(recipeData['affordability'] as int),
    complexity: Recipe.setComlexity(recipeData['complexity'] as int),
    image: recipeData['image'],
    imageUrl: recipeData['imageUrl'] as String,
    duration: recipeData['duration'],
    steps: [...recipeData['steps']],
    ingredients: [...recipeData['ingredients']],
    categories: [...recipeData['categories']],
    creatorID: recipeData['creatorId'],
    favoriteList: [...recipeData['fav']],
    favLength: recipeData['favLength'],
    imageName: recipeData['imageName'],
  );
}
