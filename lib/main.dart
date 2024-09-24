import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => StationProvider()),
                ChangeNotifierProvider(create: (_) => ObjectsProvider()),
              ],
              child: MyApp(),
            ),
          ));
}

class MyApp extends StatelessWidget {
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
      home: HomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  DateTime lastVisit = DateTime.now().subtract(const Duration(days: 30)); // Par défaut, la dernière visite est la date actuelle moins 1 mois

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadLastVisit();
    final objects = await _fetchSearchResults(lastVisit);
    Provider.of<ObjectsProvider>(context, listen: false).setObjects(objects);
    await _saveLastVisit();
  }

  Future<void> _loadLastVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final lastVisitString = prefs.getString('lastVisit');
    if (lastVisitString != null) {
      setState(() {
        lastVisit = DateTime.parse(lastVisitString);
      });
    }
  }

  Future<void> _saveLastVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setString('lastVisit', now.toIso8601String());
    setState(() {
      lastVisit = now;
    });
  }

  Future<List<FoundObject>> _fetchSearchResults(DateTime? lastVisit) async {
    final objects = await Provider.of<ObjectsProvider>(context, listen: false)
        .fetchObjectsWithFilters(startDate: lastVisit);

    objects.sort((a, b) => a.date.compareTo(b.date));

    return objects;
  }

  @override
  Widget build(BuildContext context) {
    final objectsProvider = Provider.of<ObjectsProvider>(context);
    final List<FoundObject> objects = objectsProvider.objects;

    return Scaffold(
      backgroundColor: Color(0xFF0B1320), // Couleur de fond
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
                      builder: (context) => SearchPage(),
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
              Text('Depuis le ${lastVisit?.day.toString().padLeft(2, '0')}/${lastVisit?.month.toString().padLeft(2, '0')}/${lastVisit?.year}',
              style:
                const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              // GridView des objets trouvés
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
