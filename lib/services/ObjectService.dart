/// A service class that fetches a list of [FoundObject] instances from a remote API.
///
/// This class provides a method for fetching objects with filters, such as station name, object type, start date, end date, and sort order.
/// It uses the [http] package to make HTTP requests to the remote API.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/enums/SortOrder.dart';
import '../models/FoundObject.dart';

class ObjectsService {
  /// The base URL of the remote API.
  static const String baseUrl = 'https://ressources.data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';

  /// The name of the dataset to fetch from the remote API.
  static const String dataset = 'objets-trouves-restitution';

  /// Fetches a list of [FoundObject] instances from the remote API with the specified filters.
  ///
  /// [stationName] The name of the station to filter by.
  /// [typeObject] The type of object to filter by.
  /// [startDate] The start date to filter by.
  /// [endDate] The end date to filter by.
  /// [sortOrder] The order in which to sort the objects.
  /// [limit] The maximum number of objects to fetch.
  ///
  /// This method throws an [ArgumentError] if the start date is after the end date, or if the station name or object type is empty.
  /// It also throws an [Exception] if the HTTP request to the remote API fails.
  ///
  /// Returns a future that completes with a list of [FoundObject] instances.
  Future<List<FoundObject>> fetchObjectsWithFilters({
    String? stationName,
    String? typeObject,
    DateTime? startDate,
    DateTime? endDate,
    SortOrder sortOrder = SortOrder.desc,
    int limit = -1,
  }) async {
    // Check that the start date is before the end date
    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before end date');
    }

    // Check that the station name is not empty
    if (stationName != null && stationName.isEmpty) {
      throw ArgumentError.value(stationName, 'stationName', 'Station name cannot be empty');
    }

    // Check that the object type is not empty
    if (typeObject != null && typeObject.isEmpty) {
      throw ArgumentError.value(typeObject, 'typeObject', 'Object type cannot be empty');
    }

    String queryParams = 'limit=$limit';
    List<String> whereConditions = [];

    if (stationName != null) {
      final trimmedStationName = stationName.trim();
      whereConditions.add('gc_obo_gare_origine_r_name%20%3D%20"$trimmedStationName"');
    }

    if (typeObject != null) {
      final trimmedObjectType = typeObject.trim();
      whereConditions.add('gc_obo_type_c%20%3D%20"$trimmedObjectType"');
    }

    if (startDate != null) {
      final startDateUtc = startDate.toUtc();
      whereConditions.add('date%20%3E%3D%20"${startDateUtc.toIso8601String()}"');
    }

    if (endDate != null) {
      final endDateUtc = DateTime(endDate.year, endDate.month, endDate.day, 23, 59).toUtc();
      whereConditions.add('date%20%3C%3D%20"${endDateUtc.toIso8601String()}"');
    }

    if (whereConditions.isNotEmpty) {
      queryParams += '&where=${whereConditions.join('%20and%20')}';
    }

    // Apply the sort order (ASC or DESC) according to the sortOrder parameter
    String orderBy = sortOrder == SortOrder.asc ? 'ASC' : 'DESC';
    queryParams += '&order_by=date%20$orderBy';

    final response = await http.get(Uri.parse('$baseUrl?$queryParams'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (data.isEmpty) {
        return []; // return an empty list if no objects are found
      } else {
        return data.where((json) => json['gc_obo_date_heure_restitution_c'] == null).map((json) => FoundObject.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load objects, response code : ${response.statusCode}');
    }
  }
}
