import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Comment {
  final String creatorId;
  final DateTime creatorDate;
  final String content;
  final String id;

  Comment({
    @required this.content,
    @required this.creatorDate,
    @required this.creatorId,
     this.id,

  });
}

Map<String, dynamic> commentToMap(Comment comment) {
  return {
    'creatorId': comment.creatorId,
    'content': comment.content,
    'creatorDate': comment.creatorDate
  };
}

Comment mapToComment(String commentId,Map<String, dynamic> commentData) {

  return Comment(
    id: commentId,
    creatorId: commentData['creatorId'],
    creatorDate:( commentData['creatorDate']as Timestamp).toDate(),
    content: commentData['content'],
  );
}
