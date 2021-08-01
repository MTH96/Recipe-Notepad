import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';

import '../screens/meal_screen.dart';
import '../models/recipe.dart';

class RecipeItem extends StatelessWidget {
  RecipeItem(this.recipe);
  final Recipe recipe;
  Map<String, String> langMap;

  String complexityText(Complexity complexity) {
    switch (complexity) {
      case Complexity.Challenging:
        return langMap['Challenging'];
        break;
      case Complexity.Hard:
        return langMap['Hard'];
        break;
      case Complexity.Simple:
        return langMap['Simple'];
        break;
      default:
        return langMap['unknown'];
    }
  }

  String affordabilityText(Affordability affordability) {
    switch (affordability) {
      case Affordability.Affordable:
        return langMap['Affordable'];
        break;
      case Affordability.Luxurious:
        return langMap['Luxurious'];
        break;
      case Affordability.Pricey:
        return langMap['Pricey'];
        break;
      default:
        return langMap['unknown'];
    }
  }

  void selectedMeal(BuildContext ctx, String mealId) {
    Navigator.of(ctx).pushNamed(MealScreen.routeName, arguments: mealId);
  }

  @override
  Widget build(BuildContext context) {
    langMap = Provider.of<LanguageSettings>(context,listen:false)
        .getWords(AddMealScreen.routeName);
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      radius: 15,
      onTap: () => selectedMeal(context, recipe.id),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 200,
                    color: Colors.black54,
                    child: Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'RobotoCondensed',
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      recipe.toggleFavorite();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.black54,
                      child: Column(
                        children: [
                          Icon(
                            recipe.favoriteList.contains(
                                    FirebaseAuth.instance.currentUser.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.yellow,
                            size: 40,
                          ),
                          Text(
                            recipe.favoriteList.length.toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FittedBox(
                          child: Info(
                            icon: Icons.schedule,
                            info: '${recipe.duration} ${langMap['min']}',
                          ),
                        ),
                        FittedBox(
                          child: Info(
                            icon: Icons.work,
                            info: '${complexityText(recipe.complexity)}',
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Info(
                        icon: Icons.attach_money,
                        info: '${affordabilityText(recipe.affordability)} ',
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  final IconData icon;
  final String info;
  Info({this.icon, this.info});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: 6,
        ),
        Text(
          info,
        ),
      ],
    );
  }
}
