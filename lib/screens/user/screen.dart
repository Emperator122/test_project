import 'package:flutter/material.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/screens/user/widgets/primary_info.dart';

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
      ),
      body: ListView(
        children: [
          PrimaryInfo(user: widget.user),
        ],
      ),
    );
  }
}
