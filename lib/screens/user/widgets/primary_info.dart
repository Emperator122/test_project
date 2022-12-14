import 'package:flutter/material.dart';
import 'package:test_project/network/models/user.dart';

class PrimaryInfo extends StatelessWidget {
  final User user;

  const PrimaryInfo({
    super.key,
    required this.user,
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
              'Primary information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'USERNAME',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(user.username),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'E-MAIL',
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
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'PHONE',
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
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'WEBSITE',
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
      ),
    );
  }
}
