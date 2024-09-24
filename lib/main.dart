/// The main entry point for the application.
///
/// This function initializes the Flutter binding, sets the preferred orientation to portrait, and runs the [MyApp] widget.
library;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/enums/SortOrder.dart';
import 'package:myapp/providers/StationProvider.dart';
import 'package:myapp/models/FoundObject.dart';
import 'package:myapp/widgets/object_tile.dart';
import 'widgets/search_button.dart';
import 'search.dart';
import 'package:provider/provider.dart';
import 'providers/ObjectsProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force l'orientation en mode portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => StationProvider()),
                ChangeNotifierProvider(create: (_) => ObjectsProvider()),
              ],
              child: const MyApp(),
            ),
          ));
}


/// The root widget of the application.
///
/// This widget sets the theme and localization delegates for the application, and specifies the home page as the [HomePage] widget.
class MyApp extends StatelessWidget {
  /// Constructs a new instance of the [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNCF FoundIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: const Color(0xFF8EE9FE).withOpacity(0.5), // Couleur de la sélection
          cursorColor: const Color(0xFF8EE9FE), // Couleur du curseur
          selectionHandleColor: const Color(0xFF8EE9FE), // Couleur des poignées de sélection
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
      ],
    );
  }
}

/// The home page of the application.
///
/// This widget displays the last found objects since the last visit, and provides a search button that navigates to the [SearchPage] widget.
class HomePage extends StatefulWidget {
  /// Constructs a new instance of the [HomePage] widget.
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The date of the last visit.
  DateTime lastVisit = DateTime.now().subtract(const Duration(days: 30)); // Par défaut, la dernière visite est la date actuelle moins 1 mois

  /// Initializes the state of the [HomePage] widget.
  ///
  /// This method loads the last visit date, fetches search results, and saves the current visit date.
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initialise the HomePage.
  Future<void> _initialize() async {
    await _loadLastVisit();
    final objects = await _fetchSearchResults(lastVisit);
    Provider.of<ObjectsProvider>(context, listen: false).setObjects(objects);
    await _saveLastVisit();
  }

  /// Loads the last visit date from shared preferences.
  ///
  /// If no last visit date is found, the default value is used.
  Future<void> _loadLastVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final lastVisitString = prefs.getString('lastVisit');
    if (lastVisitString != null && lastVisitString != '') {
      setState(() {
        lastVisit = DateTime.parse(lastVisitString);
      });
    }
  }

  /// Saves the current visit date to shared preferences.
  ///
  /// This method is called every time the home page is displayed.
  Future<void> _saveLastVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString('lastVisit', now.toIso8601String());
  }

  /// Fetches search results from the API.
  Future<List<FoundObject>> _fetchSearchResults(DateTime? lastVisit) async {
    return await Provider.of<ObjectsProvider>(context, listen: false)
        .fetchObjectsWithFilters(startDate: lastVisit, sortOrder: SortOrder.asc);
  }

  /// Builds the [HomePage] widget.
  ///
  /// This method returns a [Scaffold] widget that contains the home page content.
  @override
  Widget build(BuildContext context) {
    final objectsProvider = Provider.of<ObjectsProvider>(context);
    final List<FoundObject> objects = objectsProvider.objects;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1320), // Couleur de fond
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bonjour 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // Titre principal
              const Text(
                'Retrouvez vos objets perdus selon la date, la gare, le type de l\'objet...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Barre de recherche
              SearchButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Section "Les derniers trouvés"
              const Text(
                'Les derniers trouvés',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Depuis le ${lastVisit.day.toString().padLeft(2, '0')}/${lastVisit.month.toString().padLeft(2, '0')}/${lastVisit.year} à ${lastVisit.hour.toString().padLeft(2, '0')}h${lastVisit.minute.toString().padLeft(2, '0')}',
              style:
                const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              // Liste des objets trouvés
              Expanded(
                child: objects.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              size: 64,
                              color: Color(0xFF656A6E),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun objet n\'a été trouvé depuis la dernière visite.',
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
                      )
                    : ListView.builder(
                        itemCount: objects.length,
                        itemBuilder: (context, index) {
                          final object = objects[index];
                          return ObjectTile(nature: object.nature, type: object.type, station: object.station_name, date: object.date);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}