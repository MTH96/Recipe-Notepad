import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/meal_screen.dart';
import '../models/recipe.dart';

class MealItem extends StatelessWidget {
  String complexityText(Complexity complexity) {
    switch (complexity) {
      case Complexity.Challenging:
        return 'challenging';
        break;
      case Complexity.Hard:
        return 'hard';
        break;
      case Complexity.Simple:
        return 'simple';
        break;
      default:
        return 'unknown';
    }
  }

  String affordabilityText(Affordability affordability) {
    switch (affordability) {
      case Affordability.Affordable:
        return 'affordable';
        break;
      case Affordability.Luxurious:
        return 'luxurious';
        break;
      case Affordability.Pricey:
        return 'pricey';
        break;
      default:
        return 'unknown';
    }
  }

  void selectedMeal(BuildContext ctx, String mealId) {
    Navigator.of(ctx).pushNamed(MealScreen.routeName, arguments: mealId);
  }

  @override
  Widget build(BuildContext context) {
    final meal = Provider.of<Recipe>(context);
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      radius: 15,
      onTap: () => selectedMeal(context, meal.id),
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
                    meal.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    color: Colors.black54,
                    child: Text(
                      meal.title,
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
                      // meal.toggleFavorite();
                      // print(meal.isFavorite);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.black54,
                      child: Icon(
                        meal.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.yellow,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                height: 50,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Info(
                        icon: Icons.schedule,
                        info: '${meal.duration} min',
                      ),
                      Info(
                        icon: Icons.work,
                        info: '${complexityText(meal.complexity)}',
                      ),
                      Info(
                        icon: Icons.attach_money,
                        info: '${affordabilityText(meal.affordability)} ',
                      ),
                    ]))
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
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
