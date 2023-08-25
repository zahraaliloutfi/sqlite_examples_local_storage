import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SharedNotesList extends StatefulWidget {
  @override
  _SharedNotesListState createState() => _SharedNotesListState();
}

class _SharedNotesListState extends State<SharedNotesList> {
  // Controllers for the title and content input fields.
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // List to store notes.
  final _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    // Load notes when the app starts.
    _loadNotes();
  }

  // Load notes from SharedPreferences.
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesList = prefs.getStringList('notes') ?? [];

    setState(() {
      // Clear the existing notes list and add the loaded notes.
      _notes.clear();
      _notes.addAll(notesList.map((note) => Note.fromCsv(note)));
    });
  }

  // Save notes to SharedPreferences.
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesList = _notes.map((note) => note.toCsv()).toList();

    await prefs.setStringList('notes', notesList);
  }

  // Insert a new note.
  Future<void> _insertNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    setState(() {
      // Add the new note to the list of notes.
      _notes.add(Note(title: title, content: content));
    });

    // Clear input fields.
    _titleController.clear();
    _contentController.clear();

    // Save the updated list of notes.
    _saveNotes();
  }

  // Delete a note by index.
  Future<void> _deleteNote(int index) async {
    setState(() {
      // Remove the note at the specified index.
      _notes.removeAt(index);
    });

    // Save the updated list of notes.
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App SharedPreferences'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input fields for note title and content.
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                ),
                // Button to add a new note.
                ElevatedButton(
                  onPressed: _insertNote,
                  child: Text('Add Note'),
                ),
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
                    // Button to delete a note.
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
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
  final String title;
  final String content;

  Note({
    required this.title,
    required this.content,
  });

  // Convert a note to a CSV format string.
  String toCsv() {
    return '$title,$content';
  }

  // Create a Note object from a CSV format string.
  factory Note.fromCsv(String csv) {
    final parts = csv.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid CSV format: $csv');
    }

    return Note(title: parts[0], content: parts[1]);
  }
}
