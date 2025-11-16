import 'package:uuid/uuid.dart';
import 'dart:io';

var uuid = Uuid();

class PlacesModel {
  final String id;
  final String placesText;
  final String imagePath;
  final String userAdress;
  PlacesModel({
    required this.placesText,
    required this.imagePath,
    required this.userAdress,
    required this.id,
  });

  File get image => File(imagePath);

  Map<String, dynamic> toMap() => {
    //sauvegarder sous un format lisible
    'id': id,
    'placesText': placesText,
    'imagePath': imagePath,
    'userAdress': userAdress,
  };

  factory PlacesModel.fromMap(Map<String, dynamic> m) => PlacesModel(
    //pour recharger
    placesText: m['placesText'] as String,
    imagePath: m['imagePath'] as String,
    userAdress: m['userAdress'] as String,
    id: m['id'] as String,
  );
}
