import 'package:flutter/material.dart';

class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Stores')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, i) => ListTile(
          title: Text('Branch ${i + 1}'),
          subtitle: const Text('2 km away'),
          trailing: const Chip(
            label: Text('In Stock'),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
