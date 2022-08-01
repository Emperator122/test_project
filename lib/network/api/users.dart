import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/http_service/http_service.dart';
import 'package:test_project/network/models/user.dart';

abstract class UsersApi {
  Future<BuiltList<User>> getUsers();
}

class UsersApiImpl extends UsersApi {
  @override
  Future<BuiltList<User>> getUsers() async {
    final httpService = HttpService();

    final response = await httpService.makeRequest(uri: 'users');

    final decodedJson = response as List<dynamic>?;
    final users = decodedJson?.map((user) => User.fromJson(user)).toBuiltList();
    return users ?? BuiltList();
  }
}
