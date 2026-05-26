import 'package:flutter/material.dart';

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home (Temp)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/nearby'),
            child: const Text('Nearby Stores'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/map'),
            child: const Text('Map'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/booking'),
            child: const Text('Booking'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            child: const Text('Chat'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/reviews'),
            child: const Text('Reviews'),
          ),
        ],
      ),
    );
  }
}