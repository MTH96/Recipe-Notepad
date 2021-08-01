import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/settings.dart';
import '../models/recipe.dart';
import '../providers/recipes.dart';

class AddMealScreen extends StatefulWidget {
  static const routeName = '/add-meal-screen';
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _form = GlobalKey<FormState>();
  final _stepsForm = GlobalKey<FormState>();
  final _ingForm = GlobalKey<FormState>();
  Recipe meal = Recipe(
    title: '',
    imageUrl: '',
    ingredients: [],
    steps: [],
    categories: [],
    duration: null,
    complexity: null,
    affordability: null,
  );

  int _ingLength = 0;
  int _stepsLength = 0;
  int maxIng = 10;
  int maxSteps = 10;
  bool _isAdding = false;
  Map<String, String> langMap = {};
  bool _isEng;

  get buttonValidation {
    if (meal.complexity == null ||
        meal.affordability == null ||
        meal.categories.isEmpty ||
        meal.ingredients.isEmpty ||
        meal.steps.isEmpty) return false;
    return true;
  }

  List<bool> categoryCheckBox = [];

  Map<String, Complexity> compMap = {};
  Map<String, Affordability> affMap = {};

  @override
  void initState() {
    langMap = Provider.of<LanguageSettings>(context, listen: false)
        .getWords(AddMealScreen.routeName);
    _isEng = Provider.of<LanguageSettings>(context, listen: false).isEng;
    compMap = {
      langMap['Simple'].toString(): Complexity.Simple,
      langMap['Challenging'].toString(): Complexity.Challenging,
      langMap['Hard'].toString(): Complexity.Hard,
    };
    affMap = {
      langMap['Affordable']: Affordability.Affordable,
      langMap['Pricey']: Affordability.Pricey,
      langMap['Luxurious']: Affordability.Luxurious,
    };
    CATEGORIES.forEach((element) {
      categoryCheckBox.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/')),
        title: Text(langMap['add new recipe']),
      ),
      body: Form(
        key: _form,
        child: _isAdding
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              textAlign:
                                  _isEng ? TextAlign.left : TextAlign.right,
                              textDirection: _isEng
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              decoration: InputDecoration(
                                  hintText: langMap['recipy name']),
                              onSaved: (value) {
                                meal.title = value;
                              },
                            ),
                            TextFormField(
                              textAlign:
                                  _isEng ? TextAlign.left : TextAlign.right,
                              textDirection: _isEng
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: langMap['duration'],
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return langMap['add duration'];
                                try {
                                  int.parse(value);
                                } catch (e) {
                                  return langMap['valid duration'];
                                }
                                return null;
                              },
                              onSaved: (value) {
                                meal.duration = int.parse(value);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Expanded(
                                  child: TextFormField(
                                    textAlign: _isEng
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    textDirection: _isEng
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    decoration: InputDecoration(
                                      hintText: langMap['photo Link'],
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return langMap['add photo link error'];

                                      return null;
                                    },
                                    onChanged: (value) => setState(() {
                                      meal.imageUrl = value;
                                    }),
                                    onSaved: (value) => meal.imageUrl = value,
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.grey,
                                  )),
                                  alignment: Alignment.center,
                                  child: meal.imageUrl.isEmpty
                                      ? Text(
                                          langMap['add photo Link'],
                                          textAlign: TextAlign.center,
                                        )
                                      : Image.network(meal.imageUrl,
                                          loadingBuilder: (ctx, _, _1) =>
                                              CircularProgressIndicator(),
                                          errorBuilder: (_1, _2, _3) {
                                            return Text(
                                                '😢\n${langMap['error']}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.orange));
                                          }),
                                )
                              ]),
                            ),
                            buildListTile(
                                title: langMap['Affordability title'],
                                hint: langMap['Affordability hint'],
                                valueSaver: meal.affordability,
                                map: affMap),
                            Divider(),
                            buildListTile(
                                title: langMap['Comlexity title'],
                                hint: langMap['Comlexity hint'],
                                valueSaver: meal.complexity,
                                map: compMap),
                            Divider(),
                            Text(langMap['recipy category'],
                                textAlign: TextAlign.center),
                            ...buildCategoryGetter(),
                            Divider(),
                            Text(langMap['Ingredients'],
                                textAlign: TextAlign.center),
                            Form(
                              key: _ingForm,
                              child: AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                constraints: BoxConstraints(
                                  minHeight: _ingLength * 10.0,
                                  maxHeight: _ingLength * 70.0,
                                ),
                                child: ListView.builder(
                                  itemCount: maxIng,
                                  itemBuilder: (ctx, index) {
                                    return AnimatedContainer(
                                      curve: Curves.easeIn,
                                      duration: Duration(milliseconds: 300),
                                      constraints: BoxConstraints(
                                        minHeight: _ingLength <= index ? 0 : 10,
                                        maxHeight: _ingLength <= index ? 0 : 70,
                                      ),
                                      child: _ingLength <= index
                                          ? null
                                          : buildTextFormField(
                                              index,
                                              meal.ingredients,
                                              langMap['Ingredient']),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if (_ingLength < maxIng) {
                                          setState(() {
                                            _ingLength++;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      langMap['max ing. 10'])));
                                        }
                                      },
                                      child: Text(
                                        langMap['add ingredient'],
                                        textDirection: _isEng
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        _ingForm.currentState.save();
                                        setState(() {
                                          _ingLength = 0;
                                        });
                                      },
                                      child: Text(
                                        langMap['save Ingredient'],
                                        textDirection: _isEng
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                      ))
                                ],
                              ),
                            ),
                            Divider(),
                            Text(langMap['steps'], textAlign: TextAlign.center),
                            Form(
                              key: _stepsForm,
                              child: AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                constraints: BoxConstraints(
                                  minHeight: _stepsLength * 10.0,
                                  maxHeight: _stepsLength * 70.0,
                                ),
                                child: ListView.builder(
                                    itemCount: maxIng,
                                    itemBuilder: (ctx, index) {
                                      return AnimatedContainer(
                                        curve: Curves.easeIn,
                                        duration: Duration(milliseconds: 300),
                                        constraints: BoxConstraints(
                                          minHeight:
                                              _stepsLength <= index ? 0 : 10,
                                          maxHeight:
                                              _stepsLength <= index ? 0 : 70,
                                        ),
                                        child: _stepsLength <= index
                                            ? null
                                            : buildTextFormField(index,
                                                meal.steps, langMap['step']),
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if (_stepsLength < maxSteps) {
                                          setState(() {
                                            _stepsLength++;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(langMap[
                                                      'max steps 10'])));
                                        }
                                      },
                                      child: Text(
                                        langMap['add step'],
                                        textDirection: _isEng
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        _stepsForm.currentState.save();
                                        setState(() {
                                          _stepsLength = 0;
                                        });
                                      },
                                      child: Text(
                                        langMap['save steps'],
                                        textDirection: _isEng
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: !buttonValidation
                            ? null
                            : () async {
                                setState(() {
                                  _isAdding = true;
                                });
                                if (_form.currentState.validate()) {
                                  _form.currentState.save();
                                  // print(meal.imageUrl);
                                  // print('title:${meal.title}');
                                  // print(meal.ingredients);
                                  // print(meal.steps);
                                  // print(meal.complexity);
                                  // print(meal.affordability);
                                  // print('duration:${meal.duration}');

                                  try {
                                    await Provider.of<Recipes>(context,
                                            listen: false)
                                        .addRecipe(
                                      Recipe(
                                          imageUrl: meal.imageUrl,
                                          title: meal.title,
                                          ingredients: meal.ingredients,
                                          steps: meal.steps,
                                          complexity: meal.complexity,
                                          affordability: meal.affordability,
                                          duration: meal.duration,
                                          categories: meal.categories),
                                    );
                                  } catch (error) {
                                    setState(() {
                                      _isAdding = false;
                                    });
                                  }

                                  Navigator.of(context)
                                      .pushReplacementNamed('/');
                                }
                                setState(() {
                                  _isAdding = false;
                                });
                              },
                        child: Text(langMap['save']))
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildListTile({
    @required String title,
    @required String hint,
    @required Map<String, dynamic> map,
    @required dynamic valueSaver,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            softWrap: true,
            textDirection: _isEng ? TextDirection.ltr : TextDirection.rtl,
          ),
        ),
        DropdownButton(
          hint: Text(
            hint,
            textDirection: _isEng ? TextDirection.ltr : TextDirection.rtl,
          ),
          value: valueSaver,
          onChanged: setComplexityAffordability,
          items: List.generate(
            map.length,
            (index) => DropdownMenuItem(
              child: Text(
                map.keys.toList()[index],
                textDirection: _isEng ? TextDirection.ltr : TextDirection.rtl,
              ),
              value: map.values.toList()[index],
            ),
          ),
        ),
      ],
    );
  }

  void setComplexityAffordability(value) {
    setState(() {
      if (value.runtimeType == Complexity) meal.complexity = value;
      if (value.runtimeType == Affordability) meal.affordability = value;
    });
  }

  List<Widget> buildCategoryGetter() {
    return CATEGORIES
        .map((cat) => CheckboxListTile(
            title: Text(
              _isEng ? cat.titleEN : cat.titleAR,
              textDirection: _isEng ? TextDirection.ltr : TextDirection.rtl,
            ),
            value: categoryCheckBox[cat.index],
            onChanged: (value) => categoryCheck(value, cat)))
        .toList();
  }

  void categoryCheck(bool value, Category cat) {
    if (value) {
      meal.categories.add(cat.id);
      setState(() {
        categoryCheckBox[cat.index] = true;
      });
    } else {
      meal.categories.remove(cat.id);
      setState(() {
        categoryCheckBox[cat.index] = false;
      });
    }
  }

  TextFormField buildTextFormField(int index, List<String> list, String hint) {
    return TextFormField(
      textAlign: _isEng ? TextAlign.left : TextAlign.right,
      textDirection: _isEng ? TextDirection.ltr : TextDirection.rtl,
      maxLines: 2,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: '$hint ${index + 1}'),
      onSaved: (value) {
        if (value.isNotEmpty) list.insert(index, value);
      },
    );
  }
}
