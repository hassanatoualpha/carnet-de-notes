import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/notes_service.dart';
import '../models/note.dart';

// Provider pour le service d'authentification
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Provider pour l'état de l'authentification
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Provider pour le service des notes
final notesServiceProvider = Provider<NotesService>((ref) => NotesService());

// Provider pour la liste des notes
final notesProvider = StreamProvider<List<Note>>((ref) {
  return ref.watch(notesServiceProvider).getNotes();
});

// Provider pour les notes favorites
final favoriteNotesProvider = StreamProvider<List<Note>>((ref) {
  return ref.watch(notesServiceProvider).getFavoriteNotes();
});

// Provider pour la recherche de notes
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider<List<Note>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) {
    return ref.watch(notesServiceProvider).getNotes();
  }
  return ref.watch(notesServiceProvider).searchNotes(query);
});

// Provider pour le thème de l'application
final isDarkModeProvider = StateProvider<bool>((ref) => false);