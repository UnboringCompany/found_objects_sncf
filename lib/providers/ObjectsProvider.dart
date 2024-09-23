import 'package:flutter/foundation.dart';
import '../services/ObjectService.dart';
import '../models/FoundObject.dart';

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

  Future<List<FoundObject>> fetchObjectsWithFilters({String? stationName, String? typeObject, DateTime? startDate, DateTime? endDate}) async {
    print('stationName: $stationName, typeObject: $typeObject, startDate: $startDate, endDate: $endDate');
    _objects = await ApiService().fetchObjectsWithFilters(stationName: stationName, typeObject: typeObject, startDate: startDate, endDate: endDate);
    notifyListeners();
    return _objects;
  }


}
