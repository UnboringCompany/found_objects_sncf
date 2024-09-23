import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/FoundObject.dart';

class ApiService {
  static const String baseUrl = 'https://ressources.data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records';
  static const String buildUrl = 'https://ressources.data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records?where=gc_obo_gare_origine_r_name%3D"Paris%20Montparnasse"%20and%20gc_obo_type_c%3D"Divers"%20and%20date>%3Ddate\'2019\'%20and%20date<date\'2021\'&limit=20';
  static const String dataset = 'objets-trouves-restitution';

  Future<List<FoundObject>> fetchObjects() async {
    final response = await http.get(Uri.parse(buildUrl));

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (data.isEmpty) {
        return []; // return an empty list if no new objects are found
      } else {
        return data.map((json) => FoundObject.fromJson(json)).toList();
      }
    } else {
      throw Exception('Failed to load objects, response code : $response.statusCode');
    }
  }

  // Future<List<FoundObject>> fetchObjectsWithFilters({
  //   String? stationName,
  //   String? objectType,
  //   DateTime? startDate,
  //   DateTime? endDate,
  //   int limit = 20,
  // }) async {
  //   String queryParams = '&rows=$limit';
  //   if (stationName != null) {
  //     queryParams += '&station_name=$stationName';
  //   }
  //   if (objectType != null) {
  //     queryParams += '&nature=$objectType';
  //   }
  //   if (startDate != null) {
  //     final startDateUtc = startDate.toUtc();
  //     queryParams += '&date_min=${startDateUtc.toIso8601String()}';
  //   }
  //   if (endDate != null) {
  //     final endDateUtc = endDate.toUtc();
  //     queryParams += '&date_max=${endDateUtc.toIso8601String()}';
  //   }
  //   final response = await http.get(Uri.parse('$baseUrl?dataset=$dataset$queryParams'));

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body)['records'];
  //     if (data.isEmpty) {
  //       return []; // return an empty list if no objects are found
  //     } else {
  //       return data.where((json) => json['fields']['gc_obo_date_heure_restitution_c'] == null).map((json) => FoundObject.fromJson(json['fields'])).toList();
  //     }
  //   } else {
  //     throw Exception('Failed to load objects');
  //   }
  // }

  Future<List<FoundObject>> fetchObjectsWithFilters({
  String? stationName,
  String? typeObject,
  DateTime? startDate,
  DateTime? endDate,
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
    final endDateUtc = endDate.toUtc();
    whereConditions.add('date%20%3C%3D%20"${endDateUtc.toIso8601String()}"');
  }
  if (whereConditions.isNotEmpty) {
    print("Conditions :");
    print(whereConditions);
    queryParams += '&where=${whereConditions.join('%20and%20')}';
  }
  final response = await http.get(Uri.parse('$baseUrl?$queryParams'));

  print('$baseUrl?$queryParams');

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
