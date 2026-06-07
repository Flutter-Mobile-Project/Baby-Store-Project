import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../state/booking_provider.dart'; // Verified path matching your project structure
import '../../../../theme/app_colors.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  void _confirmBooking(BuildContext context, BookingProvider provider) async {
    // 1. Validation check for slot selection
    if (provider.selectedSlotTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a time slot',
            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600),
          ),
          backgroundColor: Color(0xFFE57373), // Soft reddish tint for warnings
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 2. Execute business logic operation sequence
    final success = await provider.bookAppointment();

    if (success && context.mounted) {
      // 3. Show embedded success state feedback right within the shell context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Appointment with ${provider.currentSpecialist?.name ?? "Specialist"} confirmed!',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(
            0xFF4A5E6D,
          ), // Matches your primary branding color
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);
    final systemPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: systemPadding.top + 16,
          bottom: systemPadding.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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

            _buildSectionTitle('Our Specialists'),
            const SizedBox(height: 12),
            _buildSpecialistList(provider),
            const SizedBox(height: 16),

            _buildDatePickerCard(provider),
            const SizedBox(height: 20),

            _buildTimeSlotsCard(provider),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: provider.isSubmitting
                  ? null
                  : () => _confirmBooking(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5E6D),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: provider.isSubmitting
                  ? const CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : const Text(
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
          ],
        ),
      ),
    );
  }

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

  Widget _buildSpecialistList(BookingProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.specialists.length,
      itemBuilder: (context, index) {
        final specialist = provider.specialists[index];
        final isSelected = provider.selectedSpecialistIndex == index;

        return GestureDetector(
          onTap: () => provider.selectSpecialist(index),
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
                  backgroundImage: AssetImage(specialist.image),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        specialist.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A4D5B),
                        ),
                      ),
                      Text(
                        specialist.role,
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
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            specialist.rating.toString(),
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
    );
  }

  Widget _buildDatePickerCard(BookingProvider provider) {
    return Container(
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
              itemCount: 14,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = DateUtils.isSameDay(
                  provider.selectedDate,
                  date,
                );

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
                  onTap: () => provider.selectDate(date),
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
    );
  }

  Widget _buildTimeSlotsCard(BookingProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: provider.isLoadingSlots
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeSlotHeader(
                  Icons.light_mode_outlined,
                  'Morning Slots',
                ),
                const SizedBox(height: 12),
                _buildTimeGrid(provider, provider.morningSlots),
                const SizedBox(height: 20),
                _buildTimeSlotHeader(
                  Icons.wb_twilight_outlined,
                  'Afternoon Slots',
                ),
                const SizedBox(height: 12),
                _buildTimeGrid(provider, provider.afternoonSlots),
              ],
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

  Widget _buildTimeGrid(BookingProvider provider, List<dynamic> slots) {
    if (slots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          'No slots available',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Colors.black38,
          ),
        ),
      );
    }

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
        final slot = slots[index];
        final isSelected = provider.selectedSlotTime == slot.time;
        final isDisabled = slot.isBooked;

        return GestureDetector(
          onTap: isDisabled ? null : () => provider.selectSlotTime(slot.time),
          child: Container(
            decoration: BoxDecoration(
              color: isDisabled
                  ? const Color(0xFFF5F5F5)
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
                slot.time,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? Colors.black26
                      : isSelected
                      ? const Color(0xFF4A5E6D)
                      : const Color(0xFF3A4D5B),
                  decoration: isDisabled ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
