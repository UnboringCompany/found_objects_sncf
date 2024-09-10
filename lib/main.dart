import 'package:flutter/material.dart';
import 'package:myapp/widgets/FoundObject.dart';
import 'package:provider/provider.dart';
import 'providers/ObjectProvider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ObjectsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Found Objects')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Map<String, String> filters = {
                    'station_name': 'Montparnasse',
                    'date_min': '2024-09-05T00:00:00Z',
                    'date_max': '2024-09-09T23:59:59Z',
                  };
                  List<FoundObject> objects = await Provider.of<ObjectsProvider>(context, listen: false).fetchObjectsWithFilters(filters);
                  Provider.of<ObjectsProvider>(context, listen: false).setObjects(objects);
                },

                child: const Text('Fetch and write objects to JSON file'),
              ),
              const SizedBox(height: 16),
              Consumer<ObjectsProvider>(
                builder: (context, provider, child) {
                  if (provider.objects.isEmpty) {
                    return const Text('No objects found');
                  } else {
                    final lastObject = provider.objects.last;
                    final sizeObject = provider.objects.length;
                    return Text('Last object: ${lastObject.nature} - ${lastObject.type}, size_batch: $sizeObject');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
