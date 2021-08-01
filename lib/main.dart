import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import './providers/settings.dart';
import './screens/tabs_screen.dart';
import './screens/category_meal_screen.dart';
import './screens/meal_screen.dart';
import 'screens/add_recipe_screen.dart';
import './screens/auth_screen.dart';
import './screens/my_recipes_screen.dart';
import 'screens/add_category_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget splashScreen = SplashScreenView(
      navigateRoute: HomeScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "dev_assets/splash.jpg",
      text: "Recipe Notepad",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      title: 'Splash screen',
      home: splashScreen,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageSettings(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe Notepad',
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
          AddCategoryScreen.routeName: (ctx) => AddCategoryScreen(),
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  void checkConnectivity(BuildContext ctx, Map<String, String> langMap) async {
    try {
      final result = await InternetAddress.lookup('facebook.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(langMap['ok']))
          ],
          title: Text(langMap['worning']),
          content: Text(langMap['errMsg']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final langMap = Provider.of<LanguageSettings>(context).getWords('home');
    checkConnectivity(context, langMap);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.hasData) //there is avalid token
          return TabsScreen();
        return AuthScreen();
      },
    );
  }
}
