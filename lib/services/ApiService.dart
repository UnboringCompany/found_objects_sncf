import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/FoundObject.dart';

class ApiService {
  static const String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';
  static const String dataset = 'objets-trouves-restitution';

  Future<List<FoundObject>> fetchObjects() async {
    final response = await http.get(Uri.parse('$baseUrl?dataset=$dataset'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      if (data.isEmpty) {
        return []; // return an empty list if no new objects are found
      } else {
        return data.map((json) => FoundObject.fromJson(json['fields'])).toList();
      }
    } else {
      throw Exception('Failed to load objects');
    }
  }

  Future<List<FoundObject>> fetchObjectsWithFilters({
    String? stationName,
    String? objectType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = -1,
  }) async {
    String queryParams = '&rows=$limit';
    if (stationName != null) {
      queryParams += '&station_name=$stationName';
    }
    if (objectType != null) {
      queryParams += '&nature=$objectType';
    }
    if (startDate != null) {
      final startDateUtc = startDate.toUtc();
      queryParams += '&date_min=${startDateUtc.toIso8601String()}';
    }
    if (endDate != null) {
      final endDateUtc = endDate.toUtc();
      queryParams += '&date_max=${endDateUtc.toIso8601String()}';
    }
    final response = await http.get(Uri.parse('$baseUrl?dataset=$dataset$queryParams'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      if (data.isEmpty) {
        return []; // return an empty list if no objects are found
      } else {
        return data.where((json) => json['fields']['gc_obo_date_heure_restitution_c'] == null).map((json) => FoundObject.fromJson(json['fields'])).toList();
      }
    } else {
      throw Exception('Failed to load objects');
    }
  }

}
