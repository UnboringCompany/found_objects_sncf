import 'package:flutter/material.dart';
import 'package:myapp/widgets/FoundObject.dart';

class SearchResultsPage extends StatelessWidget {
  final List<FoundObject> objects;

  const SearchResultsPage({required this.objects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de la recherche'),
      ),
      body: ListView.builder(
        itemCount: objects.length,
        itemBuilder: (context, index) {
          final object = objects[index];
          return ListTile(
            title: Text(object.nature),
            subtitle: Text(object.station_name),
            trailing: Text(object.date.toString()),
          );
        },
      ),
    );
  }
}
