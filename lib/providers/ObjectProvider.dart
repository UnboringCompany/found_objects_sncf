import 'package:flutter/foundation.dart';
import '../services/ApiService.dart';
import '../widgets/FoundObject.dart';

class ObjectsProvider with ChangeNotifier {
  List<FoundObject> _objects = [];

  List<FoundObject> get objects => _objects;

  void setObjects(List<FoundObject> objects) {
    _objects = objects;
    notifyListeners();
  }

  Future<void> fetchObjects() async {
    _objects = await ApiService().fetchObjects();
    notifyListeners();
  }

  Future<List<FoundObject>> fetchObjectsWithFilters(Map<String, String> filters) async {
    _objects = await ApiService().fetchObjectsWithFilters(filters);
    notifyListeners();
    return _objects;
  }


}
