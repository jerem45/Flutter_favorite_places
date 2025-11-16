import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class FormInputLocation extends ConsumerStatefulWidget {
  const FormInputLocation({super.key, required this.userAddressActif});
  final ValueChanged<String?> userAddressActif;
  @override
  ConsumerState<FormInputLocation> createState() => _FormInputLocation();
}

class _FormInputLocation extends ConsumerState<FormInputLocation> {
  bool isLoadingLocation = false;
  String? userAddress;

  Future<void> currentLocation() async {
    final location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    setState(() => isLoadingLocation = true);

    final locationData = await location.getLocation();

    // 🔹 Sécurise la récupération (latitude / longitude peuvent être null)
    final lat = locationData.latitude;
    final long = locationData.longitude;
    if (lat == null || long == null) {
      setState(() => isLoadingLocation = false);
      return;
    }

    // 🔹 Conversion en adresse lisible
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    final place = placemarks.first;

    final address =
        '${place.street ?? ''}, ${place.postalCode ?? ''} ${place.locality ?? ''}, ${place.country ?? ''}';

    setState(() {
      userAddress = address.trim();
      isLoadingLocation = false;
      widget.userAddressActif(userAddress);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget defaultCurrentLocationContent = userAddress == null
        ? Text(
            'Aucune localisation...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
          )
        : Text(
            userAddress!,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
          );
    if (isLoadingLocation) {
      defaultCurrentLocationContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          margin: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary),
          ),
          child: defaultCurrentLocationContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: currentLocation,
              label: const Text('Localisation actuel'),
              icon: Icon(Icons.location_on),
            ),
          ],
        ),
      ],
    );
  }
}
