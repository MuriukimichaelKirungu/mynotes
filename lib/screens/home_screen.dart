import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _fabController.forward() : _fabController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10, // TODO: replace with real notes
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: const Text("Note content..."), // Replace with actual content
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Audio Note
          if (_isExpanded)
            Positioned(
              bottom: 180,
              child: FloatingActionButton(
                heroTag: 'audio',
                mini: true,
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  // TODO: Add audio note logic
                },
                child: const Icon(Icons.mic),
              ),
            ),
          // Photo Note
          if (_isExpanded)
            Positioned(
              bottom: 120,
              child: FloatingActionButton(
                heroTag: 'photo',
                mini: true,
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  // TODO: Add photo note logic
                },
                child: const Icon(Icons.photo),
              ),
            ),
          // Text Note
          if (_isExpanded)
            Positioned(
              bottom: 60,
              child: FloatingActionButton(
                heroTag: 'text',
                mini: true,
                backgroundColor: Colors.deepPurple,
                onPressed: () {
                  // TODO: Navigate to add text note
                },
                child: const Icon(Icons.note_add),
              ),
            ),
          // Main FAB
          FloatingActionButton(
            heroTag: 'main',
            backgroundColor: Colors.deepPurple,
            onPressed: _toggleFab,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _fabController,
            ),
          ),
        ],
      ),
    );
  }
}
