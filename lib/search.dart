import 'package:flutter/material.dart';
import 'package:myapp/providers/ObjectsProvider.dart';
import 'package:provider/provider.dart';
import 'models/FoundObject.dart';
import 'widgets/date_picker_row.dart';
import 'providers/StationProvider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _gareController = TextEditingController();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _gareFocusNode = FocusNode();
  List<String> _typeResults = [];
  List<String> _gareResults = [];
  final List<String> _allTypes = [
    "Appareils électroniques, informatiques, appareils photo",
    "Articles d'enfants, de puériculture",
    "Articles de sport, loisirs, camping",
    "Articles médicaux",
    "Bagagerie: sacs, valises, cartables",
    "Bijoux, montres",
    "Clés, porte-clés, badge magnétique",
    "Divers",
    "Instruments de musique",
    "Livres, articles de papéterie",
    "Optique",
    "Parapluies",
    "Pièces d'identités et papiers personnels",
    "Porte-monnaie / portefeuille, argent, titres",
    "Vélos, trottinettes, accessoires 2 roues",
    "Vêtements, chaussures"
  ];

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

  DateTime? _startDate;
  DateTime? _endDate;
  List<FoundObject> _searchResults = [];
  bool _hasSearchResults = false;

  @override
  void initState() {
    super.initState();
    final stationProvider = Provider.of<StationProvider>(context, listen: false);
    stationProvider.fetchObjects();
    _typeController.addListener(_onTypeChanged);
    _gareController.addListener(_onGareChanged);
    _typeFocusNode.addListener(_onTypeFocusChanged);
    _gareFocusNode.addListener(_onGareFocusChanged);
    _typeFocusNode.addListener(_onFocusChanged);
    _gareFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _typeController.removeListener(_onTypeChanged);
    _gareController.removeListener(_onGareChanged);
    _typeFocusNode.removeListener(_onTypeFocusChanged);
    _gareFocusNode.removeListener(_onGareFocusChanged);
    _typeFocusNode.removeListener(_onFocusChanged);
    _gareFocusNode.removeListener(_onFocusChanged);
    _typeController.dispose();
    _gareController.dispose();
    _typeFocusNode.dispose();
    _gareFocusNode.dispose();
    super.dispose();
  }

  void _onTypeChanged() {
    setState(() {
      _typeResults = _allTypes
          .where((type) =>
              type.toLowerCase().contains(_typeController.text.toLowerCase()))
          .toList();
    });
  }

  void _onGareChanged() {
    final stationProvider = Provider.of<StationProvider>(context, listen: false);
    final stations = stationProvider.getStationNames();
    setState(() {
      _gareResults = stations
          .where((gare) => gare.toLowerCase().contains(_gareController.text.toLowerCase()))
          .toList();
    });
  }

  void _onTypeFocusChanged() {
    if (!_typeFocusNode.hasFocus) {
      setState(() {
        _typeResults.clear();
      });
    }
  }

  void _onGareFocusChanged() {
    if (!_gareFocusNode.hasFocus) {
      setState(() {
        _gareResults.clear();
      });
    }
  }

  void _onFocusChanged() {
    if (_typeFocusNode.hasFocus || _gareFocusNode.hasFocus) {
      setState(() {
        _searchResults.clear();
        _hasSearchResults = false;
      });
    }
  }

  void _onTypeSelected(String type) {
    setState(() {
      _typeController.text = type;
      _typeResults.clear();
    });
  }

  void _onGareSelected(String gare) {
    setState(() {
      _gareController.text = gare;
      _gareResults.clear();
    });
  }

  void _onStartDateChanged(DateTime? date) {
    setState(() {
      _startDate = date;
    });
  }

  void _onEndDateChanged(DateTime? date) {
    setState(() {
      _endDate = date;
    });
  }

  void _unfocusAll() {
    _typeFocusNode.unfocus();
    _gareFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1320), // Couleur de fond
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFF3F3F3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF0B1320), size: 20),
                      onPressed: () {
                        Navigator.pop(
                            context); // Retourner à la page précédente
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    const Text('Gare :',
                        style: TextStyle(
                            color: Color(0xFF656A6E),
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _gareController,
                        focusNode: _gareFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Où étiez-vous ?',
                          hintStyle: TextStyle(color: Color(0xFF656A6E)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
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
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    const Text('Type :',
                        style: TextStyle(
                            color: Color(0xFF656A6E),
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _typeController,
                        focusNode: _typeFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'De quoi s\'agit-il ?',
                          hintStyle: TextStyle(color: Color(0xFF656A6E)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Date selectors
              DatePickerRow(
                onStartDateChanged: _onStartDateChanged,
                onEndDateChanged: _onEndDateChanged,
              ),
              const SizedBox(height: 20),

              // Bouton de validation de recherche
              ElevatedButton(
                onPressed: () async {
                  _unfocusAll(); // Défocus les champs de texte

                  Map<String, dynamic> filters = {
                    if (_gareController.text.isNotEmpty) 'station_name': _gareController.text,
                    if (_typeController.text.isNotEmpty) 'type': _typeController.text,
                    if (_startDate != null) 'date_min': _startDate,
                    if (_endDate != null) 'date_max': _endDate,
                  };
                  List<FoundObject> objects = await Provider.of<ObjectsProvider>(context, listen: false).fetchObjectsWithFilters(
                    stationName: filters['station_name'],
                    typeObject: filters['type'],
                    startDate: filters['date_min'],
                    endDate: filters['date_max'],
                  );
                  Provider.of<ObjectsProvider>(context, listen: false).setObjects(objects);
                  setState(() {
                    _searchResults = objects;
                    _hasSearchResults = true; // Mettre à jour la variable pour indiquer que des résultats sont disponibles
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EE9FE),
                  minimumSize:
                      const Size(double.infinity, 50), // Largeur max du bouton
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

              // Display search results
              if (_hasSearchResults)
                Expanded(
                  child: _searchResults.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final object = _searchResults[index];
                            return Card(
                              color: const Color(0xFF2C343A),
                              child: ListTile(
                                leading: Icon(
                                  _typeIcons[object.type] ?? Icons.help, // Utilisez l'icône appropriée ou une icône par défaut
                                  color: Colors.white, // Couleur de l'icône
                                ),
                                title: Text(
                                  object.nature,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      object.type,
                                      style: const TextStyle(color: Colors.blueGrey),
                                    ),
                                    Text(
                                      '${object.station_name} - ${object.date.day.toString().padLeft(2, '0')}/${object.date.month.toString().padLeft(2, '0')}/${object.date.year} à ${object.date.hour.toString().padLeft(2, '0')}:${object.date.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Column(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: 64,
                      color: Color(0xFF656A6E),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nous n\'avons pas trouvé d\'objet \ncorrespondant à votre recherche',
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
                ),

              // Afficher les résultats de la recherche ou le message par défaut
              if (_typeResults.isNotEmpty && _typeFocusNode.hasFocus)
                Expanded(
                  child: ListView.builder(
                    itemCount: _typeResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onTypeSelected(_typeResults[index]),
                        child: ListTile(
                          leading: Icon(
                            _typeIcons[_typeResults[index]] ?? Icons.help, // Utilisez l'icône appropriée ou une icône par défaut
                            color: Colors.white, // Couleur de l'icône
                          ),
                          title: Text(
                            _typeResults[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_gareResults.isNotEmpty && _gareFocusNode.hasFocus)
                Expanded(
                  child: ListView.builder(
                    itemCount: _gareResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onGareSelected(_gareResults[index]),
                        child: ListTile(
                          leading: Icon(
                            Icons.train, // Utilisez l'icône de gare appropriée
                            color: Colors.white, // Couleur de l'icône
                          ),
                          title: Text(
                            _gareResults[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_typeResults.isEmpty && _gareResults.isEmpty && !_hasSearchResults)
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
