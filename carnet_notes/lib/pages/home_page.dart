import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('94:1'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec avatar et stats
            _buildUserHeader(),

            // Section Notes
            _buildSectionHeader('Notes', icon: Icons.note),
            _buildMenuItem('Highlights', icon: Icons.star),
            _buildMenuItem('Favorite Notes', icon: Icons.favorite),
            _buildMenuItem('Recent Notes', icon: Icons.access_time),
            _buildMenuItem('Shared Notes', icon: Icons.share),
            const Divider(height: 20),

            // List Notes Section
            _buildSectionHeader('List Notes', icon: Icons.list),
            _buildMenuItem('All Notes', count: 42),
            _buildMenuItem('Work Notes', count: 12),
            _buildMenuItem('Personal Notes', count: 8),
            _buildMenuItem('Ideas', count: 15),
            const Divider(height: 20),

            // Notes récentes avec plus de détails
            _buildSectionHeader('Recent Activities', icon: Icons.history),
            _buildNoteItem(
              title: 'How To Draw A Professional Wheelemad',
              content: 'For Westerns Design, You Need To Hand a Pan And Hope With You And Bring Them True. You Can Design The Lion You Want On Paper for Wine Or Mobile, Just Learn...',
              tags: ['Design', 'Wheelems'],
              date: '2000-05-09',
              color: Colors.orange[100],
              icon: Icons.brush,
            ),
            _buildNoteItem(
              title: 'Ways To Succeed Early',
              content: 'The key to early success lies in consistent small improvements and networking with the right people in your industry.',
              tags: ['Success', 'Productivity'],
              date: '2000-03-07',
              color: Colors.green[100],
              icon: Icons.rocket_launch,
            ),
            _buildNoteItem(
              title: 'Scientific Facts Of Space',
              content: 'Space is completely silent because there is no medium for sound waves to travel through. The hottest planet in our solar system is Venus.',
              tags: ['Science', 'Astronomy'],
              date: '2000-01-15',
              color: Colors.blue[100],
              icon: Icons.star,
              additionalInfo: 'Score: 98%',
            ),
            _buildNoteItem(
              title: 'Healthy Morning Routine',
              content: 'Start your day with a glass of water, 10 minutes of meditation, and a short workout to boost your energy levels.',
              tags: ['Health', 'Routine'],
              date: '2000-04-22',
              color: Colors.purple[100],
              icon: Icons.self_improvement,
            ),

            // Section Tags
            _buildSectionHeader('Popular Tags', icon: Icons.tag),
            _buildTagChips(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/41.jpg'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(color: Colors.grey),
              ),
              const Text(
                'Leo Designer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatItem('42', 'Notes'),
                  const SizedBox(width: 16),
                  _buildStatItem('12', 'Tags'),
                  const SizedBox(width: 16),
                  _buildStatItem('5', 'Categories'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.indigo),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {IconData? icon, int? count}) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(32.0, 4.0, 16.0, 4.0),
      leading: icon != null ? Icon(icon, size: 20) : null,
      title: Text(title),
      trailing: count != null
          ? Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(count.toString()),
      )
          : null,
      onTap: () {},
    );
  }

  Widget _buildNoteItem({
    required String title,
    required String content,
    required List<String> tags,
    required String date,
    Color? color,
    IconData? icon,
    String? additionalInfo,
  }) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: color,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            Wrap(
              spacing: 4,
              children: tags
                  .map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Colors.white.withOpacity(0.4),
                labelStyle: const TextStyle(fontSize: 12),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ))
                  .toList(),
            ),
            if (date.isNotEmpty || additionalInfo != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                child: Row(
                  children: [
                    if (date.isNotEmpty) ...[
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                    if (date.isNotEmpty && additionalInfo != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('•', style: TextStyle(color: Colors.grey)),
                      ),
                    if (additionalInfo != null)
                      Text(
                        additionalInfo,
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChips() {
    final tags = [
      'Design',
      'Work',
      'Personal',
      'Ideas',
      'Science',
      'Health',
      'Productivity',
      'Learning'
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map((tag) => ActionChip(
          label: Text(tag),
          onPressed: () {},
          backgroundColor: Colors.indigo.withOpacity(0.1),
          labelStyle: const TextStyle(color: Colors.indigo),
        ))
            .toList(),
      ),
    );
  }
}