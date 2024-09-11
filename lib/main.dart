import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/search_button.dart';
import 'search.dart';
import 'package:provider/provider.dart';
import 'providers/ObjectProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(
        ChangeNotifierProvider(
          create: (context) => ObjectsProvider(),
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
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
       supportedLocales: const [
         Locale('fr'),
       ],
    );
  }
}

class HomePage extends StatelessWidget {
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
              const SizedBox(height: 16),

              // GridView des objets trouvés
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // Responsive columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: objects.length,
                  itemBuilder: (context, index) {
                    final object = objects[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1C2536),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(object.nature),
                          Text(object.station_name),
                          Text(object.date.toString()),
                        ],
                      ),
                    );
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
