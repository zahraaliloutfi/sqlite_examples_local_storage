// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// class SecureStorageNotesList extends StatefulWidget {
//   @override
//   _SecureStorageNotesListState createState() => _SecureStorageNotesListState();
// }

// class _SecureStorageNotesListState extends State<SecureStorageNotesList> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   final _notes = <Note>[];

//   final _storage = FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     _loadNotes();
//   }

//   Future<void> _loadNotes() async {
//     final notesString = await _storage.read(key: 'notes');

//     if (notesString != null) {
//       setState(() {
//         final notesList = notesString.split('|');
//         _notes.clear();
//         _notes.addAll(notesList.map((note) => Note.fromCsv(note)));
//       });
//     }
//   }

//   Future<void> _saveNotes() async {
//     final notesString = _notes.map((note) => note.toCsv()).join('|');
//     await _storage.write(key: 'notes', value: notesString);
//   }

//   Future<void> _insertNote() async {
//     final title = _titleController.text;
//     final content = _contentController.text;

//     setState(() {
//       _notes.add(Note(title: title, content: content));
//     });

//     _titleController.clear();
//     _contentController.clear();

//     _saveNotes();
//   }

//   Future<void> _deleteNote(int index) async {
//     setState(() {
//       _notes.removeAt(index);
//     });

//     _saveNotes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes App FlutterSecureStorage'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: InputDecoration(labelText: 'Title'),
//                 ),
//                 TextField(
//                   controller: _contentController,
//                   decoration: InputDecoration(labelText: 'Content'),
//                 ),
//                 ElevatedButton(
//                   onPressed: _insertNote,
//                   child: Text('Add Note'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _notes.length,
//               itemBuilder: (context, index) {
//                 final note = _notes[index];
//                 return ListTile(
//                   title: Text(note.title),
//                   subtitle: Text(note.content),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () => _deleteNote(index),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Note {
//   final String title;
//   final String content;

//   Note({
//     required this.title,
//     required this.content,
//   });

//   String toCsv() {
//     return '$title,$content';
//   }

//   factory Note.fromCsv(String csv) {
//     final parts = csv.split(',');
//     if (parts.length != 2) {
//       throw FormatException('Invalid CSV format: $csv');
//     }

//     return Note(title: parts[0], content: parts[1]);
//   }
// }
