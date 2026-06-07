// lib/features/map/presentation/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:baby_store_app/state/store_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _customMarkers = {};

  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(11.5564, 104.9282),
    zoom: 13.5,
  );

  @override
  Widget build(BuildContext context) {
    // 1. Listen for branch selections made on the Nearby tab
    final storeProvider = Provider.of<StoreProvider>(context);

    // 2. If a specific branch was tapped, update camera location reactively
    if (_mapController != null && storeProvider.selectedCoordinates != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(storeProvider.selectedCoordinates!, 15.5),
      );
      // Optional: Clear selection afterward so the user can pan freely again
      storeProvider.clearSelectedCoordinates();
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _defaultPosition,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          markers: _customMarkers,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;

            // Handle edge case: if tab switches over and data is already waiting
            if (storeProvider.selectedCoordinates != null) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  storeProvider.selectedCoordinates!,
                  15.5,
                ),
              );
              storeProvider.clearSelectedCoordinates();
            }
          },
        ),
        // ... (Keep the rest of your Top Bar and Bottom Bar code exactly the same!)
      ],
    );
  }
}
