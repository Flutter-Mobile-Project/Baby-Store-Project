// lib/state/store_provider.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/branch.dart';

class StoreProvider extends ChangeNotifier {
  LatLng? _selectedCoordinates;
  int _currentTabIndex = 0; // Tracks the active tab in your MainShellScreen

  LatLng? get selectedCoordinates => _selectedCoordinates;
  int get currentTabIndex => _currentTabIndex;

  void changeTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void selectBranchForMap(Branch branch, int mapTabIndex) {
    // Assuming your Branch model has latitude and longitude fields:
    // e.g., branch.latitude, branch.longitude
    _selectedCoordinates = LatLng(branch.latitude, branch.longitude);

    // Auto-switch the shell tab index to your MapScreen tab
    _currentTabIndex = mapTabIndex;
    notifyListeners();
  }

  void clearSelectedCoordinates() {
    _selectedCoordinates = null;
  }
}
