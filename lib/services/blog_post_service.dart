import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../model/blog_post.dart';

class BlogPostService {
  final String baseUrl = 'http://localhost:5000';

  // Updated getAllBlogPosts function in BlogPostService
  Future<List<BlogPost>> getAllBlogPosts({String search = '', String sortField = 'dateOfCreation', String sortOrder = 'desc'}) async {
    final response = await http.get(Uri.parse('$baseUrl/blogpost?search=$search&sortField=$sortField&sortOrder=$sortOrder'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load blog posts');
    }
  }


  // Create a new blog post
  Future<BlogPost> createBlogPost(BlogPost blogPost) async {
    final uri = Uri.parse('$baseUrl/blogpost');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blogPost.toJson()),
    );
    if (response.statusCode == 201) {
      return BlogPost.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create blog post');
    }
  }

  // Upload image
  Future<http.Response> uploadImage(String base64Image) async {
    final response = await http.post(
      Uri.parse('$baseUrl/blogpost/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );
    return response;
  }


  // Fetch a single blog post by ID
  Future<BlogPost> getBlogPostById(String id) async {
    final uri = Uri.parse('$baseUrl/blogpost/$id');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return BlogPost.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load blog post');
    }
  }

  // Update a blog post
  Future<void> updateBlogPost(String id, BlogPost blogPost) async {
    final uri = Uri.parse('$baseUrl/blogpost/$id');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(blogPost.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update blog post');
    }
  }

  // Delete a blog post
  Future<void> deleteBlogPost(String id) async {
    final uri = Uri.parse('$baseUrl/blogpost/$id');
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete blog post');
    }
  }

  // Add a comment to a blog post
  Future<void> addComment(String postId, Comment comment) async {
    final uri = Uri.parse('$baseUrl/blogpost/$postId/comments');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }

  // Update a comment
  Future<void> updateComment(String postId, String commentId, Comment comment) async {
    final uri = Uri.parse('$baseUrl/blogpost/$postId/comments/$commentId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }
  }

  // Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    final uri = Uri.parse('$baseUrl/blogpost/$postId/comments/$commentId');
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }

  // Search blog posts
  Future<List<BlogPost>> searchBlogPosts(String searchText) async {
    final uri = Uri.parse('$baseUrl/blogpost/search?search=$searchText');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search blog posts');
    }
  }

  // Filter blog posts by upvotes
  Future<List<BlogPost>> filterBlogPostsByUpvotes() async {
    final uri = Uri.parse('$baseUrl/blogpost/filter/upvotes');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to filter blog posts by upvotes');
    }
  }

  // Filter blog posts by author
  Future<List<BlogPost>> filterBlogPostsByAuthor(String author) async {
    final uri = Uri.parse('$baseUrl/blogpost/filter/author?author=$author');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to filter blog posts by author');
    }
  }

  // Filter blog posts by upvotes ascending
  Future<List<BlogPost>> filterBlogPostsByUpvotesAsc() async {
    final uri = Uri.parse('$baseUrl/blogpost/filter/upvotes/asc');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to filter blog posts by upvotes ascending');
    }
  }

  // Filter blog posts by upvotes descending
  Future<List<BlogPost>> filterBlogPostsByUpvotesDesc() async {
    final uri = Uri.parse('$baseUrl/blogpost/filter/upvotes/desc');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => BlogPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to filter blog posts by upvotes descending');
    }
  }

  // Upvote a blog post
  Future<void> upvoteBlogPost(String id) async {
    final uri = Uri.parse('$baseUrl/blogpost/$id/upvote');
    final response = await http.post(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to upvote blog post');
    }
  }

  // Downvote a blog post
  Future<void> downvoteBlogPost(String id) async {
    final uri = Uri.parse('$baseUrl/blogpost/$id/downvote');
    final response = await http.post(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to downvote blog post');
    }
  }

  Future<BlogPost> toggleComments(String postId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/blogpost/$postId/toggle-comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return BlogPost.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to toggle comments');
    }
  }
}




