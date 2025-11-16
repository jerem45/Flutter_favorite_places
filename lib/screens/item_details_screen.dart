import 'package:favorite_places/data/providers/places_provider.dart';
import 'package:favorite_places/models/places_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemDetailsScreen extends ConsumerWidget {
  const ItemDetailsScreen({super.key, required this.place});
  final PlacesModel place;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.placesText),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ref.read(placeProvider.notifier).removeToList(place);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('${place.placesText} à été supprimer ! '),
                ),
              );
              Navigator.of(context).pop();
            },

            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 500,
              child: Image(
                image: FileImage(place.image),
                fit: BoxFit.cover,
                // width: double.infinity,
                // height: double.infinity,
              ),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              place.userAdress,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
