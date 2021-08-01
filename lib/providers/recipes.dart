import 'package:flutter/material.dart';
import 'package:meals/models/database.dart';
import '../models/category.dart';
import '../models/recipe.dart';

const CATEGORIES = const [
  Category(
    id: 'c1',
    titleAR: 'محاشي',
    titleEN: 'Stuffed',
    color: Colors.purple,
    index: 0,
  ),
  Category(
    id: 'c2',
    titleAR: 'سهل وسريع',
    titleEN: 'Fast & Easy',
    color: Colors.red,
    index: 1,
  ),
  Category(
    id: 'c3',
    titleAR: 'أسماك',
    titleEN: 'Fish',
    color: Colors.orange,
    index: 2,
  ),
  Category(
    id: 'c4',
    titleAR: 'مقليات',
    titleEN: 'Fries',
    color: Colors.amber,
    index: 3,
  ),
  Category(
    id: 'c5',
    titleAR: 'خفيف',
    titleEN: 'Light',
    color: Colors.blue,
    index: 4,
  ),
  Category(
    id: 'c6',
    titleAR: 'طبيخ',
    titleEN: 'Cooking',
    color: Colors.green,
    index: 5,
  ),
  Category(
    id: 'c7',
    titleAR: 'فطار',
    titleEN: 'Breakfast',
    color: Colors.lightBlue,
    index: 6,
  ),
  Category(
    id: 'c8',
    titleAR: 'نباتي',
    titleEN: 'Vegetarian',
    color: Colors.lightGreen,
    index: 7,
  ),
  // Category(
  //   id: 'c9',
  //   title: 'فرنسي',
  //   color: Colors.pink,
  // ),
  // Category(
  //   id: 'c10',
  //   title: 'صيفي',
  //   color: Colors.teal,
  // ),
];

class Recipes with ChangeNotifier {
  List<Recipe> _items = [];

  final _database = MyDatabase();
  final String userId;
  Recipes(this.userId, this._items);

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final recipeId =
          await _database.addItem('meals', recipe.recipeTojson(userId));
      _items
          .add(createRecipe(recipeId.toString(), recipe.recipeTojson(userId)));
      print(_items.length);

      notifyListeners();
    } catch (e) {
      print('error>>$e');
    }
  }

  Future<void> getRecipes() async {
    try {
      final recipes =
          await _database.readitems('meals') as Map<String, dynamic>;
      if (recipes == null) return;
      print(recipes);
      recipes.forEach((recipeId, recipeData) {
        _items.add(createRecipe(recipeId.toString(), recipeData));
      });

      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  List<Recipe> get items {
    return [..._items];
  }

  List<Recipe> get favoriteMeals {
    return _items.where((meal) => meal.isFavorite).toList();
  }

  Recipe mealById(String mealId) {
    return _items.firstWhere((meal) => mealId == meal.id);
  }

  List<Recipe> mealsByCat(String categoryId) {
    return _items
        .where((meal) => meal.categories.contains(categoryId))
        .toList();
  }

/*

import 'package:firebase_database/firebase_database.dart';
import 'post.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference savePost(Post post) {
  var id = databaseReference.child('posts/').push();
  id.set(post.toJson());
  return id;
}

void updatePost(Post post, DatabaseReference id) {
  id.update(post.toJson());
}

Future<List<Post>> getAllPosts() async {
  DataSnapshot dataSnapshot = await databaseReference.child('posts/').once();
  List<Post> posts = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Post post = createPost(value);
      post.setId(databaseReference.child('posts/' + key));
      posts.add(post);
    });
  }
  return posts;
}
*/

  // List<Meal> get filteredMeals {
  //   return _items.where((meal) {
  //     if (filters['glutenFree'] && !meal.isGlutenFree) return false;

  //     if (filters['vegetarian'] && !meal.isVegetarian) return false;

  //     if (filters['vegan'] && !meal.isVegan) return false;

  //     if (filters['lactoseFree'] && !meal.isLactoseFree) return false;

  //     return true;
  //   }).toList();
  // }

  // List<dynamic> _printstr(dynamic inputs) {
  //   print('1>>>${inputs}');
  //   print('2>>>${inputs.length}');
  //   print('3>>>${inputs.toString()}');
  //   print('4>>>${inputs.runtimeType}');
  //   return inputs;
  // }

  // Map<String, bool> filters = {
  //   'glutenFree': false,
  //   'vegetarian': false,
  //   'vegan': false,
  //   'lactoseFree': false,
  // };
  // void setFilters(
  //     {bool glutenFree, bool vegetarian, bool vegan, bool lactoseFree}) {
  //   filters['glutenFree'] = glutenFree;
  //   filters['vegetarian'] = vegetarian;
  //   filters['vegan'] = vegan;
  //   filters['lactoseFree'] = lactoseFree;
  //   ChangeNotifier();
  // }
}
