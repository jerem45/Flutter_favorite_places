import 'package:favorite_places/models/places_model.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = Uuid();

class PlaceNotifier extends StateNotifier<List<PlacesModel>> {
  PlaceNotifier() : super([]) {
    _loadFromBox();
  }

  final _box = Hive.box('place');

  void _loadFromBox() {
    final values = _box.values.toList().cast<Map>();
    state = values.map((data) => PlacesModel.fromMap(Map<String, dynamic>.from(data))).toList();
  }

  // Future<void> addToList() async {
  //   // state = [...state, data];
  // }

  Future<void> addToList({
    required String placesText,
    required File pickedImage,
    required String userAdress,
  }) async {
    // sauvegarde de l'image dans un dossier de l'app
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedImage.path);
    pickedImage.copy('${appDir.path}/$fileName');

    final place = PlacesModel(
      placesText: placesText,
      imagePath: pickedImage.path,
      userAdress: userAdress,
      id: uuid.v4(),
    );

    await _box.add(place.toMap());
    state = [...state, place];
  }

  // removeToList(PlacesModel index) {
  //   state = state.where((d) => d.id != index.id).toList();
  // }
  Future<void> removeToList(PlacesModel place) async {
    final keyToDelete = _box.keys.firstWhere((k) {
      final m = Map<String, dynamic>.from(_box.get(k));
      return m['id'] == place.id;
    }, orElse: () => null);
    if (keyToDelete != null) {
      await _box.delete(keyToDelete);
    }
    state = state.where((d) => d.id != place.id).toList();

    try {
      final f = File(place.imagePath);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // On ignore l'erreur (fichier déjà effacé, permission, etc.)
    }
  }
}

final placeProvider = StateNotifierProvider<PlaceNotifier, List<PlacesModel>>(
  (ref) => PlaceNotifier(),
);
