import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/core/disposable_vm/disposable_vm.dart';
import 'package:test_project/core/sync_bloc/events.dart';
import 'package:test_project/network/models/user.dart';
import 'package:test_project/repositories/users_repository.dart';
import 'package:test_project/screens/users/bloc/users_bloc.dart';
import 'package:test_project/screens/users/widgets/user_card.dart';

class UsersVM extends DisposableVM {
  late final UsersSyncBloc usersSyncBloc;

  UsersVM() {
    usersSyncBloc = UsersSyncBloc(usersRepository: UsersRepositoryImpl());

    usersSyncBloc.add(SyncBlocFetchData());

    add(() => usersSyncBloc.close());
  }

  BuiltList<User> get users {
    assert(usersSyncBloc.state.data != null, 'no data in usersSyncBloc');
    return usersSyncBloc.state.data!;
  }

  bool get syncing =>
      usersSyncBloc.state.syncing || !usersSyncBloc.state.hadSync;
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  late final UsersVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = UsersVM();
  }

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: BlocBuilder(
        bloc: _vm.usersSyncBloc,
        builder: (context, _) {
          if (_vm.syncing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_vm.usersSyncBloc.state.hasOnlyError) {
            return const Center(
              child: Text('Ошибка синхронизации.'),
            );
          }

          return ListView(
            children: _vm.users
                .map(
                  (user) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: UserCard(
                      userName: user.username,
                      name: user.name,
                      onTap: () => true,
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

}
