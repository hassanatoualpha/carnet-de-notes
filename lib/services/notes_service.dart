import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      _firestore.collection('users').doc(_userId).collection('notes');

  // Créer une nouvelle note
  Future<void> createNote(Note note) async {
    await _notesCollection.doc(note.id).set(note.toMap());
  }

  // Obtenir toutes les notes
  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Obtenir une note spécifique
  Future<Note?> getNote(String id) async {
    final doc = await _notesCollection.doc(id).get();
    return doc.exists ? Note.fromFirestore(doc) : null;
  }

  // Mettre à jour une note
  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  // Supprimer une note
  Future<void> deleteNote(String id) async {
    await _notesCollection.doc(id).delete();
  }

  // Obtenir les notes favorites
  Stream<List<Note>> getFavoriteNotes() {
    return _notesCollection
        .where('isFavorite', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Rechercher des notes
  Stream<List<Note>> searchNotes(String query) {
    return _notesCollection
        .orderBy('title')
        .startAt([query])
        .endAt([query + '\uf8ff'])
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }

  // Obtenir les notes par tag
  Stream<List<Note>> getNotesByTag(String tag) {
    return _notesCollection
        .where('tags', arrayContains: tag)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList());
  }
}