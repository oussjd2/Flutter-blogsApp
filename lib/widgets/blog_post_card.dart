import 'package:flutter/material.dart';
import 'dart:math';
import '../model/blog_post.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPost blogPost;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onView;

  BlogPostCard({
    required this.blogPost,
    required this.onDelete,
    required this.onUpdate,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    // List of placeholder images from assets
    final List<String> placeholderImages = [
      '/images/1.png',
      '/images/2.jpg',
      '/images/3.jpg',
      '/images/4.png',
      '/images/aa.jpg',
      '/images/cc.png',



    ];

    // Select a random placeholder image if the blog post has no images
    final String imageUrl = blogPost.images.isNotEmpty
        ? blogPost.images[0]
        : placeholderImages[Random().nextInt(placeholderImages.length)];

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: blogPost.images.isNotEmpty
                      ? NetworkImage(blogPost.images[0])
                      : AssetImage(imageUrl) as ImageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),

            Text('Title: ${blogPost.title}'),
            Text('Content: ${blogPost.content}'),
            Text('Author: ${blogPost.author}'),
            Text('Tags: ${blogPost.tags.join(', ')}'),
            Text('Date: ${blogPost.dateOfCreation.toString()}'),
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
                Text('${blogPost.upVotes}'),
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
                Text('${blogPost.downVotes}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onUpdate,
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: onView,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
