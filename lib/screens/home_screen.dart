import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10,
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
              child: const Text("Note content..."),
            );
          },
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_isExpanded)
            Positioned(
              bottom: 180,
              child: FloatingActionButton(
                heroTag: 'audio',
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/add_audio_note');
                },
                child: const Icon(Icons.mic),
              ),
            ),
          if (_isExpanded)
            Positioned(
              bottom: 120,
              child: FloatingActionButton(
                heroTag: 'photo',
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/add_photo_note');
                },
                child: const Icon(Icons.photo),
              ),
            ),
          if (_isExpanded)
            Positioned(
              bottom: 60,
              child: FloatingActionButton(
                heroTag: 'text',
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, '/add_text_note');
                },
                child: const Icon(Icons.note_add),
              ),
            ),
          FloatingActionButton(
            heroTag: 'main',
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
