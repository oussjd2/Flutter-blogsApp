import 'package:flutter/material.dart';
import '../model/blog_post.dart';
import '../services/blog_post_service.dart';

class UpdateBlogScreen extends StatefulWidget {
  final BlogPost blogPost;

  const UpdateBlogScreen({Key? key, required this.blogPost}) : super(key: key);

  @override
  _UpdateBlogScreenState createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
  final BlogPostService _blogPostService = BlogPostService();
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _content;
  late String _author;
  late List<String> _tags;
  late bool _disableComments;

  @override
  void initState() {
    super.initState();
    _title = widget.blogPost.title;
    _content = widget.blogPost.content;
    _author = widget.blogPost.author;
    _tags = widget.blogPost.tags;
    _disableComments = widget.blogPost.disableComments;
  }

  Future<void> _updateBlogPost() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlogPost updatedPost = BlogPost(
        id: widget.blogPost.id,
        title: _title,
        content: _content,
        author: _author,
        tags: _tags,
        dateOfCreation: widget.blogPost.dateOfCreation,
        upVotes: widget.blogPost.upVotes,
        downVotes: widget.blogPost.downVotes,
        images: widget.blogPost.images,
        comments: widget.blogPost.comments,
        disableComments: _disableComments,
      );

      try {
        await _blogPostService.updateBlogPost(widget.blogPost.id, updatedPost);
        Navigator.pop(context, updatedPost);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update blog post')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
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
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 8,
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
                initialValue: _author,
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
                initialValue: _tags.join(', '),
                decoration: InputDecoration(labelText: 'Tags (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tags';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tags = value!.split(',').map((tag) => tag.trim()).toList();
                },
              ),
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
                onPressed: _updateBlogPost,
                child: Text('Update Blog Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
