import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../providers/notes_providers.dart';
import 'note_view_page.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({Key? key}) : super(key: key);

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  bool _showEmptyTrashDialog = false;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final deletedNotes = notesProvider.deletedNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Corbeille'),
        actions: [
          if (deletedNotes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => _confirmEmptyTrash(context, notesProvider),
              tooltip: 'Vider la corbeille',
            ),
        ],
      ),
      body: deletedNotes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: deletedNotes.length,
        itemBuilder: (context, index) {
          final note = deletedNotes[index];
          return _buildDeletedNoteItem(note, notesProvider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Corbeille vide',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les notes supprimées apparaîtront ici',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletedNoteItem(Note note, NotesProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[100],
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              icon: Icons.restore,
              backgroundColor: Colors.green,
              label: 'Restaurer',
              onPressed: (_) => provider.restoreNote(note.id),
            ),
            SlidableAction(
              icon: Icons.delete_forever,
              backgroundColor: Colors.red,
              label: 'Supprimer',
              onPressed: (_) => provider.permanentlyDeleteNote(note.id),
            ),
          ],
        ),
        child: ListTile(
          title: Text(note.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getNotePreview(note.content),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Supprimé le ${_dateFormat.format(note.deletedAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          onTap: () => _showDeletedNote(context, note),
        ),
      ),
    );
  }

  String _getNotePreview(dynamic content) {
    try {
      if (content is String) return content;
      final delta = Delta.fromJson(content);
      return delta.map((op) => op.isInsert ? op.value.toString() : '').join();
    } catch (e) {
      return content.toString();
    }
  }

  void _showDeletedNote(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_getNotePreview(note.content)),
              const SizedBox(height: 16),
              Text(
                'Créé le: ${_dateFormat.format(note.createdAt)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Modifié le: ${_dateFormat.format(note.updatedAt)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Supprimé le: ${_dateFormat.format(note.deletedAt!)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmEmptyTrash(BuildContext context, NotesProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider la corbeille'),
        content: const Text('Toutes les notes seront définitivement supprimées. Continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vider', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      provider.emptyTrash();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Corbeille vidée')),
      );
    }
  }
}