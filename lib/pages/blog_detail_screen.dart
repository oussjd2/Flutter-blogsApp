import 'dart:math';
import 'package:flutter/material.dart';
import 'package:garduino_dashboard/pages/update_comment_screen.dart';
import '../model/blog_post.dart';
import '../services/blog_post_service.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogPost blogPost;

  const BlogDetailScreen({Key? key, required this.blogPost}) : super(key: key);

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final BlogPostService _blogPostService = BlogPostService();
  late BlogPost _blogPost;

  @override
  void initState() {
    super.initState();
    _blogPost = widget.blogPost;
  }

  void _toggleComments() async {
    final updatedPost = await _blogPostService.toggleComments(_blogPost.id);
    setState(() {
      _blogPost = updatedPost;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comments ${_blogPost.disableComments ? 'disabled' : 'enabled'}')),
    );
  }

  void _deleteComment(String postId, String commentId) async {
    await _blogPostService.deleteComment(postId, commentId);
    setState(() {
      _blogPost.comments.removeWhere((comment) => comment.id == commentId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment deleted')),
    );
  }

  void _updateComment(String postId, Comment updatedComment) async {
    await _blogPostService.updateComment(postId, updatedComment.id, updatedComment);
    setState(() {
      int index = _blogPost.comments.indexWhere((comment) => comment.id == updatedComment.id);
      if (index != -1) {
        _blogPost.comments[index] = updatedComment;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment updated')),
    );
  }

  void _navigateToUpdateCommentScreen(Comment comment) async {
    final updatedComment = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCommentScreen(comment: comment),
      ),
    );
    if (updatedComment != null) {
      _updateComment(_blogPost.id, updatedComment);
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of placeholder images from assets
    final List<String> placeholderImages = [
      'assets/images/aa.jpg',
      'assets/images/bb.png',
      'assets/images/cc.png',
    ];

    // Select a random placeholder image if the blog post has no images
    final String imageUrl = _blogPost.images.isNotEmpty
        ? _blogPost.images[0]
        : placeholderImages[Random().nextInt(placeholderImages.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text(_blogPost.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _blogPost.images.isNotEmpty
                        ? NetworkImage(_blogPost.images[0])
                        : AssetImage(imageUrl) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _blogPost.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8.0),
              Text('Author: ${_blogPost.author}'),
              SizedBox(height: 8.0),
              Text('Tags: ${_blogPost.tags.join(', ')}'),
              SizedBox(height: 8.0),
              Text('Date: ${_blogPost.dateOfCreation.toLocal().toString().split(' ')[0]}'),
              SizedBox(height: 8.0),
              Row(
                children: [
                  // Upvote icon
                  Container(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      icon: Image.asset('assets/icon/ic_upvote.png'),
                      onPressed: () {},
                      padding: EdgeInsets.all(0),
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('${_blogPost.upVotes}'),
                  SizedBox(width: 10),
                  // Downvote icon
                  Container(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      icon: Image.asset('assets/icon/ic_downvote.png'),
                      onPressed: () {},
                      padding: EdgeInsets.all(0),
                      iconSize: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('${_blogPost.downVotes}'),
                ],
              ),
              SizedBox(height: 8.0),
              Text('Content:'),
              SizedBox(height: 8.0),
              Text(_blogPost.content),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: _toggleComments,
                child: Text(_blogPost.disableComments ? 'Enable Comments' : 'Disable Comments'),
              ),
              SizedBox(height: 8.0),
              Text('Comments:'),
              if (!_blogPost.disableComments) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _blogPost.comments.length,
                  itemBuilder: (context, index) {
                    final comment = _blogPost.comments[index];
                    return ListTile(
                      title: Text(comment.commentAuthor),
                      subtitle: Text(comment.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _navigateToUpdateCommentScreen(comment),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteComment(_blogPost.id, comment.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                Text('Comments are disabled for this blog post.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}