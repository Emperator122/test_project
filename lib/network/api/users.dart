import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/models/user.dart';
import 'package:http/http.dart' as http;

abstract class UsersApi {
  Future<BuiltList<User>> getUsers();
}

class UsersApiImpl extends UsersApi {
  @override
  Future<BuiltList<User>> getUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode != 200) {
      throw Exception();
    }
    final decodedJson = jsonDecode(response.body) as List<dynamic>;
    final users = decodedJson.map((user) => User.fromJson(user)).toBuiltList();
    return users;
  }
}
