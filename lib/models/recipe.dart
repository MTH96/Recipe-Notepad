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

class Recipe with ChangeNotifier {
  String id;
  String creatorId;
  List<String> categories;
  String title;
  String imageUrl;
  List<String> ingredients;
  List<String> steps;
  int duration;
  Complexity complexity;
  Affordability affordability;
  bool isFavorite;

  Recipe({
    this.id,
    this.creatorId,
    @required this.categories,
    @required this.title,
    @required this.imageUrl,
    @required this.ingredients,
    @required this.steps,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    this.isFavorite = false,
  });

  // void toggleFavorite() async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();

  //   List<String> favData = pref.getStringList('fav');
  //   if (favData != null) {
  //     if (favData.contains(id)) {
  //       //if the data has this item as a favorite
  //       favData.remove(id);
  //     } else {
  //       //if the data hasn't this item as a favorite
  //       //then add
  //       favData.add(id);
  //     }
  //     pref.setStringList('fav', favData);
  //   } else {
  //     //if there is no favorites at all
  //     //then creat one
  //     List<String> favData = [];
  //     favData.add(id);
  //     pref.setStringList('fav', favData);
  //   }
  //   isFavorite = !isFavorite;
  //   print(isFavorite);
  //   notifyListeners();
  // }

  Map<String, dynamic> recipeTojson(String userId) {
    return {
      'title': this.title,
      'imageUrl': this.imageUrl,
      'ingredients': this.ingredients,
      'steps': this.steps,
      'duration': this.duration,
      'complexity': getComlexity(this.complexity),
      'affordability': getAfford(this.affordability),
      'categories': this.categories,
      'creatorId': userId,
    };
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
        print('error');
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
        print('error');
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
        print('error');
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
        print('error');
        return Affordability.Affordable;
    }
  }
}

Recipe createRecipe(String recipeId, Map recipeData) {
  return Recipe(
      id: recipeId,
      title: recipeData['title'],
      affordability: Recipe.setAfford(recipeData['affordability'] as int),
      complexity: Recipe.setComlexity(recipeData['complexity'] as int),
      imageUrl: recipeData['imageUrl'] as String,
      duration: recipeData['duration'],
      steps: [...recipeData['steps']],
      ingredients: [...recipeData['ingredients']],
      categories: [...recipeData['categories']],
      creatorId: recipeData['creatorId']);
}
