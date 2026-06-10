import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/services/booking_service.dart';

class Specialist {
  final String name;
  final String role;
  final double rating;
  final String image;
  const Specialist({
    required this.name,
    required this.role,
    required this.rating,
    required this.image,
  });
}

class TimeSlot {
  final String time;
  final bool isBooked;
  const TimeSlot({required this.time, this.isBooked = false});
}

class BookingState {
  final int selectedSpecialistIndex;
  final DateTime selectedDate;
  final String? selectedSlotTime;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  // Client info
  final String clientName;
  final String clientPhone;
  final String clientNote;

  const BookingState({
    this.selectedSpecialistIndex = 0,
    DateTime? selectedDate,
    this.selectedSlotTime,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.clientName = '',
    this.clientPhone = '',
    this.clientNote = '',
  }) : selectedDate = selectedDate ?? const _Now();

  BookingState copyWith({
    int? selectedSpecialistIndex,
    DateTime? selectedDate,
    String? selectedSlotTime,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    String? clientName,
    String? clientPhone,
    String? clientNote,
    bool clearSlot = false,
  }) {
    return BookingState(
      selectedSpecialistIndex:
          selectedSpecialistIndex ?? this.selectedSpecialistIndex,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotTime: clearSlot
          ? null
          : selectedSlotTime ?? this.selectedSlotTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientNote: clientNote ?? this.clientNote,
    );
  }
}

// Workaround for const DateTime.now()
class _Now implements DateTime {
  const _Now();
  // ignore all — just used as default placeholder
  @override
  dynamic noSuchMethod(Invocation i) => DateTime.now();
}

class BookingNotifier extends Notifier<BookingState> {
  static const specialists = [
    Specialist(
      name: 'Dr. Sarah Jenkins',
      role: 'Senior Pediatrician',
      rating: 4.9,
      image: 'assets/images/specialist/sarah.png',
    ),
    Specialist(
      name: 'Nurse Elena Rose',
      role: 'Lactation Consultant',
      rating: 4.8,
      image: 'assets/images/specialist/elena.png',
    ),
  ];

  static const morningSlots = [
    TimeSlot(time: '09:00 AM'),
    TimeSlot(time: '09:45 AM'),
    TimeSlot(time: '10:30 AM'),
    TimeSlot(time: '11:15 AM', isBooked: true),
  ];

  static const afternoonSlots = [
    TimeSlot(time: '02:00 PM'),
    TimeSlot(time: '02:45 PM'),
    TimeSlot(time: '03:30 PM'),
    TimeSlot(time: '04:15 PM', isBooked: true),
  ];

  @override
  BookingState build() => BookingState(selectedDate: DateTime.now());

  void selectSpecialist(int index) =>
      state = state.copyWith(selectedSpecialistIndex: index, clearSlot: true);

  void selectDate(DateTime date) =>
      state = state.copyWith(selectedDate: date, clearSlot: true);

  void selectSlot(String time) =>
      state = state.copyWith(selectedSlotTime: time);

  void updateClientName(String v) => state = state.copyWith(clientName: v);
  void updateClientPhone(String v) => state = state.copyWith(clientPhone: v);
  void updateClientNote(String v) => state = state.copyWith(clientNote: v);

  Future<bool> confirmBooking() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    
    final specialist = specialists[state.selectedSpecialistIndex];
    
    final error = await BookingService.createBooking(
      specialistName: specialist.name,
      specialistRole: specialist.role,
      date: state.selectedDate,
      time: state.selectedSlotTime!,
      clientName: state.clientName,
      clientPhone: state.clientPhone,
      clientNote: state.clientNote,
    );

    if (error != null) {
      state = state.copyWith(isSubmitting: false, errorMessage: error);
      return false;
    }

    state = state.copyWith(isSubmitting: false, isSuccess: true);
    return true;
  }

  void reset() => state = BookingState(selectedDate: DateTime.now());
}

final bookingProvider = NotifierProvider<BookingNotifier, BookingState>(
  BookingNotifier.new,
);
