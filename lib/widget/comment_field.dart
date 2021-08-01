import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';

class CommentField extends StatefulWidget {
  final String recipeId;
  CommentField(this.recipeId);

  @override
  _CommentFieldState createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  Future<void> getComment() async {
    final comment = Comment(
      content: commentController.text,
      creatorDate: DateTime.now(),
      creatorId: FirebaseAuth.instance.currentUser.uid,
    );

    await FirebaseFirestore.instance
        .collection('Recipes')
        .doc(widget.recipeId)
        .collection('comments')
        .add(commentToMap(comment));

    commentController.clear();
  }

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final langMap=Provider.of<LanguageSettings>(context,listen:false).getWords('commentFiled');
    return Container(
      height: 70,
      alignment: Alignment.center,
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: langMap['addComment'],
                fillColor: Colors.grey,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (val){
                setState((){});},
              textInputAction: TextInputAction.newline,
            ),
          ),
          IconButton(
            onPressed: commentController.text.isEmpty?null:() async => await getComment(),
            icon: Icon(Icons.send, color:commentController.text.isEmpty?Colors.grey: Colors.blue),
            alignment: Alignment.center,
            iconSize: 50,
          )
        ],
      ),
    );
  }
}
