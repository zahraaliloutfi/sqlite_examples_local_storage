import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite/shared_preferance.dart';
import 'package:sqlite/signup_sqlite.dart';
import 'package:sqlite/sqlite.dart';
import 'f_notes_app.dart';

import 'cart_ecommerce.dart';
import 'e_commerce_app.dart';
import 'flutter_secure_storage.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FNotesList(),
    );
  }
}
