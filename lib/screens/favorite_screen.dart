import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/recipe_item.dart';
import '../providers/recipes.dart';
import '../models/recipe.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<Recipes>(context);
    final List<Recipe> favMeals = meals.favoriteMeals;

    return ListView.builder(
      itemCount: favMeals.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: favMeals[index],
        child: MealItem(),
      ),
    );
  }
}
