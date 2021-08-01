import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './providers/recipes.dart';
import './providers/auth.dart';
import './providers/settings.dart';
import './screens/tabs_screen.dart';
import './screens/category_meal_screen.dart';
import './screens/meal_screen.dart';
import './screens/add_meal_screen.dart';
import './screens/auth_screen.dart';
import './screens/my_recipes_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Recipes>(
          update: (ctx, auth, previousRecipes) => Recipes(auth.userId,
              previousRecipes == null ? [] : previousRecipes.items),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageSettings(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meals',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.purple,
          fontFamily: 'Raleway',
        ),
        routes: {
          '/': (ctx) => Home(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
          MealScreen.routeName: (ctx) => MealScreen(),
          MyRecipes.routeName: (ctx) => MyRecipes(),
          AddMealScreen.routeName: (ctx) => AddMealScreen(),
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listener = Provider.of<Auth>(context);
    return listener.isSignIn ? TabsScreen() : AuthScreen();
  }
}
