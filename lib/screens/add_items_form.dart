import 'package:favorite_places/data/providers/places_provider.dart';
import 'package:favorite_places/widgets/form_input_location.dart';
import 'package:favorite_places/widgets/form_input_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddItemsForm extends ConsumerStatefulWidget {
  const AddItemsForm({super.key});
  @override
  ConsumerState<AddItemsForm> createState() => _AddItemsForm();
}

class _AddItemsForm extends ConsumerState<AddItemsForm> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  File? pickedImage;
  String? userAddress;
  var _userPlaces = '';

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }

  void _submitForm() {
    if (pickedImage == null) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(placeProvider.notifier)
          .addToList(
            placesText: _userPlaces.trim(),
            pickedImage: pickedImage!,
            userAdress: userAddress!,
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une place"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(label: const Text('Lieu à enregistrer')),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Erreur de saisie champs vide ou incomplets';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _userPlaces = newValue.toString();
                  },
                ),
                SizedBox(height: 20),
                FormInputPhoto(
                  onImagePicked: (value) => setState(() {
                    pickedImage = value;
                  }),
                ),
                FormInputLocation(
                  userAddressActif: (value) {
                    setState(() {
                      userAddress = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: _submitForm, child: const Text('Ajouter un lieu')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
