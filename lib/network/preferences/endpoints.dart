import 'package:hive/hive.dart';

part 'endpoints.g.dart';

const Map<Endpoints, String> _endpointsMap = {
  Endpoints.jsonPlaceholder: 'https://jsonplaceholder.typicode.com',
};

@HiveType(typeId: 0)
enum Endpoints {
  @HiveField(0)
  jsonPlaceholder
}

extension EndpointExt on Endpoints {
  String toUrl() => _endpointsMap[this]!;
}
