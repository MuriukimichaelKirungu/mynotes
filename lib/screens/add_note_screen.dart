import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text("Choose a note type to add"),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded) ...[
            _noteOption(icon: Icons.text_fields, label: 'Text Note', onTap: () {
              Navigator.pushNamed(context, '/add_text_note');
            }),
            const SizedBox(height: 8),
            _noteOption(icon: Icons.photo_camera, label: 'Photo Note', onTap: () {
              // TODO: Implement photo note route
            }),
            const SizedBox(height: 8),
            _noteOption(icon: Icons.mic, label: 'Audio Note', onTap: () {
              // TODO: Implement audio note route
            }),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            backgroundColor: Colors.deepPurple,
            child: Icon(_isExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _noteOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return FloatingActionButton.extended(
      heroTag: label,
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      backgroundColor: Colors.deepPurple.shade300,
    );
  }
}
