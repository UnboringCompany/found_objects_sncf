/// A class that represents a found object.
///
/// This class has several fields, including [date], [restitution_date], [station_name], [uic_station], [nature], [type], and [record_type].
/// It also provides factory and toJson methods for converting JSON objects to Dart objects and vice versa.
class FoundObject {
  /// The date and time when the object was found.
  final DateTime date;

  /// The date and time when the object was returned, if applicable.
  final DateTime? restitution_date;

  /// The name of the station where the object was found.
  final String station_name;

  /// The UIC code of the station where the object was found.
  final String uic_station;

  /// The nature of the object.
  final String nature;

  /// The type of the object.
  final String type;

  /// The record type of the object.
  final String record_type;

  /// Constructs a new instance of the [FoundObject] class.
  ///
  /// [date] The date and time when the object was found.
  /// [restitution_date] The date and time when the object was returned, if applicable.
  /// [station_name] The name of the station where the object was found.
  /// [uic_station] The UIC code of the station where the object was found.
  /// [nature] The nature of the object.
  /// [type] The type of the object.
  /// [record_type] The record type of the object.
  FoundObject({
    required this.date,
    this.restitution_date,
    required this.station_name,
    required this.uic_station,
    required this.nature,
    required this.type,
    required this.record_type,
  });

  /// Factory method to convert a JSON object into a Dart object.
  ///
  /// [json] The JSON object to convert.
  ///
  /// Returns a new instance of the [FoundObject] class.
  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: DateTime.parse(json['date'] ?? ''),
      restitution_date: json['gc_obo_date_heure_restitution_c'] != null ? DateTime.parse(json['gc_obo_date_heure_restitution_c']) : null,
      station_name: json['gc_obo_gare_origine_r_name'] ?? '',
      uic_station: json['gc_obo_gare_origine_r_uic_c'] ?? '',
      nature: json['gc_obo_nature_c'] ?? '',
      type: json['gc_obo_type_c'] ?? '',
      record_type: json['gc_obo_nom_recordtype_sc_c'] ?? '',
    );
  }

  /// Method to convert a Dart object into a JSON object.
  ///
  /// Returns a JSON object representing this instance of the [FoundObject] class.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'restitution_date': restitution_date?.toIso8601String(),
      'station_name': station_name,
      'uic_station': uic_station,
      'nature': nature,
      'type': type,
      'record_type': record_type,
    };
  }
}
