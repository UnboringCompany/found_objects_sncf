
class FoundObject {
  final DateTime date;
  final DateTime? restitution_date;
  final String station_name;
  final String uic_station;
  final String nature;
  final String type;
  final String record_type;


  FoundObject({
    required this.date,
    this.restitution_date,
    required this.station_name,
    required this.uic_station,
    required this.nature,
    required this.type,
    required this.record_type,
  });

  factory FoundObject.fromJson(Map<String, dynamic> json) {
    return FoundObject(
      date: DateTime.parse(json['date'] ?? ''),
      restitution_date: json['gc_obo_date_heure_restitution_c'] != null ? DateTime.parse(json['gc_obo_date_heure_restitution_c']) : null,
      station_name: json['gc_obo_gare_origin_r_name'] ?? '',
      uic_station: json['gc_obo_gare_origin_r_uic_c'] ?? '',
      nature: json['gc_obo_nature_c'] ?? '',
      type: json['gc_obo_type_c'] ?? '',
      record_type: json['gc_obo_nom_recordtype_sc_c'] ?? '',
    );
  }


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
