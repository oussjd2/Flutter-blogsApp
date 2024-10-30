import 'package:flutter/material.dart';
import '../model/blog_post.dart';
import '../services/blog_post_service.dart';
import '../widgets/blog_post_card.dart';
import 'blog_detail_screen.dart';
import 'update_blog_screen.dart';
import 'add_blog_screen.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final BlogPostService _blogPostService = BlogPostService();
  late Future<List<BlogPost>> _futureBlogPosts;
  String _searchText = '';
  String _sortField = 'dateOfCreation';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _futureBlogPosts = _blogPostService.getAllBlogPosts();
  }

  void _refreshBlogPosts() {
    setState(() {
      _futureBlogPosts = _blogPostService.getAllBlogPosts(
        search: _searchText,
        sortField: _sortField,
        sortOrder: _sortOrder,
      );
    });
  }

  void _deleteBlogPost(String id) async {
    await _blogPostService.deleteBlogPost(id);
    _refreshBlogPosts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blog post deleted')),
    );
  }

  void _navigateToUpdateScreen(BuildContext context, BlogPost blogPost) async {
    final updatedBlogPost = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBlogScreen(blogPost: blogPost),
      ),
    );
    if (updatedBlogPost != null) {
      _refreshBlogPosts();
    }
  }

  void _navigateToDetailScreen(BuildContext context, BlogPost blogPost) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogDetailScreen(blogPost: blogPost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Posts "ResQeats'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBlogScreen()),
              ).then((_) {
                _refreshBlogPosts();
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                    _refreshBlogPosts();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: _sortField,
                      items: <String>['dateOfCreation', 'upVotes', 'downVotes']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sortField = value!;
                        });
                        _refreshBlogPosts();
                      },
                    ),
                    DropdownButton<String>(
                      value: _sortOrder,
                      items: <String>['asc', 'desc'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sortOrder = value!;
                        });
                        _refreshBlogPosts();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<BlogPost>>(
        future: _futureBlogPosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No blog posts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final blogPost = snapshot.data![index];
                return BlogPostCard(
                  blogPost: blogPost,
                  onDelete: () => _deleteBlogPost(blogPost.id),
                  onUpdate: () => _navigateToUpdateScreen(context, blogPost),
                  onView: () => _navigateToDetailScreen(context, blogPost),
                );
              },
            );
          }
        },
      ),
    );
  }
}
