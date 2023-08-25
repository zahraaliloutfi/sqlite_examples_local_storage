import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FNotesList extends StatefulWidget {
  @override
  _FNotesListState createState() => _FNotesListState();
}

class _FNotesListState extends State<FNotesList> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late Database _database;
  final _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Notes (
          id INTEGER PRIMARY KEY,
          title TEXT,
          content TEXT
        )
      ''');
    });

    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    final notes = await _database.query('Notes');
    setState(() {
      _notes.clear();
      _notes.addAll(notes.map((note) => Note.fromMap(note)));
    });
  }

  Future<void> _insertNote() async {
    await _database.insert('Notes', {
      'title': _titleController.text,
      'content': _contentController.text,
    });
    _titleController.clear();
    _contentController.clear();
    _refreshNotes();
  }

  Future<void> _deleteNote(int id) async {
    await _database.delete('Notes', where: 'id = ?', whereArgs: [id]);
    _refreshNotes();
  }

  Future<void> _showAddNoteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _insertNote();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _showAddNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     _showAddNoteDialog(context);
                //   },
                //   child: Icon(Icons.add),
                // ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(note.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Note {
  final int? id;
  final String title;
  final String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
