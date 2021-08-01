import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/settings.dart';
import '../models/recipe.dart';
import '../widget/image_handler.dart';

class AddMealScreen extends StatefulWidget {
  static const routeName = '/add-meal-screen';
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddMealScreen> {
  final _form = GlobalKey<FormState>();
  final _stepsForm = GlobalKey<FormState>();
  final _ingForm = GlobalKey<FormState>();
  final recipesRef = FirebaseFirestore.instance.collection('Recipes');
  String titleInit;
  String durationInit;

  bool isEditing = false;
  bool _init = true;

  Recipe editingRecipe;

  Recipe _newRecipe = Recipe(
    title: '',
    imageUrl: '',
    image: null,
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
  String recipeId;

  bool get buttonValidation {
    if (_newRecipe.complexity == null ||
        _newRecipe.affordability == null ||
        _newRecipe.categories.isEmpty ||
        _newRecipe.ingredients.isEmpty ||
        _newRecipe.steps.isEmpty) return false;

    if (_newRecipe.image == null && _newRecipe.imageUrl.isEmpty) return false;
    return true;
  }

  // List<bool> categoryCheckBox = [];

  Map<String, Complexity> compMap = {};
  Map<String, Affordability> affMap = {};

  void onSaveImageUrl(String imageUrl) => _newRecipe.imageUrl = imageUrl;
  void onSaveImageFile(File imageFile) => _newRecipe.image = imageFile;

  @override
  void initState(){
    langMap = Provider.of<LanguageSettings>(context, listen: false)
        .getWords(AddMealScreen.routeName);
    _isEng = Provider.of<LanguageSettings>(context,listen: false).isEng;
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

    super.initState();
  }

  Future<void> init(Map<String, dynamic> mode) async {
    if (_init) {
      if (mode != null) {
        if (mode.containsKey('edit')) {
          final recipeData = await recipesRef.doc(mode['edit']).get();
          _newRecipe = createRecipe(recipeData.id, recipeData.data());
          isEditing = true;
        } else if (mode.containsKey('add')) {
          _newRecipe.categories.add(mode['add']);
        }
      }
      _init = false;
    }
  }

  Future<void> _saveRecipe() async {
    setState(() {
      _isAdding = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();

      try {
        if (isEditing) {
          if (_newRecipe.image != null) {
            _newRecipe.imageName =
                recipeId + '.' + _newRecipe.image.path.split('.').last;
            final imageRef = FirebaseStorage.instance
                .ref()
                .child('Recipes')
                .child(_newRecipe.imageName);
            imageRef.putFile(_newRecipe.image);
            _newRecipe.imageUrl = await imageRef.getDownloadURL();
          }
          await recipesRef.doc(recipeId).update({
            'title': _newRecipe.title,
            'imageUrl': _newRecipe.imageUrl,
            'ingredients': _newRecipe.ingredients,
            'steps': _newRecipe.steps,
            'duration': _newRecipe.duration,
            'complexity': Recipe.getComlexity(_newRecipe.complexity),
            'affordability': Recipe.getAfford(_newRecipe.affordability),
            'categories': _newRecipe.categories,
            'imageName': _newRecipe.imageName,
          });
        } else {
          final res = await recipesRef.add(recipeTojson(_newRecipe));
          if (_newRecipe.image != null) {
            _newRecipe.imageName =
                res.id + '.' + _newRecipe.image.path.split('.').last;
            final imageRef = FirebaseStorage.instance
                .ref()
                .child('Recipes')
                .child(_newRecipe.imageName);
            await imageRef.putFile(_newRecipe.image);
            print('====${    _newRecipe.imageName}');
            _newRecipe.imageUrl = await imageRef.getDownloadURL();

            await FirebaseFirestore.instance
                .collection('Recipes')
                .doc(res.id)
                .update({
              'imageUrl': _newRecipe.imageUrl,
              'imageName':_newRecipe.imageName,
            });
          }
        }
      } catch (error) {
        setState(() {
          _isAdding = false;
        });
      }

      Navigator.of(context).pushReplacementNamed('/');
    }
    setState(() {
      _isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return FutureBuilder<void>(
        future: _init ? init(mode) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop()),
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
                                    initialValue:
                                        isEditing ? _newRecipe.title : null,
                                    textAlign: _isEng
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    textDirection: _isEng
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                    decoration: InputDecoration(
                                        hintText: langMap['recipy name']),
                                    onSaved: (value) {
                                      _newRecipe.title = value;
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: _newRecipe.duration == null
                                        ? null
                                        : _newRecipe.duration.toString(),
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    textAlign: _isEng
                                        ? TextAlign.left
                                        : TextAlign.right,
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
                                      _newRecipe.duration = int.parse(value);
                                    },
                                  ),
                                  ImageHandler(_newRecipe.imageUrl,
                                      onSaveImageUrl, onSaveImageFile, 500),
                                  Divider(),
                                  buildListTile(
                                      title: langMap['Affordability title'],
                                      hint: langMap['Affordability hint'],
                                      valueSaver: _newRecipe.affordability,
                                      map: affMap),
                                  Divider(),
                                  buildListTile(
                                      title: langMap['Comlexity title'],
                                      hint: langMap['Comlexity hint'],
                                      valueSaver: _newRecipe.complexity,
                                      map: compMap),
                                  Divider(),
                                  Text(langMap['recipy category'],
                                      textAlign: TextAlign.center),
                                  buildCategoryGetter(),
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
                                            duration:
                                                Duration(milliseconds: 300),
                                            constraints: BoxConstraints(
                                              minHeight:
                                                  _ingLength <= index ? 0 : 10,
                                              maxHeight:
                                                  _ingLength <= index ? 0 : 70,
                                            ),
                                            child: _ingLength <= index
                                                ? null
                                                : buildTextFormField(
                                                    index,
                                                    _newRecipe.ingredients,
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
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                if (_ingLength < maxIng) {
                                                  setState(() {
                                                    _ingLength++;
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(langMap[
                                                              'max ing. 10'])));
                                                }
                                              },
                                              child: Text(
                                                langMap['add ingredient'],
                                                textDirection: _isEng
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                              )),
                                        ),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
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
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Text(langMap['steps'],
                                      textAlign: TextAlign.center),
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
                                              duration:
                                                  Duration(milliseconds: 300),
                                              constraints: BoxConstraints(
                                                minHeight: _stepsLength <= index
                                                    ? 0
                                                    : 10,
                                                maxHeight: _stepsLength <= index
                                                    ? 0
                                                    : 70,
                                              ),
                                              child: _stepsLength <= index
                                                  ? null
                                                  : buildTextFormField(
                                                      index,
                                                      _newRecipe.steps,
                                                      langMap['step']),
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
                                        Expanded(
                                          child: TextButton(
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
                                        ),
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                _stepsForm.currentState.save();
                                                setState(() {
                                                  _stepsLength = 0;
                                                });
                                              },
                                              child: Text(
                                                langMap['save steps'],
                                                overflow: TextOverflow.clip,
                                                textDirection: _isEng
                                                    ? TextDirection.ltr
                                                    : TextDirection.rtl,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: buttonValidation
                                  ? () async => await _saveRecipe()
                                  : null,
                              child: Text(langMap['save']))
                        ],
                      ),
                    ),
            ),
          );
        });
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
      if (value.runtimeType == Complexity) _newRecipe.complexity = value;
      if (value.runtimeType == Affordability) _newRecipe.affordability = value;
    });
  }

  Widget buildCategoryGetter() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          final catDos = snapshot.data.docs;
          if (catDos.isEmpty) {
            return Center(child: Text('add category first'));
          }
          List<Category> categories = [];
          snapshot.data.docs.forEach(
              (cat) => categories.add(mapToCategory(cat.id, cat.data())));
          return Column(
            children: categories
                .map((cat) => CheckboxListTile(
                    title: Text(
                      cat.title,
                      textDirection:
                          _isEng ? TextDirection.ltr : TextDirection.rtl,
                    ),
                    value: _newRecipe.categories.contains(cat.id),
                    onChanged: (value) => categoryCheck(value, cat)))
                .toList(),
          );
        });
  }

  void categoryCheck(bool value, Category cat) {
    if (value) {
      setState(() {
        _newRecipe.categories.add(cat.id);
      });
    } else {
      setState(() {
        _newRecipe.categories.remove(cat.id);
      });
    }
  }

  TextFormField buildTextFormField(int index, List<String> list, String hint) {
    return TextFormField(
      initialValue: index < list.length ? list[index] : null,
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
