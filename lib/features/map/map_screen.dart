import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baby_store_app/state/store_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _customMarkers = {};

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282),
    zoom: 13.5,
  );

  // ✅ Helper method to create map pin indicators dynamically
  void _updateMarkers(LatLng position, String title, String snippet) {
    setState(() {
      _customMarkers.clear(); // Clear existing temporary pins
      _customMarkers.add(
        Marker(
          markerId: const MarkerId('selected_store_pin'),
          position: position,
          infoWindow: InfoWindow(title: title, snippet: snippet),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch StoreState — rebuilds when branch is selected from Nearby
    final storeState = ref.watch(storeProvider);

    // Animate map and generate marker layout properties when coordinates change
    if (_mapController != null && storeState.selectedCoordinates != null) {
      final targetCoords = storeState.selectedCoordinates!;
      final branchName = storeState.selectedBranch?.name ?? 'Selected Store';
      final branchAddress = storeState.selectedBranch?.address ?? '';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 1. Pan the camera view over smoothly
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(targetCoords, 15.5),
        );
        
        // 2. Insert a red location marker drop pin onto coordinates
        _updateMarkers(targetCoords, branchName, branchAddress);
        
        // 3. Clear so it doesn't loop map animations repeatedly on unrelated widget layout redraws
        ref.read(storeProvider.notifier).clearSelectedCoordinates();
      });
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _defaultPosition,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          markers: _customMarkers, // Keeps the pin bound dynamically to rendering state
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            
            final coords = ref.read(storeProvider).selectedCoordinates;
            final selectedBranch = ref.read(storeProvider).selectedBranch;
            
            if (coords != null) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(coords, 15.5),
              );
              _updateMarkers(
                coords, 
                selectedBranch?.name ?? 'Selected Store', 
                selectedBranch?.address ?? '',
              );
              ref.read(storeProvider.notifier).clearSelectedCoordinates();
            }
          },
        ),

        // ── Store count badge ─────────────────────────────────
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
                const Icon(Icons.store, color: Color(0xFF4A6072), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    storeState.selectedBranch != null
                        ? storeState.selectedBranch!.name
                        : '2 TinyTots stores nearby',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF4A6072),
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Open',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}