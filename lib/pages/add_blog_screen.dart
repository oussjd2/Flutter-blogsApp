import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html; // Import HTML package for web

import '../model/blog_post.dart';
import '../services/blog_post_service.dart';

class AddBlogScreen extends StatefulWidget {
  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _author = '';
  String _tags = '';
  bool _disableComments = false;
  html.File? _image;
  final BlogPostService _blogPostService = BlogPostService();

  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        setState(() {
          _image = files.first;
        });
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newBlog = BlogPost(
        id: '',
        title: _title,
        content: _content,
        author: _author,
        tags: _tags.split(','),
        dateOfCreation: DateTime.now(),
        upVotes: 0,
        downVotes: 0,
        images: [],
        comments: [],
        disableComments: _disableComments, // Add this field
      );

      if (_image != null) {
        // Upload image
        final reader = html.FileReader();
        reader.readAsDataUrl(_image!);
        reader.onLoadEnd.listen((e) async {
          final response = await _blogPostService.uploadImage(reader.result as String);
          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            newBlog.images.add(responseData['url']);
            // Create blog post
            await _blogPostService.createBlogPost(newBlog);
            Navigator.pop(context); // Go back to the previous screen after creating the blog post
          }
        });
      } else {
        // Add a placeholder image URL
        newBlog.images.add('https://via.placeholder.com/150');
        // Create blog post
        await _blogPostService.createBlogPost(newBlog);
        Navigator.pop(context); // Go back to the previous screen after creating the blog post
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
                onSaved: (value) {
                  _content = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
                onSaved: (value) {
                  _author = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tags (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tags';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tags = value!;
                },
              ),
              SizedBox(height: 16.0),
              SwitchListTile(
                title: Text('Disable Comments'),
                value: _disableComments,
                onChanged: (bool value) {
                  setState(() {
                    _disableComments = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
