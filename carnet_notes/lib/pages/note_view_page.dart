import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/notes_providers.dart';
import 'note_editor_page.dart';

class NoteViewPage extends StatelessWidget {
  final Note note;

  const NoteViewPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final quillController = QuillController(
      document: Document.fromJson(note.content),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editNote(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareNote(context),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Exporter en PDF'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Supprimer', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') _deleteNote(context);
              if (value == 'export') _exportToPdf(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec métadonnées
            _buildNoteHeader(context),
            const SizedBox(height: 16),
            // Contenu de la note
            Expanded(
              child: QuillEditor(
                controller: quillController,
                scrollController: ScrollController(),
                scrollable: true,
                padding: EdgeInsets.zero,
                autoFocus: false,
                readOnly: true,
                expands: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (note.isFavorite)
              const Icon(Icons.favorite, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Text(
              note.category,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              _formatDate(note.updatedAt),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (note.tags.isNotEmpty)
          Wrap(
            spacing: 4,
            children: note.tags
                .map((tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.grey[200],
              labelStyle: const TextStyle(fontSize: 12),
            ))
                .toList(),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}h${date.minute.toString().padLeft(2, '0')}';
  }

  void _editNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorPage(note: note),
      ),
    );
  }

  void _shareNote(BuildContext context) {
    final plainText = note.title + '\n\n' + _getPlainTextContent(note.content);
    Share.share(plainText);
  }

  String _getPlainTextContent(dynamic content) {
    try {
      final delta = Delta.fromJson(content);
      return delta.map((op) => op.isInsert ? op.value.toString() : '').join();
    } catch (e) {
      return content.toString();
    }
  }

  void _deleteNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text('Voulez-vous vraiment supprimer cette note ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<NotesProvider>(context, listen: false).deleteNote(note.id);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exportToPdf(BuildContext context) {
    // Implémentation de l'export PDF (nécessite un package supplémentaire)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export PDF en cours de développement...')),
    );
  }
}