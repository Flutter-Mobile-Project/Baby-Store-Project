import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlotTime;
  int _selectedSpecialistIndex = 0; // Tracks chosen expert card

  // 🏥 Specialist Profile Datastore
  final List<Map<String, String>> _specialists = [
    {
      'name': 'Dr. Sarah Jenkins',
      'role': 'Senior Pediatrician',
      'rating': '4.9',
      'image': 'assets/images/specialist/sarah.png',
    },
    {
      'name': 'Nurse Elena Rose',
      'role': 'Lactation Consultant',
      'rating': '4.8',
      'image': 'assets/images/specialist/elena.png',
    },
  ];

  // ⏰ Structured Day Allocation Slots
  final List<String> _morningSlots = [
    '09:00 AM',
    '09:45 AM',
    '10:30 AM',
    '11:15 AM',
  ];
  final List<String> _afternoonSlots = [
    '02:00 PM',
    '02:45 PM',
    '03:30 PM',
    '04:16 PM',
  ];

  void _confirmBooking() {
    if (_selectedSlotTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a time slot',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Color(0xFF4A5E6D),
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
              'Specialist: ${_specialists[_selectedSpecialistIndex]['name']}',
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
            Text(
              'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
            Text(
              'Time: $_selectedSlotTime',
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedSlotTime = null);
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // ── 🌟 Title Header block ──
            const Text(
              'Expert Care for You &\nBaby',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A4D5B),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nurturing advice from certified specialists to help you navigate the beautiful journey of early parenthood.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            // ── 👥 Our Specialists List ──
            _buildSectionTitle('Our Specialists'),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _specialists.length,
              itemBuilder: (context, index) {
                final specialist = _specialists[index];
                final isSelected = _selectedSpecialistIndex == index;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedSpecialistIndex = index;
                    _selectedSlotTime =
                        null; // reset selected slot on expert change
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD4E7F5)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: AssetImage(specialist['image']!),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                specialist['name']!,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3A4D5B),
                                ),
                              ),
                              Text(
                                specialist['role']!,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 12,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    specialist['rating']!,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // ── 📅 Select Date Horizon Picker ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A4D5B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected = _selectedDate.day == date.day;

                        final dayNames = [
                          'MON',
                          'TUE',
                          'WED',
                          'THU',
                          'FRI',
                          'SAT',
                          'SUN',
                        ];
                        final dayName = dayNames[date.weekday - 1];

                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedDate = date;
                            _selectedSlotTime = null;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 54,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD4E7F5)
                                  : const Color(0xFFF3EFEA),
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF4A5E6D)
                                        : Colors.black38,
                                  ),
                                ),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF4A5E6D)
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── ⏰ Segmented Day-Part Time Selectors ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeSlotHeader(
                    Icons.light_mode_outlined,
                    'Morning Slots',
                  ),
                  const SizedBox(height: 12),
                  _buildTimeGrid(_morningSlots),

                  const SizedBox(height: 20),

                  _buildTimeSlotHeader(
                    Icons.wb_twilight_outlined,
                    'Afternoon Slots',
                  ),
                  const SizedBox(height: 12),
                  _buildTimeGrid(_afternoonSlots),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 🔘 Primary Booking Action Control ──
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5E6D),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A confirmation email will be sent to your registered address.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: Colors.black38,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🛠️ Functional Layout Helper Sub-Widgets
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3A4D5B),
        ),
      ),
    );
  }

  Widget _buildTimeSlotHeader(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black45),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeGrid(List<String> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final time = slots[index];
        final isSelected = _selectedSlotTime == time;

        // Mock a generic disabled state styling variant matching mockup ("04:16 PM")
        final isDisabled = time == '04:16 PM';

        return GestureDetector(
          onTap: isDisabled
              ? null
              : () => setState(() => _selectedSlotTime = time),
          child: Container(
            decoration: BoxDecoration(
              color: isDisabled
                  ? const Color(0xFFFAF8F5)
                  : isSelected
                  ? const Color(0xFFD4E7F5)
                  : const Color(0xFFF3EFEA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4A5E6D)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? Colors.tealAccent
                      : isSelected
                      ? const Color(0xFF4A5E6D)
                      : const Color(0xFF3A4D5B),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
