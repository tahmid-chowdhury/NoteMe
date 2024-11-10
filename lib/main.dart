import 'package:flutter/material.dart';

void main() {
  runApp(NoteMeApp());
}

class Note {
  String title;
  String subtitle;
  String content;
  Color color;

  Note({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.color,
  });
}

class NoteMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteMe',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        fontFamily: 'FiraCode',
        scaffoldBackgroundColor: Colors.black87,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  TextEditingController searchController = TextEditingController();

  void addOrUpdateNote(Note note, [int? index]) {
    setState(() {
      if (index == null) {
        notes.add(note);
      } else {
        notes[index] = note;
      }
    });
  }

  void deleteNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  List<Note> get filteredNotes {
    if (searchController.text.isEmpty) {
      return notes;
    } else {
      return notes
          .where((note) => note.title.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteMe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search notes',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.amberAccent),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (text) => setState(() {}),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredNotes.isEmpty
                  ? Center(child: Text('No notes available', style: TextStyle(color: Colors.white70)))
                  : ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNoteScreen(
                                  note: note,
                                  onSave: (updatedNote) => addOrUpdateNote(updatedNote, index),
                                  onDelete: () => deleteNoteAt(index),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: note.color.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                if (note.subtitle.isNotEmpty) ...[
                                  SizedBox(height: 8),
                                  Text(note.subtitle, style: TextStyle(fontSize: 14, color: Colors.white70)),
                                ],
                                if (note.content.isNotEmpty) ...[
                                  SizedBox(height: 8),
                                  Text(note.content, style: TextStyle(fontSize: 14, color: Colors.white)),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewNoteScreen(onSave: addOrUpdateNote),
            ),
          );
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.amber[600],
        foregroundColor: Colors.black,
        elevation: 6,
      ),
    );
  }
}

class NewNoteScreen extends StatefulWidget {
  final Function(Note) onSave;

  NewNoteScreen({required this.onSave});

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Color selectedColor = Colors.amber[100]!;

  void saveNote() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title is required to save the note')),
      );
      return;
    }

    final newNote = Note(
      title: titleController.text,
      subtitle: subtitleController.text,
      content: contentController.text,
      color: selectedColor,
    );
    widget.onSave(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note', style: TextStyle(color: Colors.amberAccent)),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Subtitle',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorOption(Colors.pink[200]!),
                _colorOption(Colors.blue[200]!),
                _colorOption(Colors.amber[200]!),
                _colorOption(Colors.green[200]!),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: saveNote,
              icon: Icon(Icons.done, color: Colors.black),
              label: Text('Done', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: selectedColor == color ? 25 : 20,
        child: selectedColor == color ? Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}

class EditNoteScreen extends StatefulWidget {
  final Note note;
  final Function(Note) onSave;
  final VoidCallback onDelete;

  EditNoteScreen({required this.note, required this.onSave, required this.onDelete});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController contentController;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    subtitleController = TextEditingController(text: widget.note.subtitle);
    contentController = TextEditingController(text: widget.note.content);
    selectedColor = widget.note.color;
  }

  void saveChanges() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title is required to save the note')),
      );
      return;
    }

    widget.onSave(
      Note(
        title: titleController.text,
        subtitle: subtitleController.text,
        content: contentController.text,
        color: selectedColor,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note', style: TextStyle(color: Colors.amberAccent)),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: subtitleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Subtitle',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type your note here...',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorOption(Colors.pink[200]!),
                _colorOption(Colors.blue[200]!),
                _colorOption(Colors.amber[200]!),
                _colorOption(Colors.green[200]!),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: saveChanges,
              icon: Icon(Icons.done, color: Colors.black),
              label: Text('Save Changes', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                elevation: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: selectedColor == color ? 25 : 20,
        child: selectedColor == color ? Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
