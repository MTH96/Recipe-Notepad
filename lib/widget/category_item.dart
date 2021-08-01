import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';
import '../screens/category_meal_screen.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  const CategoryItem({
    @required this.imageUrl,
    @required this.title,
    @required this.id,
  });
  void categoryNavigate(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: {'title': title, 'id': id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords(AddMealScreen.routeName);
    return InkWell(
      onTap: () {
        categoryNavigate(context);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: Image.network(
          imageUrl,
          width: 250,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
          errorBuilder: (a1, a2, a3) {
            return Text('😢\n${langMap['error']}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange));
          },
        ),
        footer: Container(
          alignment: Alignment.center,
          color: Colors.grey[400].withOpacity(.7),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}
