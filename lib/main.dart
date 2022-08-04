import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_project/network/preferences/endpoints.dart';
import 'package:test_project/network/preferences/network_preferences.dart';
import 'package:test_project/screens/users/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UsersScreen(),
    );
  }
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EndpointsAdapter());
  await Hive.openBox<Endpoints>(NetworkPreferences.boxName);
}
