import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meals/providers/settings.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';

class CommentBox extends StatelessWidget {
  final Comment comment;
  final String recipeId;
  CommentBox({
    @required this.comment,
    @required this.recipeId,
  });

  final commentController = TextEditingController();
  Map<String, String> langMap;
  Future<void> editComment(BuildContext ctx) async {
    commentController.text = comment.content;
    await showModalBottomSheet(
        context: ctx,
        builder: (ctx) => Container(
            alignment: Alignment.topCenter,
            child: TextField(
              controller: commentController,
              onSubmitted: (val) async {
                await FirebaseFirestore.instance
                    .collection('Recipes')
                    .doc(recipeId)
                    .collection('comments')
                    .doc(comment.id)
                    .update({'content': commentController.text});
                Navigator.of(ctx).pop();
              },
            )));
  }

  Future<void> deleteComment(BuildContext ctx) async {
    final bool deleteing = await showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              content: Text(langMap['warrning']),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text(langMap['delete'])),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text(langMap['cancel']))
              ],
            ));
    if (deleteing)
      FirebaseFirestore.instance
          .collection('Recipes')
          .doc(recipeId)
          .collection('comments')
          .doc(comment.id)
          .delete();
  }

  @override
  Widget build(BuildContext context) {
    langMap = Provider.of<LanguageSettings>(context,listen:false).getWords(
      'commentBox',
    );

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('userInfo')
            .doc(comment.creatorId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              color: Colors.lime,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          if (!snapshot.hasData)
            return Container(
              color: Colors.lime,
              padding:const EdgeInsets.all(10),
              child: Center(
                child: Text(langMap['errMsg']),
              ),
            );
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      snapshot.data.data()['userPhoto'],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        snapshot.data.data()['userName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(comment.content),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async => await editComment(context),
                            label: Text(langMap['edit']),
                            icon: Icon(Icons.edit),
                          ),
                          TextButton.icon(
                            onPressed: () async => await deleteComment(context),
                            label: Text(langMap['delete']),
                            icon: Icon(Icons.delete),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }
}
