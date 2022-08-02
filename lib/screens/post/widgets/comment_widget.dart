import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_project/network/models/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '${comment.name} ',
            style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.w600),
            children: [
              TextSpan(
                text: '(${comment.email})',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          comment.body,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
