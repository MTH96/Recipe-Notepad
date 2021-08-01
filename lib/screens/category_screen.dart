import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/category_item.dart';
import '../providers/settings.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = 'catregories';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {


    
    final langMap =   Provider.of<LanguageSettings>(context).getWords(CategoryScreen.routeName,);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          final catDos = snapshot.data.docs;
          if (catDos.isEmpty) {
            return Center(child: Text(langMap['noCat']));
          }

          List<Category> categories = [];
          catDos.forEach((cat) {

            categories.add(mapToCategory(cat.id, cat.data()));

          });

          return GridView(
            children: categories.map((cat) {
              return CategoryItem(
                imageUrl: cat.imageUrl,
                title: cat.title,
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
        });
  }
}
