import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals/models/comment.dart';
import 'package:meals/widget/comment_box.dart';
import 'package:meals/widget/comment_field.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';
import '../models/recipe.dart';

class MealScreen extends StatelessWidget {
  static const routeName = './meal-screen';
  @override
  Widget build(BuildContext context) {
    final recipeId = ModalRoute.of(context).settings.arguments as String;
    final langMap =
        Provider.of<LanguageSettings>(context).getWords(MealScreen.routeName);
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Recipes')
              .doc(recipeId)
              .get(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (futureSnapshot.hasError)
              return Center(
                child: Text(langMap['errMsg']),
              );
            final recipe = createRecipe(
                futureSnapshot.data.id, futureSnapshot.data.data());

            return RecipeScreen(recipe);
          }),
    );
  }
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen(this.recipe, {Key key}) : super(key: key);
  final Recipe recipe;

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool showIngredients = false;
  bool showSteps = false;
  bool showComments = false;
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
    final mediaQuery = MediaQuery.of(context);
    final langMap =
          Provider.of<LanguageSettings>(context, listen: false).getWords(MealScreen.routeName);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.recipe.title}',
              ),
              background: Image.network(widget.recipe.imageUrl, loadingBuilder:
                  (BuildContext context, Widget child,
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
              }, errorBuilder: (a1, a2, a3) {
                return Center(
                  child: Text(
                    '😢${langMap['imgErr']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                );
              }),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text(
                  langMap['ing'],
                ),
                onTap: () {
                  setState(() {
                    showIngredients = !showIngredients;
                  });
                },
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
                padding:const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxHeight: showIngredients
                      ? min(mediaQuery.size.height * .5,
                          widget.recipe.ingredients.length * 120.0)
                      : 0.0,
                ),
                width: mediaQuery.size.height * .8,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IngredientsBuilder(
                  ing: widget.recipe.ingredients,
                ),
              ),
              ListTile(
                title: Text(
                 langMap[ 'steps'],
                ),
                onTap: () {
                  setState(() {
                    showSteps = !showSteps;
                  });
                },
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
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxHeight: showSteps
                      ? min(mediaQuery.size.height * .5,
                          widget.recipe.steps.length * 120.0)
                      : 0.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StepsBuilder(recipe: widget.recipe),
              ),
              ListTile(
                title: Text(
                 langMap[ 'comments'],
                ),
                onTap: () {
                  setState(() {
                    showComments = !showComments;
                  });
                },
                trailing: IconButton(
                  icon: Icon(
                      showComments ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      showComments = !showComments;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 300),
                padding:const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxHeight: showComments
                      ? min(mediaQuery.size.height * .8,
                          (widget.recipe.steps.length * 120.0 + 125))
                      : 0.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(child: CommentBuilder(widget.recipe.id)),
                    CommentField(
                      widget.recipe.id,
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class CommentBuilder extends StatelessWidget {
  CommentBuilder(this.recipeId);
  final String recipeId;

  @override
  Widget build(BuildContext context) {
      final langMap =
        Provider.of<LanguageSettings>(context,listen:false).getWords(MealScreen.routeName);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Recipes')
            .doc(recipeId)
            .collection('comments')
            .orderBy('creatorDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          final commentsDos = snapshot.data.docs;
          if (commentsDos.isEmpty) {
            return Text(langMap['noComment']);
          }

          return ListView.builder(
            reverse: true,
            itemCount: commentsDos.length,
            itemBuilder: (ctx, index) => CommentBox(
                comment: mapToComment(
                    commentsDos[index].id, commentsDos[index].data()),
                recipeId: recipeId),
          );
        });
  }
}

class StepsBuilder extends StatelessWidget {
  const StepsBuilder({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipe.steps.length,
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('# ${index + 1}'),
            ),
            title: Text(
              '${recipe.steps[index]}',
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
    @required this.ing,
  }) : super(key: key);

  final List ing;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Container(
        width: 250,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        color: Theme.of(context).accentColor,
        child: Text(
          '${ing[index]}',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      itemCount: ing.length,
    );
  }
}
