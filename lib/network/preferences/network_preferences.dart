import 'package:hive/hive.dart';
import 'package:test_project/network/preferences/endpoints.dart';

const String _key = 'selectedEndpoint';
const _defaultEndpoint = Endpoints.jsonPlaceholder;

class NetworkPreferences {
  static const String boxName = 'networkPreferences';

  late final Box<Endpoints> _box;
  NetworkPreferences() {
    _box = Hive.box<Endpoints>(boxName);
  }

  Endpoints get currentEndpoint {
    final storedEndpoint = _box.get(_key);
    if(storedEndpoint == null) {
      currentEndpoint = _defaultEndpoint;
      return _defaultEndpoint;
    }
    return storedEndpoint;
  }

  set currentEndpoint(Endpoints endpoint) => _box.put(_key, endpoint);
}
