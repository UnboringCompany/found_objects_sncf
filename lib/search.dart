import 'package:flutter/material.dart';
import 'widgets/date_picker_row.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1320), // Couleur de fond
      body: SafeArea( child : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFF3F3F3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1320), size: 20),
                  onPressed: () {
                    Navigator.pop(context); // Retourner à la page précédente
                  },
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Rechercher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
            ),
            const SizedBox(height: 20),
            // Dropdown Gare
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2C343A),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
             child: const Row(
              children: [
                Text('Gare :', style: TextStyle(color: Color(0xFF656A6E), fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    cursorColor:  Color(0xFF8EE9FE),
                    decoration: InputDecoration(
                      hintText: 'Où étiez-vous ?',
                      hintStyle: TextStyle(color: Color(0xFF656A6E)),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ),
            const SizedBox(height: 4),
            
            // Dropdown Type
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2C343A),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              ),
             child: const Row(
              children: [
                Text('Type :', style: TextStyle(color: Color(0xFF656A6E), fontWeight: FontWeight.w500, fontSize: 16)),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    cursorColor:  Color(0xFF8EE9FE),
                    decoration: InputDecoration(
                      hintText: 'De quoi s\'agit-il ?',
                      hintStyle: TextStyle(color: Color(0xFF656A6E)),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            ),
            const SizedBox(height: 10),
            
            // Date selectors
            const DatePickerRow(),
            const SizedBox(height: 20),
            
            // Bouton de validation de recherche
            ElevatedButton(
              onPressed: () {
                // Action lors du clic sur le bouton
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8EE9FE),
                minimumSize: const Size(double.infinity, 56), // Largeur max du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Valider ma recherche',
                style: TextStyle(
                  color: Color(0xFF0B1320),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Icone de recherche et message
            const Column(
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: Color(0xFF656A6E),
                ),
                SizedBox(height: 16),
                Text(
                  'Commencez par rechercher une gare, \nun type, ou une date',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF656A6E),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
