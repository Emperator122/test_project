import 'package:built_collection/built_collection.dart';
import 'package:test_project/core/sync_bloc/sync_bloc.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/users_repository.dart';

class UsersSyncBloc extends BaseSyncBloc<BuiltList<User>> {
  final UsersRepository usersRepository;

  UsersSyncBloc({required this.usersRepository}) : super(null);

  @override
  Future<BuiltList<User>> fetch() async {
    return usersRepository.getUsers();
  }
}
