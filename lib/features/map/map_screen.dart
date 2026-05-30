import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    // ── No Scaffold, no AppBar — shell owns those ──
    return Stack(
      children: [
        // ── Google Map ─────────────────────────────────────────
        GoogleMap(
          initialCameraPosition: _initialPosition,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          markers: _storeMarkers,
        ),

        // ── Store count badge ──────────────────────────────────
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.store, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '2 TinyTots stores nearby',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Open now',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── View nearby list button ────────────────────────────
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              // Switch to nearby tab (index 5 in shell)
              // No Navigator.pop needed — just inform user
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Tap "Nearby" in the menu to see the list',
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                  backgroundColor: Color(0xFF556B7B),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF556B7B),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.list, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'View Nearby Stores List',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ── Store markers ──────────────────────────────────────────────
final Set<Marker> _storeMarkers = {
  Marker(
    markerId: const MarkerId('store_1'),
    position: const LatLng(11.5564, 104.9282),
    infoWindow: const InfoWindow(
      title: 'TinyTots Blossom Village',
      snippet: 'In Stock',
    ),
  ),
  Marker(
    markerId: const MarkerId('store_2'),
    position: const LatLng(11.5650, 104.9210),
    infoWindow: const InfoWindow(
      title: 'Baby Haven Central',
      snippet: 'Limited Stock',
    ),
  ),
};
