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

  Future<List<FoundObject>> fetchObjectsWithFilters(Map<String, String> filters) async {
  String queryParams = '';
  filters.forEach((key, value) {
    queryParams += '&$key=$value';
  });
  final response = await http.get(Uri.parse('$baseUrl?dataset=$dataset$queryParams'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['records'];
    if (data.isEmpty) {
      return []; // return an empty list if no objects are found
    } else {
      return data.map((json) => FoundObject.fromJson(json['fields'])).toList();
    }
  } else {
    throw Exception('Failed to load objects');
  }
}

}
