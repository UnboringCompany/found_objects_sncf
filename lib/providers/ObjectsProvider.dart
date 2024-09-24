/// A provider class that manages a list of [FoundObject] instances.
///
/// This class uses the [ChangeNotifier] class from the Flutter framework to notify listeners of changes to the list of objects.
/// It also provides a method for fetching objects with filters from the [ObjectsService].
library;
import 'package:flutter/foundation.dart';
import 'package:myapp/enums/SortOrder.dart';
import '../services/ObjectService.dart';
import '../models/FoundObject.dart';

class ObjectsProvider with ChangeNotifier {
  /// The list of [FoundObject] instances managed by this provider.
  List<FoundObject> _objects = [];

  /// Returns the list of [FoundObject] instances managed by this provider.
  List<FoundObject> get objects => _objects;

  /// Sets the list of [FoundObject] instances managed by this provider.
  ///
  /// This method also notifies listeners of the change.
  void setObjects(List<FoundObject> objects) {
    _objects = objects;
    notifyListeners();
  }

  /// Fetches a list of [FoundObject] instances from the [ObjectsService] with the specified filters.
  ///
  /// [stationName] The name of the station to filter by.
  /// [typeObject] The type of object to filter by.
  /// [startDate] The start date to filter by.
  /// [endDate] The end date to filter by.
  /// [sortOrder] The order in which to sort the objects.
  ///
  /// This method also sets the list of objects managed by this provider and notifies listeners of the change.
  ///
  /// Returns a future that completes with the list of [FoundObject] instances.
  Future<List<FoundObject>> fetchObjectsWithFilters({String? stationName, String? typeObject, DateTime? startDate, DateTime? endDate, required SortOrder sortOrder}) async {
    _objects = await ObjectsService().fetchObjectsWithFilters(stationName: stationName, typeObject: typeObject, startDate: startDate, endDate: endDate, sortOrder: sortOrder);
    notifyListeners();
    return _objects;
  }
}
