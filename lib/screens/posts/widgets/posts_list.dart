import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:test_project/network/models/post.dart';

class PostsList extends StatelessWidget {
  final BuiltList<Post> posts;
  final Function(Post post) onPostTap;

  const PostsList({
    super.key,
    required this.posts,
    required this.onPostTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ...posts
              .map(
                (post) => InkWell(
                  onTap: () => onPostTap(post),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Divider(),
                          Text(
                            post.body,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
