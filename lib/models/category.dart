import 'package:flutter/material.dart';

class Category {
  final String id;
  final String titleAR;
  final String titleEN;
  final Color color;
  final int index;

  const Category({
    @required this.id,
    @required this.titleAR,
    @required this.titleEN,
    this.color = Colors.orange,
    this.index,
  });
}
