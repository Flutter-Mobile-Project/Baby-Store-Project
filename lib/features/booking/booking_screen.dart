import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/state/booking_provider.dart';
import '../shell/main_shell_screen.dart';
import '../auth/login_screen.dart';
import '../../services/auth_service.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final void Function(int)? onNavigate;
  const BookingScreen({super.key, this.onNavigate});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  bool _showSummary = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _proceedToSummary() {
    final state = ref.read(bookingProvider);
    if (state.selectedSlotTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a time slot',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Color(0xFFE57373),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in your name and phone',
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          backgroundColor: Color(0xFFE57373),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ref.read(bookingProvider.notifier)
      ..updateClientName(_nameController.text.trim())
      ..updateClientPhone(_phoneController.text.trim())
      ..updateClientNote(_noteController.text.trim());
    setState(() => _showSummary = true);
  }

  Future<void> _confirmBooking() async {
    final success = await ref.read(bookingProvider.notifier).confirmBooking();
    if (!mounted) return;

    if (success) {
      setState(() => _showSummary = false);
      ref.read(bookingProvider.notifier).reset();
      _nameController.clear();
      _phoneController.clear();
      _noteController.clear();
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.cream,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFDDEBE3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF3D6255),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A4D5B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A confirmation will be sent to your registered email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5E6D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNavigate?.call(tabHome);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // TextButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text(
            //     'Make another booking',
            //     style: TextStyle(
            //       fontFamily: 'Nunito',
            //       color: Color(0xFF4A5E6D),
            //       fontSize: 13,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showSummary ? _buildSummary(state) : _buildForm(state),
    );
  }

  // ── STEP 1: Booking form ──────────────────────────────────────────
  Widget _buildForm(BookingState state) {
    final specialists = BookingNotifier.specialists;

    return SingleChildScrollView(
      key: const ValueKey('form'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          const Text(
            'Expert Care for You & Baby',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A4D5B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nurturing advice from certified specialists.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 24),

          // ── Specialists ───────────────────────────────────────
          const Text(
            'Our Specialists',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A4D5B),
            ),
          ),
          const SizedBox(height: 12),
          ...specialists.asMap().entries.map((e) {
            final index = e.key;
            final s = e.value;
            final isSelected = state.selectedSpecialistIndex == index;
            return GestureDetector(
              onTap: () =>
                  ref.read(bookingProvider.notifier).selectSpecialist(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4A5E6D)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade200,
                      child: ClipOval(
                        child: Image.asset(
                          s.image,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3A4D5B),
                            ),
                          ),
                          Text(
                            s.role,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${s.rating}',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4A5E6D),
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // ── Date picker ───────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
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
                    itemBuilder: (_, i) {
                      final date = DateTime.now().add(Duration(days: i));
                      final isSelected = DateUtils.isSameDay(
                        state.selectedDate,
                        date,
                      );
                      final days = [
                        'MON',
                        'TUE',
                        'WED',
                        'THU',
                        'FRI',
                        'SAT',
                        'SUN',
                      ];
                      return GestureDetector(
                        onTap: () =>
                            ref.read(bookingProvider.notifier).selectDate(date),
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
                                days[date.weekday - 1],
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

          const SizedBox(height: 16),

          // ── Time slots ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _slotHeader(Icons.light_mode_outlined, 'Morning'),
                const SizedBox(height: 10),
                _slotGrid(BookingNotifier.morningSlots, state),
                const SizedBox(height: 16),
                _slotHeader(Icons.wb_twilight_outlined, 'Afternoon'),
                const SizedBox(height: 10),
                _slotGrid(BookingNotifier.afternoonSlots, state),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Client information ────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A4D5B),
                  ),
                ),
                const SizedBox(height: 14),
                _clientField(
                  controller: _nameController,
                  hint: 'Full Name',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _clientField(
                  controller: _phoneController,
                  hint: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _clientField(
                  controller: _noteController,
                  hint: 'Notes for the specialist (optional)',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Review & confirm button ───────────────────────────
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5E6D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              onPressed: _proceedToSummary,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Review Booking',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── STEP 2: Booking summary ─────────────────────────────────────
  Widget _buildSummary(BookingState state) {
    final specialist =
        BookingNotifier.specialists[state.selectedSpecialistIndex];
    final d = state.selectedDate;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return SingleChildScrollView(
      key: const ValueKey('summary'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Back button ───────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _showSummary = false),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Color(0xFF4A5E6D),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Edit booking',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13,
                    color: Color(0xFF4A5E6D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Booking Summary',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3A4D5B),
            ),
          ),
          const Text(
            'Please review before confirming',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              color: Colors.black45,
            ),
          ),

          const SizedBox(height: 24),

          // ── Specialist card ───────────────────────────────────
          _summaryCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade100,
                  child: ClipOval(
                    child: Image.asset(
                      specialist.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialist.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4D5B),
                      ),
                    ),
                    Text(
                      specialist.role,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          '${specialist.rating}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Date & time ───────────────────────────────────────
          _summaryCard(
            child: Row(
              children: [
                Expanded(
                  child: _summaryInfo(
                    Icons.calendar_today_outlined,
                    'Date',
                    '${days[d.weekday - 1]}, ${months[d.month]} ${d.day}',
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade200),
                Expanded(
                  child: _summaryInfo(
                    Icons.access_time_rounded,
                    'Time',
                    state.selectedSlotTime ?? '',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Client info ───────────────────────────────────────
          _summaryCard(
            child: Column(
              children: [
                _summaryInfo(Icons.person_outline, 'Name', state.clientName),
                const SizedBox(height: 10),
                _summaryInfo(Icons.phone_outlined, 'Phone', state.clientPhone),
                if (state.clientNote.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _summaryInfo(Icons.notes_outlined, 'Notes', state.clientNote),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Confirm button ────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5E6D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              onPressed: state.isSubmitting ? null : _confirmBooking,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'By confirming you agree to our cancellation policy',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helper widgets ──────────────────────────────────────────────
  Widget _slotHeader(IconData icon, String label) => Row(
    children: [
      Icon(icon, size: 15, color: Colors.black45),
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

  Widget _slotGrid(
    List<TimeSlot> slots,
    BookingState state,
  ) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: slots.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
    ),
    itemBuilder: (_, i) {
      final slot = slots[i];
      final isSelected = state.selectedSlotTime == slot.time;
      return GestureDetector(
        onTap: slot.isBooked
            ? null
            : () => ref.read(bookingProvider.notifier).selectSlot(slot.time),
        child: Container(
          decoration: BoxDecoration(
            color: slot.isBooked
                ? const Color(0xFFF5F5F5)
                : isSelected
                ? const Color(0xFFD4E7F5)
                : const Color(0xFFF3EFEA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? const Color(0xFF4A5E6D) : Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              slot.time,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: slot.isBooked
                    ? Colors.black26
                    : isSelected
                    ? const Color(0xFF4A5E6D)
                    : const Color(0xFF3A4D5B),
                decoration: slot.isBooked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _clientField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF7F3EC),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(maxLines > 1 ? 14 : 0).copyWith(left: 14),
          child: Icon(icon, size: 18, color: Colors.black38),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: Color(0xFF3A4D5B),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: Colors.black26,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _summaryCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );

  Widget _summaryInfo(IconData icon, String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: Colors.black38),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: Colors.black38,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3A4D5B),
            ),
          ),
        ],
      ),
    ],
  );
}
