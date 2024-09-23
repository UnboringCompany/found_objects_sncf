class Station {
  final String nom;

  Station({
    required this.nom,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      nom: json['nom'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
    };
  }
}
