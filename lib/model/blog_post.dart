import 'package:flutter/foundation.dart';

class Comment {
  final String id;
  final String commentAuthor;
  final String content;
  final DateTime dateOfCreation;

  Comment({
    required this.id,
    required this.commentAuthor,
    required this.content,
    required this.dateOfCreation,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      commentAuthor: json['commentAuthor'] ?? 'Unknown Author',
      content: json['content'] ?? '',
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'commentAuthor': commentAuthor,
      'content': content,
      'dateOfCreation': dateOfCreation.toIso8601String(),
    };
  }

  Comment copyWith({
    String? id,
    String? commentAuthor,
    String? content,
    DateTime? dateOfCreation,
  }) {
    return Comment(
      id: id ?? this.id,
      commentAuthor: commentAuthor ?? this.commentAuthor,
      content: content ?? this.content,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
    );
  }
}



class BlogPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final List<String> tags;
  final DateTime dateOfCreation;
  final int upVotes;
  final int downVotes;
  final List<String> images;
  final List<Comment> comments;
  final bool disableComments; // Add this field

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.tags,
    required this.dateOfCreation,
    required this.upVotes,
    required this.downVotes,
    required this.images,
    required this.comments,
    required this.disableComments, // Add this field
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      tags: List<String>.from(json['tags']),
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
      upVotes: json['upVotes'],
      downVotes: json['downVotes'],
      images: List<String>.from(json['images']),
      comments: (json['comments'] as List)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
      disableComments: json['disableComments'] ?? false, // Parse from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'tags': tags,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'upVotes': upVotes,
      'downVotes': downVotes,
      'images': images,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
