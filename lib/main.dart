import 'package:favorite_places/screens/list_screen.dart';
import 'package:favorite_places/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('place');
  runApp(
    ProviderScope(
      child: MaterialApp(debugShowCheckedModeBanner: false, theme: theme, home: const ListScreen()),
    ),
  );
}
