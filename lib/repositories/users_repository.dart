import 'package:built_collection/built_collection.dart';
import 'package:test_project/network/api/users.dart';
import 'package:test_project/network/models/user.dart';

abstract class UsersRepository {
  Future<BuiltList<User>> getUsers();
}

class UsersRepositoryImpl extends UsersRepository {
  final UsersApi usersApi;

  UsersRepositoryImpl() : usersApi = UsersApiImpl();

  @override
  Future<BuiltList<User>> getUsers() {
    return usersApi.getUsers();
  }
}
