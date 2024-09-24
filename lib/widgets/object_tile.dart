import 'package:flutter/material.dart';

final Map<String, IconData> _typeIcons = {
  "Appareils électroniques, informatiques, appareils photo": Icons.computer,
  "Articles d'enfants, de puériculture": Icons.child_care,
  "Articles de sport, loisirs, camping": Icons.sports_basketball,
  "Articles médicaux": Icons.medical_services,
  "Bagagerie: sacs, valises, cartables": Icons.backpack,
  "Bijoux, montres": Icons.watch,
  "Clés, porte-clés, badge magnétique": Icons.vpn_key,
  "Divers": Icons.help,
  "Instruments de musique": Icons.music_note,
  "Livres, articles de papéterie": Icons.book,
  "Optique": Icons.remove_red_eye,
  "Parapluies": Icons.umbrella,
  "Pièces d'identités et papiers personnels": Icons.badge,
  "Porte-monnaie / portefeuille, argent, titres": Icons.account_balance_wallet,
  "Vélos, trottinettes, accessoires 2 roues": Icons.directions_bike,
  "Vêtements, chaussures": Icons.checkroom
};

class ObjectTile extends StatelessWidget {
  final String nature;
  final String type;
  final String station;
  final DateTime date;

  ObjectTile({
    required this.nature,
    required this.type,
    required this.station,
    required this.date,
  });

  IconData get icon => _typeIcons[type] ?? Icons.help;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C343A),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white, // Couleur de l'icône
        ),
        title: Text(
          nature,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Text(
              '$station - ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}