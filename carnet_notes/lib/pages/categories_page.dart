import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/note.dart';
import '../providers/notes_providers.dart';
import 'all_notes_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();
  int _currentTabIndex = 0;

  @override
  void dispose() {
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final categories = notesProvider.categories;
    final notes = notesProvider.notes;

    final categoryStats = _calculateCategoryStats(notes, categories);
    final tagStats = _calculateTagStats(notes);
    final topTags = _getTopTags(tagStats, 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => _showStatsDialog(context, categoryStats, topTags),
            tooltip: 'Statistiques',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildCategoriesTab(categories, notesProvider, notes),
                _buildTagsTab(tagStats, notesProvider, notes),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SegmentedButton<int>(
        segments: const [
          ButtonSegment(
            value: 0,
            icon: Icon(Icons.category),
            label: Text('Catégories'),
          ),
          ButtonSegment(
            value: 1,
            icon: Icon(Icons.tag),
            label: Text('Tags'),
          ),
        ],
        selected: {_currentTabIndex},
        onSelectionChanged: (newSelection) {
          setState(() => _currentTabIndex = newSelection.first);
        },
      ),
    );
  }

  Widget _buildCategoriesTab(List<String> categories, NotesProvider provider, List<Note> notes) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final count = notes.where((n) => n.category == category).length;
        final color = _generateColor(category);

        return Dismissible(
          key: Key(category),
          background: Container(color: Colors.red),
          confirmDismiss: (_) => _confirmDelete(context, 'catégorie'),
          onDismissed: (_) => provider.removeCategory(category),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.category, color: color),
              ),
              title: Text(category),
              subtitle: Text('$count note${count > 1 ? 's' : ''}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showNotesByFilter(context, category, notes, isCategory: true),
              onLongPress: () => _editItem(context, category, provider, isCategory: true),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagsTab(Map<String, int> tagStats, NotesProvider provider, List<Note> notes) {
    final tags = tagStats.keys.toList();

    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, index) {
        final tag = tags[index];
        final count = tagStats[tag] ?? 0;
        final color = _generateColor(tag);

        return Dismissible(
          key: Key(tag),
          background: Container(color: Colors.red),
          confirmDismiss: (_) => _confirmDelete(context, 'tag'),
          onDismissed: (_) => provider.removeTagFromAllNotes(tag),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                child: Icon(Icons.tag, color: color),
              ),
              title: Text(tag),
              subtitle: Text('$count note${count > 1 ? 's' : ''}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showNotesByFilter(context, tag, notes, isCategory: false),
              onLongPress: () => _editItem(context, tag, provider, isCategory: false),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String type) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer ce $type ?'),
        content: Text('Toutes les notes associées seront mises à jour.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentTabIndex == 0 ? 'Nouvelle catégorie' : 'Nouveau tag'),
        content: TextField(
          controller: _currentTabIndex == 0 ? _categoryController : _tagController,
          decoration: InputDecoration(
            hintText: _currentTabIndex == 0 ? 'Nom de la catégorie' : 'Nom du tag',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<NotesProvider>(context, listen: false);
              final text = (_currentTabIndex == 0 ? _categoryController : _tagController).text.trim();

              if (text.isNotEmpty) {
                if (_currentTabIndex == 0) {
                  provider.addCategory(text);
                  _categoryController.clear();
                } else {
                  provider.addTagToAllNotes(text);
                  _tagController.clear();
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _editItem(BuildContext context, String name, NotesProvider provider, {required bool isCategory}) {
    final controller = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${isCategory ? 'catégorie' : 'tag'}'),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty && newName != name) {
                if (isCategory) {
                  provider.renameCategory(name, newName);
                } else {
                  provider.renameTag(name, newName);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showNotesByFilter(BuildContext context, String filter, List<Note> notes, {required bool isCategory}) {
    final filteredNotes = isCategory
        ? notes.where((n) => n.category == filter).toList()
        : notes.where((n) => n.tags.contains(filter)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllNotesPage(
          notes: filteredNotes,
          title: isCategory ? 'Catégorie: $filter' : 'Tag: $filter',
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context, Map<String, int> categoryStats, List<MapEntry<String, int>> topTags) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Statistiques',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Notes par catégorie'),
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    BarSeries<MapEntry<String, int>, String>(
                      dataSource: categoryStats.entries.toList(),
                      xValueMapper: (entry, _) => entry.key,
                      yValueMapper: (entry, _) => entry.value,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: SfCircularChart(
                  title: ChartTitle(text: 'Top 5 tags'),
                  legend: Legend(isVisible: true),
                  series: <CircularSeries>[
                    PieSeries<MapEntry<String, int>, String>(
                      dataSource: topTags,
                      xValueMapper: (entry, _) => entry.key,
                      yValueMapper: (entry, _) => entry.value,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _calculateCategoryStats(List<Note> notes, List<String> categories) {
    final stats = <String, int>{};
    for (var category in categories) {
      stats[category] = notes.where((n) => n.category == category).length;
    }
    return stats;
  }

  Map<String, int> _calculateTagStats(List<Note> notes) {
    final stats = <String, int>{};
    for (var note in notes) {
      for (var tag in note.tags) {
        stats[tag] = (stats[tag] ?? 0) + 1;
      }
    }
    return stats;
  }

  List<MapEntry<String, int>> _getTopTags(Map<String, int> tagStats, int count) {
    final entries = tagStats.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(count).toList();
  }

  Color _generateColor(String text) {
    final hash = text.hashCode;
    return Color(hash & 0xFFFFFF).withOpacity(1.0);
  }
}