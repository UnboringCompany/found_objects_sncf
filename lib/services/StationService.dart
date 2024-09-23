import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/Station.dart';

class StationService {
  static const String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';
  static const String dataset = 'gares-de-voyageurs';

  Future<List<Station>> fetchObjects() async {
    final response = await http.get(Uri.parse('$baseUrl?dataset=$dataset&rows=-1'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      if (data.isEmpty) {
        return []; // return an empty list if no new objects are found
      } else {
        return data.map((json) => Station.fromJson(json['fields'])).toList();
      }
    } else {
      throw Exception('Failed to load objects');
    }
  }

}