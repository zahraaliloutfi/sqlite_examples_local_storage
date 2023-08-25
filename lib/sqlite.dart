// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'f_notes_app.dart';

// //insert ,update ,delete ,select.
// class SQLDB extends StatefulWidget {
//   static Database? _db;

//   @override
//   State<SQLDB> createState() => _SQLDBState();
// }

// class _SQLDBState extends State<SQLDB> {
//   final _notes = <Note>[];

//   Future<Database?> get db async {
//     if (SQLDB._db == null) {
//    final  _db = initialDb() as Database?;
//       return SQLDB._db;
//     } else {
//       return SQLDB._db;
//     }
//   }

//   Future<void> _refreshNotes() async {
//     final notes = await SQLDB._db!.query('Notes');
//     setState(() {
//        _notes.clear();
//       _notes.addAll(notes.map((note) => Note.fromMap(note)));
//     });
  
//   }

//   Future<void> initialDb() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'notes.db');

// final    _db = await openDatabase(path, version: 1,
//         onCreate: (Database db, int version) async {
//       await db.execute('''
//         CREATE TABLE Notes (
//           id INTEGER PRIMARY KEY,
//           title TEXT,
//           content TEXT
//         )
//       ''');
//     });

//     _refreshNotes();
//   }

//   _onUpgrade(Database db, int oldVersion, int newVersion) {
//     print('-------------------on upgrade -------------------');
//   }

// //create tables
//   _onCreate(Database db, int version) async {
//     //table 1
//     await db.execute('''
// CREATE TABLE
//  "notes"(
//   "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
//   "note" TEXT NOT NULL,)
// ''');
//     print(
//         '>>>>>>>>>>>>>>>>>>>>>>>> create database >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
// //table 2 and so on
// //     await db.execute('''
// // CREATE TABLE
// //  "notes"(
// //   id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY,
// //   notes TEXT NOT NULL,)
// // ''');
//   }

// //Select
//   readData(String sql) async {
//     //rowQuery method is for select
//     Database? mydb = await db;
//     List<Map> response = await mydb!.rawQuery(sql);
//     print('======================= Select database ======================');
//     return response;
//   }

// //insert
//   insertData(String sql) async {
//     //rowInsert method is for select
//     Database? mydb = await db;
//     int response = await mydb!.rawInsert(sql);
//     print('======================= insert database ======================');
//     return response;
//   }

// //update
//   updateData(String sql) async {
//     //rowQuery method is for select
//     Database? mydb = await db;
//     int response = await mydb!.rawUpdate(sql);
//     print('======================= update database ======================');
//     return response;
//   }

// //delete
//   deleteData(String sql) async {
//     //rowQuery method is for select
//     Database? mydb = await db;
//     int response = await mydb!.rawDelete(sql);
//     print('======================= delete database ======================');
//     return response;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold();
//   }
// }



// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//           TextButton(
//             onPressed: () async {
//               //بيرجع ريسبونس صفر لو العمليه فشلت و رقم لو نجحت و بيرجع برقم الصف ال عملته انسرت ال تم اضافته
//               int responseInsert = await insertData('INSERT INTO notes(note) VALUES("note one")');
//               print(responseInsert);
//             },
//             child: Text('insert'),
//           ),
//           TextButton(
//             onPressed: () async {
//               List<Map> responseRead =
//                   await readData("SELECT * FROM 'notes'");
//               print(responseRead);
//             },
//             child: Text('read'),
//           ),
//         ]),
//       ),
//     );
//   }
// }
