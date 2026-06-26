import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_store_app/state/user_provider.dart';
import 'package:baby_store_app/services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Color palette ──────────────────────────────────────────────
  static const Color _sage = Color(0xFF7A9E8E);
  static const Color _darkSage = Color(0xFF3D6255);
  static const Color _cream = Color(0xFFF7F3EC);
  static const Color _softWhite = Color(0xFFFBF9F6);
  static const Color _textDark = Color(0xFF2C2C2C);
  static const Color _textMid = Color(0xFF6B6B6B);
  static const Color _textLight = Color(0xFFAAAAAA);
  static const Color _errorRed = Color(0xFFE05A5A);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validators ─────────────────────────────────────────────────
  String? _validateEmail(String v) {
    if (v.trim().isEmpty) return 'Email is required';
    final reg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!reg.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return 'Password is required';
    return null;
  }

  void _onEmailChanged(String v) {
    if (_emailError != null) setState(() => _emailError = _validateEmail(v));
  }

  void _onPasswordChanged(String v) {
    if (_passwordError != null) setState(() => _passwordError = _validatePassword(v));
  }

  void _handleLogin() async {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() => _isLoading = true);

    try {
      final userProfile = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userProfile != null) {
        ref.read(userProvider.notifier).state = userProfile;
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() => _passwordError = 'Invalid email or password');
      }
    } catch (e) {
      print("Login error: $e");
    }

    setState(() => _isLoading = false);
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              size: 36,
                              color: _sage,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Log in to continue your baby\'s journey.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: _textLight,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

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
                      hint: 'Enter your password',
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

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _darkSage,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildPrimaryButton(
                      label: 'Log In',
                      icon: Icons.login_rounded,
                      onTap: _isLoading ? null : _handleLogin,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 24),

                    // ── Divider ───────────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'OR',
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
                    const SizedBox(height: 24),

                    _buildSocialButton(
                      label: 'Continue with Google',
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: const Color(0xFFDB4437),
                      onTap: () async {
                        final profile = await AuthService.signInWithGoogle();
                        if (profile != null) {
                          ref.read(userProvider.notifier).state = profile;
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, '/');
                        }
                      },
                    ),

                    const SizedBox(height: 32),

                    // ── Sign up ───────────────────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Don\'t have an account?  ',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: _textLight,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Text(
              error,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: _errorRed,
              ),
            ),
          ),
      ],
    );
  }

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
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, color: Colors.white, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _softWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
