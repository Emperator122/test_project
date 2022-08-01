import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userName;
  final String name;
  final Function() onTap;

  const UserCard({
    super.key,
    required this.userName,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 28),
                  ),
                  Text(name),
                ],
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: const Icon(cupertino.CupertinoIcons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
