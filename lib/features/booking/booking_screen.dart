import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedSlot;
  String _selectedType = 'Doctor';

  final List<String> _consultantTypes = ['Doctor', 'Nutritionist', 'General'];

  final List<Map<String, String>> _slots = [
    {'time': '09:00 AM', 'status': 'available'},
    {'time': '09:30 AM', 'status': 'booked'},
    {'time': '10:00 AM', 'status': 'available'},
    {'time': '10:30 AM', 'status': 'available'},
    {'time': '11:00 AM', 'status': 'booked'},
    {'time': '11:30 AM', 'status': 'available'},
    {'time': '02:00 PM', 'status': 'available'},
    {'time': '02:30 PM', 'status': 'available'},
    {'time': '03:00 PM', 'status': 'booked'},
    {'time': '03:30 PM', 'status': 'available'},
  ];

  void _confirmBooking() {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a time slot',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Color(0xFF556B7B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.cream,
        title: const Text(
          'Booking Confirmed!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text(
              'Type: $_selectedType',
              style: const TextStyle(fontFamily: 'Nunito', fontSize: 14),
            ),
            Text(
              'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontFamily: 'Nunito', fontSize: 14),
            ),
            Text(
              'Time: ${_slots[_selectedSlot!]['time']}',
              style: const TextStyle(fontFamily: 'Nunito', fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedSlot = null);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── No Scaffold — shell owns chrome ──
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // ── Header ──────────────────────────────────────────────
          const Text(
            'Service Booking',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Book a consultation with our experts',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 24),

          // ── Consultant type ─────────────────────────────────────
          const Text(
            'Select Type',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _consultantTypes.map((type) {
              final isSelected = _selectedType == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedType = type;
                      _selectedSlot = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.textPrimary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.textPrimary
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Date picker ─────────────────────────────────────────
          const Text(
            'Select Date',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected =
                    _selectedDate.day == date.day &&
                    _selectedDate.month == date.month;
                final dayNames = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ];
                final dayName = dayNames[date.weekday - 1];

                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedDate = date;
                    _selectedSlot = null;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.textPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: isSelected
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── Time slots ──────────────────────────────────────────
          const Text(
            'Available Slots',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: _slots.length,
            itemBuilder: (context, index) {
              final slot = _slots[index];
              final isBooked = slot['status'] == 'booked';
              final isSelected = _selectedSlot == index;

              return GestureDetector(
                onTap: isBooked
                    ? null
                    : () => setState(() => _selectedSlot = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isBooked
                        ? Colors.grey.shade100
                        : isSelected
                        ? AppColors.babyBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      slot['time']!,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isBooked
                            ? Colors.grey.shade400
                            : AppColors.textPrimary,
                        decoration: isBooked
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ── Legend ──────────────────────────────────────────────
          Row(
            children: [
              _legend(AppColors.babyBlue, 'Selected'),
              const SizedBox(width: 16),
              _legend(Colors.white, 'Available'),
              const SizedBox(width: 16),
              _legend(Colors.grey.shade100, 'Booked'),
            ],
          ),

          const SizedBox(height: 32),

          // ── Confirm button ──────────────────────────────────────
          GestureDetector(
            onTap: _confirmBooking,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF556B7B),
                borderRadius: BorderRadius.circular(35),
              ),
              child: const Center(
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
