import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/providers/settings.dart';
import 'package:meals/widget/image_handler.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = './add-gategory';

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _form=GlobalKey<FormState>();

  Category _newCategory = Category(
    title: '',
    imageUrl: '',
    image: null,
  );
  final titleArController = TextEditingController();
  final titleEnController = TextEditingController();
  bool _isAdding=false;

  void _saveCategory() async{
     setState(() {
      _isAdding = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();

      try {
       
          final res = await FirebaseFirestore.instance.collection('Category').add(categoryToMap(_newCategory));
          if (_newCategory.image != null) {
            final imageRef = FirebaseStorage.instance
                .ref()
                .child('Category')
                .child(res.id + '.' + _newCategory.image.path.split('.').last);
            await imageRef.putFile(_newCategory.image).whenComplete(() async =>
                _newCategory.imageUrl = await imageRef.getDownloadURL());

            await FirebaseFirestore.instance
                .collection('Category')
                .doc(res.id)
                .update({
              'imageUrl': _newCategory.imageUrl,
            });
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

  void onSaveImageFile(File imageFile) => _newCategory.image = imageFile;

  void onSaveImageUrl(String imageUrl) => _newCategory.imageUrl = imageUrl;

  @override
  Widget build(BuildContext context) {
    final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords(AddCategoryScreen.routeName);
    return Scaffold(
      appBar: AppBar(
        title: Text(langMap['addCat']),
      ),
      body: Form(
        key: _form,
        child: _isAdding?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: titleArController,
                    decoration: InputDecoration(labelText: langMap['Title']),
                    textInputAction: TextInputAction.next,
                    onSaved: (val) {
                      _newCategory.title = val;
                    },

                    validator: (val) {
                      if (val.isEmpty) return langMap['errMsg'];
                      
                      return null;
                    },
                  ),
                  
                  ImageHandler(
                      _newCategory.imageUrl, onSaveImageUrl, onSaveImageFile,250)
                ],
              ),
              ElevatedButton.icon(
                  onPressed: _saveCategory,
                  icon: Icon(Icons.save),
                  label: Text(langMap['save']))
            ],
          ),
        ),
      ),
    );
  }
}
