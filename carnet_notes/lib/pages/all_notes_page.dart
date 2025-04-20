import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';
import 'note_view_page.dart';

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({super.key});

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  String _searchQuery = '';
  NoteSortOption _sortOption = NoteSortOption.dateDesc;
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final filteredNotes = _filterAndSortNotes(notesProvider.notes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les notes'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView ? 'Vue liste' : 'Vue grille',
          ),
          PopupMenuButton<NoteSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) => setState(() => _sortOption = option),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: NoteSortOption.dateDesc,
                child: Text('Plus récentes'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.dateAsc,
                child: Text('Plus anciennes'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.titleAsc,
                child: Text('Titre (A-Z)'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.titleDesc,
                child: Text('Titre (Z-A)'),
              ),
              const PopupMenuItem(
                value: NoteSortOption.favoritesFirst,
                child: Text('Favoris d\'abord'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: _isGridView
                ? _buildNotesGrid(filteredNotes)
                : _buildNotesList(filteredNotes),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _buildNoteItem(note);
      },
    );
  }

  Widget _buildNotesGrid(List<Note> notes) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _buildNoteGridItem(note);
      },
    );
  }

  Widget _buildNoteItem(Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => _openNote(note),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (note.isFavorite)
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatDate(note.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _getNotePreview(note.content),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: note.tags
                      .map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.grey[200],
                    labelStyle: const TextStyle(fontSize: 10),
                  ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteGridItem(Note note) {
    return Card(
      child: InkWell(
        onTap: () => _openNote(note),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (note.isFavorite)
                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                  Text(
                    _formatDate(note.updatedAt),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                note.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  _getNotePreview(note.content),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotePreview(dynamic content) {
    try {
      final delta = Delta.fromJson(content);
      return delta.map((op) => op.isInsert ? op.value.toString() : '').join();
    } catch (e) {
      return content.toString();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<Note> _filterAndSortNotes(List<Note> notes) {
    // Filtrage
    var filtered = notes.where((note) {
      final content = _getNotePreview(note.content).toLowerCase();
      return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          content.contains(_searchQuery.toLowerCase());
    }).toList();

    // Tri
    filtered.sort((a, b) {
      switch (_sortOption) {
        case NoteSortOption.dateAsc:
          return a.updatedAt.compareTo(b.updatedAt);
        case NoteSortOption.dateDesc:
          return b.updatedAt.compareTo(a.updatedAt);
        case NoteSortOption.titleAsc:
          return a.title.compareTo(b.title);
        case NoteSortOption.titleDesc:
          return b.title.compareTo(a.title);
        case NoteSortOption.favoritesFirst:
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return b.updatedAt.compareTo(a.updatedAt);
      }
    });

    return filtered;
  }

  void _openNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteViewPage(note: note),
      ),
    );
  }
}

enum NoteSortOption {
  dateDesc,
  dateAsc,
  titleAsc,
  titleDesc,
  favoritesFirst,
}