import 'package:flutter/material.dart';
import '../model/blog_post.dart';

class UpdateCommentScreen extends StatefulWidget {
  final Comment comment;

  const UpdateCommentScreen({Key? key, required this.comment}) : super(key: key);

  @override
  _UpdateCommentScreenState createState() => _UpdateCommentScreenState();
}

class _UpdateCommentScreenState extends State<UpdateCommentScreen> {
  late TextEditingController _authorController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _authorController = TextEditingController(text: widget.comment.commentAuthor);
    _contentController = TextEditingController(text: widget.comment.content);
  }

  @override
  void dispose() {
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveUpdatedComment() {
    final updatedComment = widget.comment.copyWith(
      commentAuthor: _authorController.text,
      content: _contentController.text,
    );
    Navigator.pop(context, updatedComment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUpdatedComment,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
