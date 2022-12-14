import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:test_project/network/models/post.dart';

class PostsListPreview extends StatelessWidget {
  final BuiltList<Post> posts;
  final Function() onWatchAll;
  final Function(Post post) onPostTap;

  const PostsListPreview({
    super.key,
    required this.posts,
    required this.onWatchAll,
    required this.onPostTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User\'s Posts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(),
            ...posts
                .map(
                  (post) => InkWell(
                    onTap: () => onPostTap(post),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          post.body,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                )
                .toList(),
            Center(
              child: ElevatedButton(
                onPressed: onWatchAll,
                child: const Text('Watch all'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
