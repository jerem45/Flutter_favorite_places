import 'package:favorite_places/models/places_model.dart';
import 'package:favorite_places/screens/add_items_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/data/providers/places_provider.dart';
import 'package:favorite_places/screens/item_details_screen.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});
  @override
  ConsumerState<ListScreen> createState() => _ListScreen();
}

class _ListScreen extends ConsumerState<ListScreen> {
  void _navToListScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddItemsForm()));
  }

  void _removeItem(PlacesModel index) {
    ref.read(placeProvider.notifier).removeToList(index);
  }

  @override
  Widget build(BuildContext context) {
    final displayList = ref.watch(placeProvider);
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(100),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.pexels.com/photos/356079/pexels-photo-356079.jpeg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 50),
          Text(
            "Aucun éléments a été ajouté a votre liste...",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );

    if (displayList.isNotEmpty) {
      content = ListView.builder(
        itemCount: displayList.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              key: ValueKey(displayList[index]),
              onDismissed: (direction) => _removeItem(displayList[index]),
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ItemDetailsScreen(place: displayList[index])),
                ),
                leading: CircleAvatar(backgroundImage: FileImage(displayList[index].image)),
                title: Text(
                  displayList[index].placesText,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos places"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _navToListScreen();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
