// import 'package:flutter/material.dart';
// import 'package:sqlite/sqlite.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   SQLDB sqlDb = SQLDB();

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
//               int responseInsert = await sqlDb
//                   .insertData('INSERT INTO notes(note) VALUES("note one")');
//               print(responseInsert);
//             },
//             child: Text('insert'),
//           ),
//           TextButton(
//             onPressed: () async {
//               List<Map> responseRead =
//                   await sqlDb.readData("SELECT * FROM 'notes'");
//               print(responseRead);
//             },
//             child: Text('read'),
//           ),
//         ]),
//       ),
//     );
//   }
// }
