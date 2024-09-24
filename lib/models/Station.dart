/// A class that represents a station.
///
/// This class has a single field, [nom], which represents the name of the station.
/// It also provides factory and toJson methods for converting JSON objects to Dart objects and vice versa.
class Station {
  /// The name of the station.
  final String nom;

  /// Constructs a new instance of the [Station] class.
  ///
  /// [nom] The name of the station.
  Station({
    required this.nom,
  });

  /// Factory method to convert a JSON object into a Dart object.
  ///
  /// [json] The JSON object to convert.
  ///
  /// Returns a new instance of the [Station] class.
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      nom: json['nom'] ?? '',
    );
  }

  /// Method to convert a Dart object into a JSON object.
  ///
  /// Returns a JSON object representing this instance of the [Station] class.
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
    };
  }
}
