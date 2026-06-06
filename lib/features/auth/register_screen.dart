import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/state/user_provider.dart';
import 'package:baby_store_app/models/user.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  DateTime? _selectedDate;
  int _currentStep = 0; // 0 = account, 1 = baby info

  String? _nameError;
  String? _emailError;
  String? _passwordError;

  late AnimationController _fadeController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _stepFade;
  late Animation<Offset> _stepSlide;

  // ── Color palette ──────────────────────────────────────────────
  static const Color _sage = Color(0xFF7A9E8E);
  static const Color _darkSage = Color(0xFF3D6255);
  static const Color _cream = Color(0xFFF7F3EC);
  static const Color _softWhite = Color(0xFFFBF9F6);
  static const Color _textDark = Color(0xFF2C2C2C);
  static const Color _textMid = Color(0xFF6B6B6B);
  static const Color _textLight = Color(0xFFAAAAAA);
  static const Color _mintCard = Color(0xFF4A7566);
  static const Color _errorRed = Color(0xFFE05A5A);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _stepFade = CurvedAnimation(parent: _stepController, curve: Curves.easeOut);
    _stepSlide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _stepController, curve: Curves.easeOut));

    _fadeController.forward();
    _stepController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _stepController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validators ─────────────────────────────────────────────────
  String? _validateName(String v) {
    if (v.trim().isEmpty) return 'Full name is required';
    if (v.trim().length < 2) return 'At least 2 characters';
    return null;
  }

  String? _validateEmail(String v) {
    if (v.trim().isEmpty) return 'Email is required';
    final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!reg.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min. 8 characters (${v.length}/8)';
    return null;
  }

  void _onNameChanged(String v) {
    if (_nameError != null) setState(() => _nameError = _validateName(v));
  }

  void _onEmailChanged(String v) {
    if (_emailError != null) setState(() => _emailError = _validateEmail(v));
  }

  void _onPasswordChanged(String v) {
    setState(() => _passwordError = _validatePassword(v));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _darkSage,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _nextStep() {
    setState(() {
      _nameError = _validateName(_nameController.text);
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });
    if (_nameError != null || _emailError != null || _passwordError != null)
      return;

    setState(() => _currentStep = 1);
    _stepController.reset();
    _stepController.forward();
  }

  void _register() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    ref.read(userProvider.notifier).state = User(
      name: _nameController.text.trim(),
      membership: 'Platinum Member',
    );

    setState(() => _isLoading = false);
    Navigator.of(context, rootNavigator: true).pop(true);
  }

  int get _passwordStrength {
    final p = _passwordController.text;
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }

  String _formatDate(DateTime d) {
    const months = [
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
    return '${months[d.month]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                // ── Top bar ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentStep == 1) {
                            setState(() => _currentStep = 0);
                          } else {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(false);
                          }
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: _textDark,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Step indicator
                      _buildStepDot(0),
                      const SizedBox(width: 6),
                      _buildStepDot(1),
                      const Spacer(),
                      const SizedBox(width: 36),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        // ── Brand mark ────────────────────────
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: _sage.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.child_care_rounded,
                                  size: 28,
                                  color: _sage,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentStep == 0
                                    ? 'Create Account'
                                    : "Baby's Journey",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: _textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _currentStep == 0
                                    ? 'Welcome to TinyTots — where every\nlittle milestone matters.'
                                    : 'Help us personalize your experience\nwith the right essentials.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 13.5,
                                  color: _textLight,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Step content ──────────────────────
                        FadeTransition(
                          opacity: _stepFade,
                          child: SlideTransition(
                            position: _stepSlide,
                            child: _currentStep == 0
                                ? _buildStep1()
                                : _buildStep2(),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 1: Account details ─────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          label: 'Full Name',
          hint: 'e.g. Sarah Jenkins',
          controller: _nameController,
          icon: Icons.person_outline_rounded,
          error: _nameError,
          onChanged: _onNameChanged,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: 'Email Address',
          hint: 'sarah@example.com',
          controller: _emailController,
          icon: Icons.alternate_email_rounded,
          error: _emailError,
          keyboardType: TextInputType.emailAddress,
          onChanged: _onEmailChanged,
        ),
        const SizedBox(height: 16),
        _buildField(
          label: 'Password',
          hint: 'Min. 8 characters',
          controller: _passwordController,
          icon: Icons.lock_outline_rounded,
          error: _passwordError,
          obscure: _obscurePassword,
          onChanged: _onPasswordChanged,
          suffix: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: _textLight,
              ),
            ),
          ),
        ),

        // ── Strength bar ──────────────────────────────────
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildStrengthBar(),
        ],

        const SizedBox(height: 28),

        // ── Divider ───────────────────────────────────────
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: const Color(0xFFDB4437),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialButton(
                label: 'Apple',
                icon: Icons.apple_rounded,
                iconColor: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Continue button ───────────────────────────────
        _buildPrimaryButton(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          onTap: _nextStep,
        ),

        const SizedBox(height: 20),

        // ── Sign in ───────────────────────────────────────
        Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).pop(false),
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account?  ',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  color: _textLight,
                ),
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: _darkSage,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Step 2: Baby info ───────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Baby's journey card ───────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _mintCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Personalize your experience',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Tell us about your little one and we\'ll show you age-appropriate products, tips, and milestone guides.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Date picker ───────────────────────────────────
        const Text(
          'Birthday or Due Date',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textMid,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: _softWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _selectedDate != null ? _sage : Colors.grey.shade200,
                width: _selectedDate != null ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: _selectedDate != null ? _sage : _textLight,
                ),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'Select a date',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: _selectedDate != null ? _textDark : _textLight,
                    fontWeight: _selectedDate != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (_selectedDate != null)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _sage,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Optional note ─────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _sage.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: _sage.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'This is optional — you can skip and add it later in your profile.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 11.5,
                    color: _textMid,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── Membership preview ────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _softWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Color(0xFFE6A817),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platinum Member — unlocked',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      'Exclusive deals, early access & free gift wrap',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 11,
                        color: _textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // ── Register button ───────────────────────────────
        _buildPrimaryButton(
          label: 'Start Your Journey',
          icon: Icons.arrow_forward_rounded,
          onTap: _isLoading ? null : _register,
          isLoading: _isLoading,
        ),

        const SizedBox(height: 16),

        // ── Terms ─────────────────────────────────────────
        Center(
          child: Text(
            'By registering you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ],
    );
  }

  // ── Step dot indicator ──────────────────────────────────────────
  Widget _buildStepDot(int step) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isDone
            ? _sage
            : isActive
            ? _darkSage
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // ── Strength bar ────────────────────────────────────────────────
  Widget _buildStrengthBar() {
    final strength = _passwordStrength;
    final labels = ['Too short', 'Weak', 'Fair', 'Good', 'Strong'];
    final colors = [
      Colors.red.shade300,
      Colors.orange.shade300,
      Colors.amber.shade500,
      Colors.lightGreen.shade500,
      Colors.green.shade500,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            4,
            (i) => Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 4),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i < strength ? colors[strength] : Colors.grey.shade200,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          labels[strength],
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: colors[strength],
          ),
        ),
      ],
    );
  }

  // ── Primary button ──────────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: onTap == null ? _darkSage.withOpacity(0.5) : _darkSage,
          borderRadius: BorderRadius.circular(16),
          boxShadow: onTap == null
              ? []
              : [
                  BoxShadow(
                    color: _darkSage.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, color: Colors.white, size: 18),
                  ],
                ),
        ),
      ),
    );
  }

  // ── Field builder ────────────────────────────────────────────────
  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? error,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    void Function(String)? onChanged,
  }) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _textMid,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: hasError ? Colors.red.shade50 : _softWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? _errorRed.withOpacity(0.4)
                  : Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  icon,
                  size: 18,
                  color: hasError ? _errorRed : _textLight,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: _textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      color: _textLight,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: 5, left: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 12,
                        color: _errorRed,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        error,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 11,
                          color: _errorRed,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  // ── Social button ────────────────────────────────────────────────
  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: _softWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }
}
