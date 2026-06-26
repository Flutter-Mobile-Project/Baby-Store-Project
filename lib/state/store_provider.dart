import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/branch.dart';

// ── State model ────────────────────────────────────────────────────
class StoreState {
  final LatLng? selectedCoordinates;
  final Branch? selectedBranch;

  const StoreState({this.selectedCoordinates, this.selectedBranch});

  StoreState copyWith({
    LatLng? selectedCoordinates,
    Branch? selectedBranch,
    bool clearCoords = false,
    bool clearBranch = false,
  }) {
    return StoreState(
      selectedCoordinates: clearCoords
          ? null
          : selectedCoordinates ?? this.selectedCoordinates,
      selectedBranch: clearBranch
          ? null
          : selectedBranch ?? this.selectedBranch,
    );
  }
}

// ── Notifier ───────────────────────────────────────────────────────
class StoreNotifier extends Notifier<StoreState> {
  @override
  StoreState build() => const StoreState();

  // Select a branch — sets coords and branch object
  void selectBranch(Branch branch) {
    state = StoreState(
      selectedCoordinates: LatLng(branch.latitude, branch.longitude),
      selectedBranch: branch,
    );
  }

  // Select coords only
  void selectCoordinates(LatLng coords) {
    state = state.copyWith(selectedCoordinates: coords);
  }

  // Clear after map animates to location
  void clearSelectedCoordinates() {
    state = state.copyWith(clearCoords: true);
  }

  // Clear everything
  void reset() {
    state = const StoreState();
  }
}

// ── Provider ───────────────────────────────────────────────────────
final storeProvider = NotifierProvider<StoreNotifier, StoreState>(
  StoreNotifier.new,
);
