import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../models/note.dart';
import '../providers/notes_providers.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late quill.QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  List<String> _tags = [];
  String _selectedCategory = 'Non classé';
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    if (widget.note != null) {
      _tags = widget.note!.tags;
      _selectedCategory = widget.note!.category;
      _isFavorite = widget.note!.isFavorite;
    }
  }

  void _initializeController() {
    final content = widget.note?.content ?? '';
    _controller = quill.QuillController(
      document: quill.Document.fromJson(content.isNotEmpty

           [{'insert': '\n'}]),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> _insertImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      final imagePath = result.files.single.path!;
      final index = _controller.selection.baseOffset;
      final length = _controller.selection.extentOffset - index;

      _controller.document.insert(
        index,
        {'insert': {'image': imagePath}},
      );
    }
  }

  void _showTagDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final tagController = TextEditingController();
        return AlertDialog(
          title: const Text('Ajouter un tag'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(hintText: 'Nouveau tag'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (tagController.text.trim().isNotEmpty) {
                  setState(() {
                    _tags.add(tagController.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _saveNote() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final note = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _controller.document.toPlainText().split('\n').first,
      content: _controller.document.toDelta().toJson(),
      tags: _tags,
      category: _selectedCategory,
      isFavorite: _isFavorite,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.note == null) {
      notesProvider.addNote(note);
    } else {
      notesProvider.updateNote(note);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NotesProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nouvelle note' : 'Éditer la note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre d'outils de formatage


          // Éditeur principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: quill.QuillEditor(
                controller: _controller,
                focusNode: _focusNode,
                scrollController: ScrollController(),

              ),
            ),
          ),

          // Section métadonnées
          _buildMetadataSection(categories),
        ],
      ),
    );
  }

  Widget _buildMetadataSection(List<String> categories) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favori
          Row(
            children: [
              const Text('Favori:'),
              Switch(
                value: _isFavorite,
                onChanged: (value) => setState(() => _isFavorite = value),
              ),
            ],
          ),

          // Catégorie
          DropdownButtonFormField(
            value: _selectedCategory,
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
            decoration: const InputDecoration(labelText: 'Catégorie'),
          ),

          // Tags
          Wrap(
            spacing: 4,
            children: [
              ..._tags.map((tag) => Chip(
                label: Text(tag),
                onDeleted: () => setState(() => _tags.remove(tag)),
              )).toList(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showTagDialog,
                tooltip: 'Ajouter un tag',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}