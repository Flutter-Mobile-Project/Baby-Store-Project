import 'package:baby_store_app/data/mock_repository.dart';
import 'package:baby_store_app/models/specialist.dart';
import 'package:baby_store_app/models/time_slot.dart';
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  final MockRepository _repository;

  BookingProvider({required MockRepository repository})
    : _repository = repository {
    _initializeSpecialists();
  }

  List<Specialist> _specialists = [];
  int _selectedSpecialistIndex = 0;
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlotTime;

  List<TimeSlot> _morningSlots = [];
  List<TimeSlot> _afternoonSlots = [];
  bool _isLoadingSlots = false;
  bool _isSubmitting = false;

  List<Specialist> get specialists => _specialists;
  int get selectedSpecialistIndex => _selectedSpecialistIndex;
  DateTime get selectedDate => _selectedDate;
  String? get selectedSlotTime => _selectedSlotTime;

  List<TimeSlot> get morningSlots => _morningSlots;
  List<TimeSlot> get afternoonSlots => _afternoonSlots;
  bool get isLoadingSlots => _isLoadingSlots;
  bool get isSubmitting => _isSubmitting;

  Specialist? get currentSpecialist =>
      _specialists.isNotEmpty ? _specialists[_selectedSpecialistIndex] : null;

  void _initializeSpecialists() {
    _specialists = _repository.getSpecialists();
    if (_specialists.isNotEmpty) {
      fetchAvailableSlots();
    }
  }

  void selectSpecialist(int index) {
    if (_selectedSpecialistIndex == index) return;
    _selectedSpecialistIndex = index;
    _selectedSlotTime = null;
    fetchAvailableSlots();
    notifyListeners();
  }

  void selectDate(DateTime date) {
    // Fast equality evaluation checks to eliminate rebuild noise
    if (DateUtils.isSameDay(_selectedDate, date)) return;
    _selectedDate = date;
    _selectedSlotTime = null;
    fetchAvailableSlots();
    notifyListeners();
  }

  void selectSlotTime(String time) {
    _selectedSlotTime = time;
    notifyListeners();
  }

  Future<void> fetchAvailableSlots() async {
    if (currentSpecialist == null) return;

    _isLoadingSlots = true;
    notifyListeners();

    try {
      final allSlots = await _repository.fetchSlotsByDateAndSpecialist(
        specialistId: currentSpecialist!.id,
        date: _selectedDate,
      );

      _morningSlots = allSlots.where((slot) => _isMorning(slot.time)).toList();
      _afternoonSlots = allSlots
          .where((slot) => !_isMorning(slot.time))
          .toList();
    } catch (_) {
      _morningSlots = [];
      _afternoonSlots = [];
    } finally {
      _isLoadingSlots = false;
      notifyListeners();
    }
  }

  Future<bool> bookAppointment() async {
    if (currentSpecialist == null || _selectedSlotTime == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      final success = await _repository.createBooking(
        specialistId: currentSpecialist!.id,
        date: _selectedDate,
        time: _selectedSlotTime!,
      );

      if (success) {
        _selectedSlotTime = null;
      }
      return success;
    } catch (_) {
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  bool _isMorning(String timeString) {
    return timeString.toUpperCase().contains('AM');
  }
}
