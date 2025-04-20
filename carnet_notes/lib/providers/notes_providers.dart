import 'package:flutter/material.dart';

import '../models/note.dart';


class NotesProvider with ChangeNotifier {
  final List<Note> _notes = [];
  final List<String> _categories = ['Non classé', 'Travail', 'Personnel', 'Idées'];

  List<Note> get notes => _notes;
  List<String> get categories => _categories;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  void renameCategory(String oldName, String newName) {
    if (_categories.contains(oldName)) {
      final index = _categories.indexOf(oldName);
      _categories[index] = newName;

      for (var note in _notes.where((n) => n.category == oldName)) {
        note.category = newName;
      }
      notifyListeners();
    }
  }

  void renameTag(String oldTag, String newTag) {
    for (var note in _notes) {
      if (note.tags.contains(oldTag)) {
        note.tags.remove(oldTag);
        if (!note.tags.contains(newTag)) {
          note.tags.add(newTag);
        }
      }
    }
    notifyListeners();
  }

  final List<Note> _deletedNotes = [];

  List<Note> get deletedNotes => _deletedNotes;

  void deleteNote(String id) {
    final note = _notes.firstWhere((n) => n.id == id);
    note.markAsDeleted();
    _deletedNotes.add(note);
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void restoreNote(String id) {
    final note = _deletedNotes.firstWhere((n) => n.id == id);
    note.deletedAt = null;
    _notes.add(note);
    _deletedNotes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void permanentlyDeleteNote(String id) {
    _deletedNotes.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void emptyTrash() {
    _deletedNotes.clear();
    notifyListeners();
  }
}