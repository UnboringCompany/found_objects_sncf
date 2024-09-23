import 'package:flutter/foundation.dart';
import '../services/StationService.dart';
import '../models/Station.dart';

class StationProvider with ChangeNotifier {
  List<Station> _objects = [];

  List<Station> get objects => _objects;

  void setObjects(List<Station> objects) {
    _objects = objects;
    notifyListeners();
  }

  Future<void> fetchObjects() async {
    _objects = await StationService().fetchObjects();
    notifyListeners();
  }

  List<String> getStationNames() {
    return _objects.map((station) => station.nom).toList();
  }

}
