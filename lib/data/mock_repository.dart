import 'dart:convert';
import 'package:baby_store_app/models/specialist.dart';
import 'package:baby_store_app/models/time_slot.dart';
import 'package:flutter/services.dart';
import '../models/branch.dart';

class MockRepository {
  Future<List<Branch>> loadBranches() async {
    final data = await rootBundle.loadString('assets/mock/branches.json');
    final List<dynamic> jsonList = json.decode(data);

    return jsonList.map((e) => Branch.fromJson(e)).toList();
  }

  List<Specialist> getSpecialists() {
    return const [
      Specialist(
        id: 'sp_1',
        name: 'Dr. Sarah Jenkins',
        role: 'Senior Pediatrician',
        rating: 4.9,
        image: 'assets/images/specialist/sarah.png',
      ),
      Specialist(
        id: 'sp_2',
        name: 'Nurse Elena Rose',
        role: 'Lactation Consultant',
        rating: 4.8,
        image: 'assets/images/specialist/elena.png',
      ),
    ];
  }

  Future<List<TimeSlot>> fetchSlotsByDateAndSpecialist({
    required String specialistId,
    required DateTime date,
  }) async {
    // Simulate API network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Dynamic scheduling logic generation based on date attributes
    final isEvenDay = date.day % 2 == 0;

    return [
      TimeSlot(time: '09:00 AM', isBooked: !isEvenDay),
      TimeSlot(time: '09:45 AM', isBooked: false),
      TimeSlot(time: '10:30 AM', isBooked: isEvenDay),
      TimeSlot(time: '11:15 AM', isBooked: false),
      TimeSlot(time: '02:00 PM', isBooked: false),
      TimeSlot(time: '02:45 PM', isBooked: isEvenDay),
      TimeSlot(time: '03:30 PM', isBooked: false),
      TimeSlot(time: '04:16 PM', isBooked: true), // Blocked off layout case
    ];
  }

  Future<bool> createBooking({
    required String specialistId,
    required DateTime date,
    required String time,
  }) async {
    // Simulate remote server push operations
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
