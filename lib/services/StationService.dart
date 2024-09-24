/// A service class that fetches a list of [Station] instances from a remote API.
///
/// This class provides a method for fetching stations.
/// It uses the [http] package to make HTTP requests to the remote API.
library;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/Station.dart';

class StationService {
  /// The base URL of the remote API.
  static const String baseUrl = 'https://data.sncf.com/api/records/1.0/search/';

  /// The name of the dataset to fetch from the remote API.
  static const String dataset = 'gares-de-voyageurs';

  /// Fetches a list of [Station] instances from the remote API.
  ///
  /// This method throws an [Exception] if the HTTP request to the remote API fails.
  ///
  /// Returns a future that completes with a list of [Station] instances.
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
