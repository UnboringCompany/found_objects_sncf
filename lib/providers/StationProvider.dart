/// A provider class that manages a list of [Station] instances.
///
/// This class uses the [ChangeNotifier] class from the Flutter framework to notify listeners of changes to the list of stations.
/// It also provides a method for fetching stations from the [StationService] and a method for getting a list of station names.
library;
import 'package:flutter/foundation.dart';
import '../services/StationService.dart';
import '../models/Station.dart';

class StationProvider with ChangeNotifier {
  /// The list of [Station] instances managed by this provider.
  List<Station> _objects = [];

  /// Returns the list of [Station] instances managed by this provider.
  List<Station> get objects => _objects;

  /// Sets the list of [Station] instances managed by this provider.
  ///
  /// This method also notifies listeners of the change.
  void setObjects(List<Station> objects) {
    _objects = objects;
    notifyListeners();
  }

  /// Fetches a list of [Station] instances from the [StationService].
  ///
  /// This method also sets the list of stations managed by this provider and notifies listeners of the change.
  Future<void> fetchObjects() async {
    _objects = await StationService().fetchObjects();
    notifyListeners();
  }

  /// Returns a list of station names.
  ///
  /// This method maps the list of [Station] instances managed by this provider to a list of station names.
  List<String> getStationNames() {
    return _objects.map((station) => station.nom).toList();
  }
}
