/// A widget that allows users to search for lost objects.
///
/// This widget provides text fields for entering the station name and object type, as well as date pickers for selecting the start and end dates.
/// It uses the [ObjectsProvider] and [StationProvider] classes to fetch objects and stations, respectively.
/// It also uses the [ObjectTile] widget to display search results.
library;
import 'package:flutter/material.dart';
import 'package:myapp/enums/SortOrder.dart';
import 'package:myapp/providers/ObjectsProvider.dart';
import 'package:myapp/widgets/object_tile.dart';
import 'package:provider/provider.dart';
import 'models/FoundObject.dart';
import 'widgets/date_picker_row.dart';
import 'providers/StationProvider.dart';

class SearchPage extends StatefulWidget {
  /// Constructs a new instance of the [SearchPage] widget.
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _gareController = TextEditingController();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _gareFocusNode = FocusNode();
  List<String> _typeResults = [];
  List<String> _gareResults = [];

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

  /// Initializes the state of the [SearchPage] widget.
  ///
  /// This method fetches stations from the [StationProvider] and adds listeners to the text fields and focus nodes.
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

  /// Disposes of the state of the [SearchPage] widget.
  ///
  /// This method removes listeners from the text fields and focus nodes and disposes of them.
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

  /// Updates the list of object types based on the text entered in the object type text field.
  void _onTypeChanged() {
    setState(() {
      _typeResults = _typeIcons.keys
          .where((type) => type.toLowerCase().contains(_typeController.text.toLowerCase()))
          .toList();
    });
  }

  /// Updates the list of stations based on the text entered in the station text field.
  void _onGareChanged() {
    final stationProvider = Provider.of<StationProvider>(context, listen: false);
    final stations = stationProvider.getStationNames();
    setState(() {
      _gareResults = stations
          .where((gare) => gare.toLowerCase().contains(_gareController.text.toLowerCase()))
          .toList();
    });
  }

  /// Clears the list of stations when the station text field loses focus.
  void _onGareFocusChanged() {
    if (!_typeFocusNode.hasFocus) {
      setState(() {
        _typeResults.clear();
      });
    }
  }

  /// Clears the list of search results when either the object type or station text field gains focus.
  void _onFocusChanged() {
    if (!_gareFocusNode.hasFocus) {
      setState(() {
        _gareResults.clear();
      });
    }
  }

  /// Clears the list of object types when the object type text field loses focus.
  void _onTypeFocusChanged() {
    if (_typeFocusNode.hasFocus || _gareFocusNode.hasFocus) {
      setState(() {
        _searchResults.clear();
        _hasSearchResults = false;
      });
    }
  }

  /// Updates the object type text field with the selected object type and clears the list of object types.
  void _onTypeSelected(String type) {
    setState(() {
      _typeController.text = type;
      _typeResults.clear();
    });
  }

  /// Updates the station text field with the selected station and clears the list of stations.
  void _onGareSelected(String gare) {
    setState(() {
      _gareController.text = gare;
      _gareResults.clear();
    });
  }

  /// Updates the start date based on the selected date in the start date picker.
  void _onStartDateChanged(DateTime? date) {
    setState(() {
      _startDate = date;
    });
  }

  /// Updates the end date based on the selected date in the end date picker.
  void _onEndDateChanged(DateTime? date) {
    setState(() {
      _endDate = date;
    });
  }

  /// Unfocuses both the object type and station text fields.
  void _unfocusAll() {
    _typeFocusNode.unfocus();
    _gareFocusNode.unfocus();
  }

  /// Builds the [SearchPage] widget.
  ///
  /// This method returns a [Scaffold] widget that contains the search form and the search results.
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
                    sortOrder: SortOrder.desc,
                  );
                  // ignore: use_build_context_synchronously
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
                            return ObjectTile(nature: object.nature, type: object.type, station: object.station_name, date: object.date);
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
                          leading: const Icon(
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