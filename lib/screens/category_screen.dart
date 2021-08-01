import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/category_item.dart';
import '../providers/settings.dart';
import '../providers/recipes.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = 'catregories';
  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<Recipes>(context, listen: false);
    final languageSettings = Provider.of<LanguageSettings>(context);

    final langMap = languageSettings.getWords(CategoryScreen.routeName);

    return FutureBuilder(
        future: meals.getRecipes(),
        builder: (ctx, futureSnapShot) {
          if (futureSnapShot.hasError)
            return AlertDialog(
              content: Text(langMap['loading error']),
              actions: [
                ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                    child: Text(langMap['ok']))
              ],
            );
          else if (futureSnapShot.connectionState == ConnectionState.done)
            return GridView(
              children: CATEGORIES.map((cat) {
                return CategoryItem(
                  color: cat.color,
                  title: languageSettings.isEng ? cat.titleEN : cat.titleAR,
                  id: cat.id,
                );
              }).toList(),
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            );
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}
