import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // Initial camera position (Phnom Penh example)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Map'), centerTitle: true),
      body: Stack(
        children: [
          // 🗺 Google Map
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: _storeMarkers,
          ),

          // 🔘 Back to Nearby button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Back to Nearby Stores'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Mock store markers
final Set<Marker> _storeMarkers = {
  Marker(
    markerId: MarkerId('store_1'),
    position: LatLng(11.5564, 104.9282),
    infoWindow: InfoWindow(
      title: 'TinyTots Blossom Village',
      snippet: 'In Stock',
    ),
  ),
  Marker(
    markerId: MarkerId('store_2'),
    position: LatLng(11.5650, 104.9210),
    infoWindow: InfoWindow(title: 'Baby Haven Central', snippet: 'Limited'),
  ),
};
