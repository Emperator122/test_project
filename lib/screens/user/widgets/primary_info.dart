import 'package:flutter/material.dart';
import 'package:test_project/network/models/user.dart';

class PrimaryInfo extends StatelessWidget {
  final User user;

  const PrimaryInfo({super.key, required this.user,});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Primary information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'USERNAME',
                        style:
                        TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(user.username),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(user.email),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Phone',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(user.phone),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Website',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(user.website),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}
