import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/recipe_item.dart';
import '../models/recipe.dart';
import '../providers/recipes.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = '/category-meals';
  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<Recipes>(context);

    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    final List<Recipe> categoryMeals = meals.mealsByCat(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => meals.getRecipes(),
        child: ListView.builder(
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: categoryMeals[index],
            child: MealItem(),
          ),
          itemCount: categoryMeals.length,
        ),
      ),
    );
  }
}
