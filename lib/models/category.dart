import 'dart:io';

import 'package:flutter/material.dart';

class Category {
  final String id;
   String title;
   String imageUrl;
   String imageName;
   File image;
  

   Category({
     this.id,
    @required this.title,
   @required   this.imageUrl ,
   this.image,
   this.imageName='',
 
  });
}

Map<String, dynamic> categoryToMap(Category category) {
  return {
    'id': category.id,
    'title': category.title,
     'imageUrl': category.imageUrl,
     'imageName':category.imageName,
  };
}

Category mapToCategory(String categryId,Map<String, dynamic> categoryData) {

  return Category(
    id: categryId,
    title: categoryData['title'],
    imageUrl: categoryData['imageUrl'],
    imageName: categoryData['imageName'],
  );
}