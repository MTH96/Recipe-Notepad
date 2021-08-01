import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipes.dart';

class MealScreen extends StatefulWidget {
  static const routeName = './meal-screen';

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  bool showIngredients = false;
  bool showSteps = false;
  Widget newSection(bool controller, String title) {
    return ListTile(
      title: Text(
        title,
      ),
      trailing: IconButton(
        icon: Icon(controller ? Icons.expand_less : Icons.expand_more),
        onPressed: () {
          setState(() {
            controller = !controller;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<Recipes>(context, listen: false);
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final meal = meals.mealById(mealId);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${meal.title}',
              ),
              background: FadeInImage(
                placeholder: AssetImage('Assets/images/logo.jpeg'),
                image: NetworkImage(
                  meal.imageUrl,
                ),
                width: double.infinity,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text(
                  'Ingredients',
                ),
                trailing: IconButton(
                  icon: Icon(
                      showIngredients ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      showIngredients = !showIngredients;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxHeight:
                        showIngredients ? mediaQuery.size.height * .5 : 0.0,
                    minHeight:
                        showIngredients ? meal.ingredients.length * 20.0 : 0),
                width: mediaQuery.size.height * .8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IngredientsBuilder(
                  steps: meal.steps,
                ),
              ),
              ListTile(
                title: Text(
                  'Steps',
                ),
                trailing: IconButton(
                  icon: Icon(showSteps ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      showSteps = !showSteps;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxHeight: showSteps ? mediaQuery.size.height * .5 : 0,
                    minHeight: showSteps ? meal.steps.length * 20.0 : 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StepsBuilder(meal: meal),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class StepsBuilder extends StatelessWidget {
  const StepsBuilder({
    Key key,
    @required this.meal,
  }) : super(key: key);

  final Recipe meal;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meal.steps.length,
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${index + 1}'),
            ),
            title: Text(
              '${meal.steps[index]}',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}

class IngredientsBuilder extends StatelessWidget {
  const IngredientsBuilder({
    Key key,
    @required this.steps,
  }) : super(key: key);

  final List steps;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Container(
        width: 250,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        color: Theme.of(context).accentColor,
        child: Text(
          '${steps[index]}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      itemCount: steps.length,
    );
  }
}
